import SwiftUI
import Combine
import KadigaramCore

@MainActor
class AlarmListViewModel: ObservableObject {
    @Published var alarms: [NazhigaiAlarm] = [] {
        didSet {
            saveAlarms()
        }
    }
    
    private let userDefaults = UserDefaults.standard
    private let storageKey = "kNazhigaiAlarms"
    
    init() {
        loadAlarms()
    }
    
    func addAlarm(_ alarm: NazhigaiAlarm) {
        alarms.append(alarm)
    }
    
    func removeAlarm(at offsets: IndexSet) {
        alarms.remove(atOffsets: offsets)
    }
    
    func updateAlarm(_ alarm: NazhigaiAlarm) {
        if let index = alarms.firstIndex(where: { $0.id == alarm.id }) {
            alarms[index] = alarm
        }
    }
    
    func toggleAlarm(id: UUID, isEnabled: Bool) {
        if let index = alarms.firstIndex(where: { $0.id == id }) {
            alarms[index].isEnabled = isEnabled
        }
    }
    
    func toggleSystemClock(id: UUID, addToSystemClock: Bool) {
        if let index = alarms.firstIndex(where: { $0.id == id }) {
            alarms[index].addToSystemClock = addToSystemClock
        }
    }
    
    private func loadAlarms() {
        if let data = userDefaults.data(forKey: storageKey) {
            if let decoded = try? JSONDecoder().decode([NazhigaiAlarm].self, from: data) {
                self.alarms = decoded
                return
            }
        }
        self.alarms = []
    }
    
    private func saveAlarms() {
        if let encoded = try? JSONEncoder().encode(alarms) {
            userDefaults.set(encoded, forKey: storageKey)
        }
        reschedule()
    }
    
    private func reschedule() {
        Task {
            // Request notification auth
            _ = try? await NotificationService.shared.requestAuthorization()
            await NotificationService.shared.scheduleAlarms(alarms)
            
            // Sync to AlarmKit (iOS 26+)
            if #available(iOS 26, *) {
                print("🔔 AlarmListViewModel: Starting AlarmKit sync...")
                
                do {
                    let authorized = try await AlarmKitService.shared.requestAuthorization()
                    print("🔔 AlarmListViewModel: AlarmKit authorization = \(authorized)")
                    
                    if !authorized {
                        print("⚠️ AlarmListViewModel: AlarmKit not authorized!")
                        return
                    }
                } catch {
                    print("❌ AlarmListViewModel: AlarmKit authorization failed: \(error)")
                    return
                }
                
                let alarmsToSync = alarms.filter { $0.addToSystemClock && $0.isEnabled }
                print("🔔 AlarmListViewModel: Found \(alarmsToSync.count) alarms to sync to Clock")
                
                let updatedAlarms = await AlarmKitService.shared.syncAllAlarmsToSystemClock(alarms)
                print("🔔 AlarmListViewModel: Sync complete, updated \(updatedAlarms.count) alarms")
                
                // Update alarms with systemAlarmId without triggering didSet loop
                for (index, updated) in updatedAlarms.enumerated() {
                    if alarms.indices.contains(index) && alarms[index].systemAlarmId != updated.systemAlarmId {
                        // Direct mutation to avoid infinite loop
                        if let encoded = try? JSONEncoder().encode(updatedAlarms) {
                            userDefaults.set(encoded, forKey: storageKey)
                        }
                        break
                    }
                }
            }
        }
    }
}

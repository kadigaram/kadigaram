import SwiftUI
import Combine
import CoreLocation
import KadigaramCore
import SixPartsLib

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
        // Cleanup system alarms before removing
        Task {
            if #available(iOS 26, *) {
                for index in offsets {
                    let alarm = alarms[index]
                    if let systemAlarmId = alarm.systemAlarmId {
                        do {
                            try await AlarmKitService.shared.deleteSystemAlarm(id: systemAlarmId)
                            print("🗑️ AlarmListViewModel: Deleted system alarm \(systemAlarmId) for alarm '\(alarm.label)'")
                        } catch {
                            print("❌ AlarmListViewModel: Failed to delete system alarm: \(error)")
                        }
                    }
                }
            }
        }
        
        // Remove from array
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
            
            // Schedule notifications (NotificationService already uses SixPartsLib.calculateDate)
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
                
                guard let location = LocationManager.shared.location else {
                    print("⚠️ AlarmListViewModel: No location available for AlarmKit sync")
                    return
                }
                
                let calendar = Calendar.current
                
                // Iterate over each alarm
                for alarm in alarms {
                    if alarm.addToSystemClock && alarm.isEnabled {
                        // Calculate next occurrence (starting from today, then tomorrow if needed)
                        var targetDate: Date?
                        let now = Date()
                        
                        print("🔍 AlarmListViewModel: Calculating next occurrence for '\(alarm.label)' (Nazhigai \(alarm.nazhigai):\(alarm.vinazhigai))")
                        
                        // Try today's sunrise first
                        let todayDate = SixPartsLib.calculateDate(
                            nazhigai: alarm.nazhigai,
                            vinazhigai: alarm.vinazhigai,
                            on: now,
                            location: location
                        )
                        
                        if let todayDate = todayDate {
                            let timeUntil = todayDate.timeIntervalSince(now)
                            print("   📅 Today's calculation: \(todayDate), time until: \(timeUntil/3600) hours")
                            
                            if todayDate > now {
                                // Calculation is in the future, use it
                                targetDate = todayDate
                                print("   ✅ Using today's calculation (alarm is in future)")
                            } else {
                                // Today's calculation is in past, try tomorrow
                                print("   ⏭️ Today's calculation is in past, trying tomorrow")
                                if let tomorrow = calendar.date(byAdding: .day, value: 1, to: now),
                                   let tomorrowDate = SixPartsLib.calculateDate(
                                    nazhigai: alarm.nazhigai,
                                    vinazhigai: alarm.vinazhigai,
                                    on: tomorrow,
                                    location: location
                                   ) {
                                    targetDate = tomorrowDate
                                    print("   📅 Tomorrow's calculation: \(tomorrowDate)")
                                }
                            }
                        } else {
                            print("   ❌ Failed to calculate date for today")
                        }
                        
                        if let targetDate = targetDate {
                            do {
                                let alarmId = try await AlarmKitService.shared.createOrUpdateSystemAlarm(
                                    for: alarm,
                                    targetDate: targetDate
                                )
                                
                                // Update alarm with systemAlarmId
                                if let index = alarms.firstIndex(where: { $0.id == alarm.id }),
                                   alarms[index].systemAlarmId != alarmId {
                                    alarms[index].systemAlarmId = alarmId
                                    
                                    // Save without triggering reschedule
                                    if let encoded = try? JSONEncoder().encode(alarms) {
                                        userDefaults.set(encoded, forKey: storageKey)
                                    }
                                }
                            } catch {
                                print("❌ AlarmListViewModel: Failed to schedule system alarm: \(error)")
                            }
                        }
                    } else if !alarm.addToSystemClock, let systemId = alarm.systemAlarmId {
                        // Remove system alarm if toggle is off
                        do {
                            try await AlarmKitService.shared.deleteSystemAlarm(id: systemId)
                            
                            if let index = alarms.firstIndex(where: { $0.id == alarm.id }) {
                                alarms[index].systemAlarmId = nil
                                
                                if let encoded = try? JSONEncoder().encode(alarms) {
                                    userDefaults.set(encoded, forKey: storageKey)
                                }
                            }
                        } catch {
                            print("❌ AlarmListViewModel: Failed to delete system alarm: \(error)")
                        }
                    }
                }
            }
        }
    }
}

import Foundation
import BackgroundTasks
import CoreLocation
import KadigaramCore
import SixPartsLib

/// Manages background tasks for daily alarm synchronization
@MainActor
public final class BackgroundTaskManager {
    public static let shared = BackgroundTaskManager()
    
    /// Background task identifier for alarm sync
    public static let alarmSyncTaskIdentifier = "com.kadigaram.alarmSync"
    
    private init() {}
    
    // MARK: - Registration
    
    /// Register background tasks with the system. Call this in app delegate/app init.
    public func registerBackgroundTasks() {
        BGTaskScheduler.shared.register(
            forTaskWithIdentifier: Self.alarmSyncTaskIdentifier,
            using: nil
        ) { task in
            Task { @MainActor in
                await self.handleAlarmSyncTask(task as! BGAppRefreshTask)
            }
        }
        print("📋 BackgroundTaskManager: Registered background tasks")
    }
    
    // MARK: - Scheduling
    
    /// Schedule the next alarm sync background task
    public func scheduleAlarmSyncTask() {
        let request = BGAppRefreshTaskRequest(identifier: Self.alarmSyncTaskIdentifier)
        
        // Schedule to run every hour for frequent alarm updates
        // Note: iOS does not guarantee exact timing - this is the *earliest* the task can run
        request.earliestBeginDate = Date(timeIntervalSinceNow: 60 * 60) // 1 hour from now
        
        do {
            try BGTaskScheduler.shared.submit(request)
            print("⏰ BackgroundTaskManager: Scheduled alarm sync for ~1 hour from now (\(request.earliestBeginDate ?? Date()))")
        } catch {
            print("❌ BackgroundTaskManager: Failed to schedule alarm sync: \(error)")
        }
    }
    
    // MARK: - Task Handling
    
    /// Handle the alarm sync background task
    private func handleAlarmSyncTask(_ task: BGAppRefreshTask) async {
        print("🔄 BackgroundTaskManager: Starting alarm sync task")
        
        // Set up expiration handler
        task.expirationHandler = {
            print("⚠️ BackgroundTaskManager: Task expired")
            task.setTaskCompleted(success: false)
        }
        
        // Schedule the next sync
        scheduleAlarmSyncTask()
        
        // Perform the sync
        await syncAlarms()
        task.setTaskCompleted(success: true)
        print("✅ BackgroundTaskManager: Alarm sync completed")
    }
    
    // MARK: - Sync Logic
    
    /// Sync all alarms - verify and update both notifications and system clock alarms
    /// This is called by background tasks to ensure alarms are scheduled at correct times
    public func syncAlarms() async {
        let storageKey = "kNazhigaiAlarms"
        
        // Load alarms from UserDefaults
        guard let data = UserDefaults.standard.data(forKey: storageKey),
              var alarms = try? JSONDecoder().decode([NazhigaiAlarm].self, from: data) else {
            print("📭 BackgroundTaskManager: No alarms to sync")
            return
        }
        
        guard let location = LocationManager.shared.location else {
            print("⚠️ BackgroundTaskManager: No location available for sync")
            return
        }
        
        print("🔄 BackgroundTaskManager: Syncing \(alarms.count) alarms...")
        
        let calendar = Calendar.current
        var alarmsUpdated = false
        
        // 1. Sync to notification service (reschedules for next 7 days)
        await NotificationService.shared.scheduleAlarms(alarms)
        
        // 2. Sync to AlarmKit (iOS 26+) - verify and update each alarm
        if #available(iOS 26, *) {
            for (index, alarm) in alarms.enumerated() {
                guard alarm.isEnabled else { continue }
                
                if alarm.addToSystemClock {
                    // Calculate next occurrence
                    var targetDate: Date?
                    
                    // Try today first
                    if let todayDate = SixPartsLib.calculateDate(
                        nazhigai: alarm.nazhigai,
                        vinazhigai: alarm.vinazhigai,
                        on: Date(),
                        location: location
                    ), todayDate > Date() {
                        targetDate = todayDate
                    } else {
                        // Try tomorrow
                        if let tomorrow = calendar.date(byAdding: .day, value: 1, to: Date()),
                           let tomorrowDate = SixPartsLib.calculateDate(
                            nazhigai: alarm.nazhigai,
                            vinazhigai: alarm.vinazhigai,
                            on: tomorrow,
                            location: location
                           ) {
                            targetDate = tomorrowDate
                        }
                    }
                    
                    if let targetDate = targetDate {
                        do {
                            // Create or update system alarm with calculated date
                            let alarmId = try await AlarmKitService.shared.createOrUpdateSystemAlarm(
                                for: alarm,
                                targetDate: targetDate
                            )
                            
                            // Update systemAlarmId if changed
                            if alarms[index].systemAlarmId != alarmId {
                                alarms[index].systemAlarmId = alarmId
                                alarmsUpdated = true
                                print("✅ BackgroundTaskManager: Updated system alarm for '\(alarm.label)' to \(targetDate)")
                            } else {
                                print("✓ BackgroundTaskManager: Verified system alarm for '\(alarm.label)' is correct")
                            }
                        } catch {
                            print("❌ BackgroundTaskManager: Failed to sync alarm '\(alarm.label)': \(error)")
                        }
                    }
                } else if let systemId = alarm.systemAlarmId {
                    // Alarm has system alarm but toggle is off - remove it
                    do {
                        try await AlarmKitService.shared.deleteSystemAlarm(id: systemId)
                        alarms[index].systemAlarmId = nil
                        alarmsUpdated = true
                        print("🗑️ BackgroundTaskManager: Removed system alarm (toggle disabled)")
                    } catch {
                        print("❌ BackgroundTaskManager: Failed to delete system alarm: \(error)")
                    }
                }
            }
            
            // Save updated alarms if any changes
            if alarmsUpdated {
                if let encoded = try? JSONEncoder().encode(alarms) {
                    UserDefaults.standard.set(encoded, forKey: storageKey)
                    print("💾 BackgroundTaskManager: Saved updated alarms")
                }
            }
        }
        
        print("✅ BackgroundTaskManager: Sync complete")
    }
}

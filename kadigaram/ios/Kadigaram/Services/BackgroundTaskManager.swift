import Foundation
import BackgroundTasks
import KadigaramCore

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
    
    /// Sync all alarms - both notifications and system clock
    public func syncAlarms() async {
        let storageKey = "kNazhigaiAlarms"
        
        // Load alarms from UserDefaults
        guard let data = UserDefaults.standard.data(forKey: storageKey),
              var alarms = try? JSONDecoder().decode([NazhigaiAlarm].self, from: data) else {
            print("📭 BackgroundTaskManager: No alarms to sync")
            return
        }
        
        // Sync to notification service
        await NotificationService.shared.scheduleAlarms(alarms)
        
        // Sync to AlarmKit (iOS 26+)
        if #available(iOS 26, *) {
            alarms = await AlarmKitService.shared.syncAllAlarmsToSystemClock(alarms)
            
            // Save updated alarms with systemAlarmId
            if let encoded = try? JSONEncoder().encode(alarms) {
                UserDefaults.standard.set(encoded, forKey: storageKey)
            }
        }
        
        print("📅 BackgroundTaskManager: Synced \(alarms.count) alarms")
    }
}

import CoreLocation
import UserNotifications
import KadigaramCore
import SixPartsLib

@MainActor
public final class NotificationService: NSObject {
    public static let shared = NotificationService()
    private let center = UNUserNotificationCenter.current()
    private let locationManager = LocationManager.shared
    
    override private init() {
        super.init()
        center.delegate = self
        setupCategories()
    }
    
    private func setupCategories() {
        // Define Snooze Action
        let snoozeAction = UNNotificationAction(identifier: "SNOOZE_ACTION",
                                              title: "Snooze (9 mins)",
                                              options: [])
        
        let category = UNNotificationCategory(identifier: "NAZHIGAI_ALARM",
                                            actions: [snoozeAction],
                                            intentIdentifiers: [],
                                            options: .customDismissAction)
        
        center.setNotificationCategories([category])
    }
    
    // Helper to reschedule from background/app launch
    public func rescheduleFromPersistence() {
        Task {
            let storageKey = "kNazhigaiAlarms"
            if let data = UserDefaults.standard.data(forKey: storageKey),
               let alarms = try? JSONDecoder().decode([NazhigaiAlarm].self, from: data) {
                await scheduleAlarms(alarms)
            }
        }
    }
    
    public func requestAuthorization() async throws -> Bool {
        var options: UNAuthorizationOptions = [.alert, .sound, .badge]
        // Request Critical Alert entitlement if available/needed
        options.insert(.criticalAlert)
        
        return try await center.requestAuthorization(options: options)
    }
    
    public func scheduleAlarms(_ alarms: [NazhigaiAlarm], forDays days: Int = 7) async {
        // 1. Cancel all existing requests to avoid duplicates/limit
        center.removeAllPendingNotificationRequests()
        
        // 2. Filter enabled alarms
        let enabledAlarms = alarms.filter { $0.isEnabled }
        guard !enabledAlarms.isEmpty else { return }
        
        // 3. Get Location (Wait for location if needed?)
        // Assuming LocationManager has a current location cached or we can use it.
        // If not, we might need to wait, but for now we'll use last known.
        guard let location = locationManager.location else {
            print("⚠️ NotificationService: No location available for scheduling")
            return
        }
        
        print("📅 NotificationService: Scheduling \(enabledAlarms.count) alarms for \(days) days at location: \(location.latitude), \(location.longitude)")
        
        let calendar = Calendar.current
        let today = Date()
        
        // 4. Loop through days
        for dayOffset in 0..<days {
            guard let date = calendar.date(byAdding: .day, value: dayOffset, to: today) else { continue }
            
            for alarm in enabledAlarms {
                // Calculate target date
                if let targetDate = SixPartsLib.calculateDate(nazhigai: alarm.nazhigai,
                                                            vinazhigai: alarm.vinazhigai,
                                                            on: date,
                                                            location: location) {
                    
                    // Only schedule if it's in the future
                    if targetDate > Date() {
                        print("🔔 Scheduling alarm '\(alarm.label.isEmpty ? "Nazhigai Alarm" : alarm.label)' for \(targetDate)")
                        scheduleNotification(for: alarm, at: targetDate)
                    }
                }
            }
        }
    }
    
    private func scheduleNotification(for alarm: NazhigaiAlarm, at date: Date) {
        let content = UNMutableNotificationContent()
        content.title = alarm.label.isEmpty ? "Nazhigai Alarm" : alarm.label
        content.body = "It's \(alarm.nazhigai) Nazhigai : \(alarm.vinazhigai) Vinazhigai"
        content.sound = UNNotificationSound.defaultCritical  // Louder, bypasses some DND settings
        content.categoryIdentifier = "NAZHIGAI_ALARM"
        content.interruptionLevel = .timeSensitive  // More prominent notification
        
        // Create Trigger
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        
        // Unique ID: AlarmID + Date
        let uuid = "\(alarm.id.uuidString)-\(Int(date.timeIntervalSince1970))"
        let request = UNNotificationRequest(identifier: uuid, content: content, trigger: trigger)
        
        center.add(request) { error in
            if let error = error {
                print("Error scheduling alarm: \(error)")
            }
        }
    }
}

extension NotificationService: UNUserNotificationCenterDelegate {
    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Show notification even when app is in foreground
        completionHandler([.banner, .sound, .list])
    }
    
    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let identifier = response.actionIdentifier
        
        if identifier == "SNOOZE_ACTION" {
            // Schedule snooze for 9 minutes (540 seconds)
            let content = response.notification.request.content
            let snoozeTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 540, repeats: false)
            let request = UNNotificationRequest(identifier: response.notification.request.identifier + "-SNOOZE",
                                              content: content,
                                              trigger: snoozeTrigger)
            center.add(request)
        }
        
        // Also trigger recalculation if app opened
        if identifier == UNNotificationDefaultActionIdentifier {
             // App opened. Reschedule all alarms to refresh 7-day buffer.
             // We can't access ViewModel safely here, but we can post a notification or expect the sceneDidBecomeActive to handle it.
             // Since sceneDidBecomeActive handles it (US5), we assume that covers it.
        }
        
        completionHandler()
    }
}

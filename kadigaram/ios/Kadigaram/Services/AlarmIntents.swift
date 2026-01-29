import Foundation
import AppIntents

#if canImport(AlarmKit)
import AlarmKit
#endif

// MARK: - Stop Alarm Intent

/// App Intent to stop a Nazhigai alarm
/// Required by AlarmKit for the Stop button on alarm alerts
@available(iOS 26, *)
struct StopNazhigaiAlarmIntent: LiveActivityIntent {
    static var title: LocalizedStringResource = "Stop Alarm"
    static var description = IntentDescription("Stops the Nazhigai alarm")
    
    /// The alarm ID to stop
    @Parameter(title: "Alarm ID")
    var alarmId: String?
    
    init() {}
    
    init(alarmId: String) {
        self.alarmId = alarmId
    }
    
    @MainActor
    func perform() async throws -> some IntentResult {
        print("🛑 StopNazhigaiAlarmIntent: Stopping alarm \(alarmId ?? "unknown")")
        // The alarm is already stopped by the system when this intent runs
        // We can add any cleanup logic here if needed
        return .result()
    }
}

// MARK: - Snooze Alarm Intent

/// App Intent to snooze a Nazhigai alarm
/// Required by AlarmKit for the Snooze button on alarm alerts
@available(iOS 26, *)
struct SnoozeNazhigaiAlarmIntent: LiveActivityIntent {
    static var title: LocalizedStringResource = "Snooze Alarm"
    static var description = IntentDescription("Snoozes the Nazhigai alarm for 9 minutes")
    
    /// The alarm ID to snooze
    @Parameter(title: "Alarm ID")
    var alarmId: String?
    
    /// Snooze duration in seconds (default 9 minutes = 540 seconds)
    @Parameter(title: "Snooze Duration", default: 540)
    var snoozeDuration: Int
    
    init() {
        self.snoozeDuration = 540
    }
    
    init(alarmId: String, snoozeDuration: Int = 540) {
        self.alarmId = alarmId
        self.snoozeDuration = snoozeDuration
    }
    
    @MainActor
    func perform() async throws -> some IntentResult {
        print("💤 SnoozeNazhigaiAlarmIntent: Snoozing alarm \(alarmId ?? "unknown") for \(snoozeDuration) seconds")
        // The snooze is handled by the system based on the secondaryButtonBehavior
        // We can add any custom snooze logic here if needed
        return .result()
    }
}

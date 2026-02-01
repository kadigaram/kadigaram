import Foundation
import CoreLocation
import KadigaramCore
import SixPartsLib
import SwiftUI

#if canImport(AlarmKit)
import AlarmKit
import ActivityKit
#endif

// MARK: - Alarm Metadata

/// Custom metadata for Nazhigai alarms - required by AlarmKit
#if canImport(AlarmKit)
@available(iOS 26, *)
struct NazhigaiAlarmMetadata: AlarmMetadata {
    var alarmId: String
    var nazhigai: Int
    var vinazhigai: Int
    var label: String
}
#endif

// MARK: - AlarmKit Service

/// Service for managing system Clock app alarms via AlarmKit (iOS 26+)
/// Based on official Apple AlarmKit documentation
@available(iOS 26, *)
@MainActor
public final class AlarmKitService {
    public static let shared = AlarmKitService()
    
    private let locationManager = LocationManager.shared
    
    private init() {}
    
    // MARK: - Authorization
    
    /// Request authorization to create alarms
    /// Returns true if authorized
    public func requestAuthorization() async throws -> Bool {
        #if canImport(AlarmKit)
        let state = try await AlarmManager.shared.requestAuthorization()
        return state == .authorized
        #else
        return false
        #endif
    }
    
    /// Check current authorization status
    public var authorizationState: Bool {
        #if canImport(AlarmKit)
        return AlarmManager.shared.authorizationState == .authorized
        #else
        return false
        #endif
    }
    
    // MARK: - Alarm Management
    
    /// Create or update a system alarm for the given Nazhigai alarm
    /// - Parameters:
    ///   - alarm: The NazhigaiAlarm to create a system alarm for
    ///   - targetDate: The target date for the alarm
    /// - Returns: The system alarm ID as String
    public func createOrUpdateSystemAlarm(for alarm: NazhigaiAlarm, targetDate: Date) async throws -> String? {
        #if canImport(AlarmKit)
        // Use the NazhigaiAlarm's own ID as the AlarmKit alarm ID
        let alarmID = alarm.id
        
        // Cancel existing alarm first before rescheduling with same ID
        // This prevents AlarmKit Error Code=0 "alarm already exists"
        do {
            try AlarmManager.shared.cancel(id: alarmID)
            print("🔔 AlarmKitService: Canceled existing alarm \(alarmID) before rescheduling")
        } catch {
            // Alarm might not exist yet, that's fine
            print("🔔 AlarmKitService: Could not cancel (may not exist): \(error.localizedDescription)")
        }
        
        let title = alarm.label.isEmpty ? "Nazhigai Alarm" : alarm.label
        
        // 1. Create the Schedule - use .fixed for a one-shot alarm at a specific date
        let schedule = Alarm.Schedule.fixed(targetDate)
        
        // 2. Create buttons
        let stopButton = AlarmButton(
            text: LocalizedStringResource(stringLiteral: "Stop"),
            textColor: Color.red,
            systemImageName: "stop.circle.fill"
        )
        
        let snoozeButton = AlarmButton(
            text: LocalizedStringResource(stringLiteral: "Snooze"),
            textColor: Color.blue,
            systemImageName: "clock.arrow.2.circlepath"
        )
        
        // 3. Create the Presentation with Alert
        // Using deprecated init for iOS 26.0 compatibility (newer init requires iOS 26.1+)
        // Silence deprecation warning since we need 26.0 support
        let presentation: AlarmPresentation
        if #available(iOS 26.1, *) {
            // Use modern init without stopButton (system-provided)
            let alert = AlarmPresentation.Alert(
                title: LocalizedStringResource(stringLiteral: title),
                secondaryButton: snoozeButton,
                secondaryButtonBehavior: .countdown
            )
            presentation = AlarmPresentation(alert: alert)
        } else {
            // iOS 26.0 - use deprecated init with explicit stopButton
            let alert = AlarmPresentation.Alert(
                title: LocalizedStringResource(stringLiteral: title),
                stopButton: stopButton,
                secondaryButton: snoozeButton,
                secondaryButtonBehavior: .countdown
            )
            presentation = AlarmPresentation(alert: alert)
        }
        
        // 4. Create Metadata
        let metadata = NazhigaiAlarmMetadata(
            alarmId: alarmID.uuidString,
            nazhigai: alarm.nazhigai,
            vinazhigai: alarm.vinazhigai,
            label: alarm.label
        )
        
        // 5. Set Attributes with presentation, metadata, and tint color
        let attributes = AlarmAttributes<NazhigaiAlarmMetadata>(
            presentation: presentation,
            metadata: metadata,
            tintColor: .orange
        )
        
        // 6. Create App Intents for alarm buttons (REQUIRED for AlarmKit to work)
        let stopIntent = StopNazhigaiAlarmIntent(alarmId: alarmID.uuidString)
        let snoozeIntent = SnoozeNazhigaiAlarmIntent(alarmId: alarmID.uuidString)
        
        // 7. Create configuration with App Intents
        let sound: AlertConfiguration.AlertSound = .default
        let configuration = AlarmManager.AlarmConfiguration<NazhigaiAlarmMetadata>(
            countdownDuration: nil,
            schedule: schedule,
            attributes: attributes,
            stopIntent: stopIntent,
            secondaryIntent: snoozeIntent,
            sound: sound
        )
        
        // 7. Schedule via Manager
        _ = try await AlarmManager.shared.schedule(id: alarmID, configuration: configuration)
        
        let formatter = ISO8601DateFormatter()
        print("🔔 AlarmKitService: SYSTEM ALARM SCHEDULED | Alarm: '\(title)' | ID: \(alarmID) | Nazhigai: \(alarm.nazhigai):\(alarm.vinazhigai) | Target: \(formatter.string(from: targetDate)) | Sound: \(sound)")
        
        return alarmID.uuidString
        
        #else
        print("⚠️ AlarmKitService: AlarmKit not available in this SDK")
        return nil
        #endif
    }
    
    /// Delete a system alarm
    public func deleteSystemAlarm(id: String) async throws {
        #if canImport(AlarmKit)
        guard let uuid = UUID(uuidString: id) else {
            print("⚠️ AlarmKitService: Invalid alarm ID: \(id)")
            return
        }
        
        try AlarmManager.shared.cancel(id: uuid)
        print("🗑️ AlarmKitService: Canceled system alarm \(id)")
        #endif
    }
    
    /// Sync all alarms with "Add to Clock" enabled to the system Clock app
    /// - Parameter alarms: All NazhigaiAlarm objects
    /// - Returns: Updated alarms with systemAlarmId populated
    public func syncAllAlarmsToSystemClock(_ alarms: [NazhigaiAlarm]) async -> [NazhigaiAlarm] {
        #if canImport(AlarmKit)
        var updatedAlarms = alarms
        
        guard let location = locationManager.location else {
            print("⚠️ AlarmKitService: No location available for sync")
            return alarms
        }
        
        // Calculate tomorrow's date
        let calendar = Calendar.current
        guard let tomorrow = calendar.date(byAdding: .day, value: 1, to: Date()) else {
            return alarms
        }
        
        let alarmsToSync = alarms.filter { $0.addToSystemClock && $0.isEnabled }
        print("📅 AlarmKitService: Syncing \(alarmsToSync.count) alarms to system Clock...")
        
        for (index, alarm) in alarms.enumerated() {
            if alarm.addToSystemClock && alarm.isEnabled {
                // Calculate the alarm time using centralized logic (handles Today/Tomorrow & Noon Normalization)
                if let targetDate = SixPartsLib.calculateNextOccurrence(
                    nazhigai: alarm.nazhigai,
                    vinazhigai: alarm.vinazhigai,
                    from: Date(),
                    location: location
                ) {
                    print("🐞 AlarmKitService: Calculated Target via Lib: \(targetDate)")
                    finalTargetDate = targetDate
                } else {
                    print("❌ AlarmKitService: Failed to calculate next occurrence via Lib")
                }
                
                if let targetDate = finalTargetDate {
                    do {
                        if let alarmId = try await createOrUpdateSystemAlarm(for: alarm, targetDate: targetDate) {
                            updatedAlarms[index].systemAlarmId = alarmId
                        }
                    } catch {
                        print("❌ AlarmKitService: Failed to sync alarm: \(error)")
                    }
                }
            } else if !alarm.addToSystemClock, let systemId = alarm.systemAlarmId {
                // Remove system alarm if toggle is off
                do {
                    try await deleteSystemAlarm(id: systemId)
                    updatedAlarms[index].systemAlarmId = nil
                } catch {
                    print("❌ AlarmKitService: Failed to delete alarm: \(error)")
                }
            }
        }
        
        return updatedAlarms
        #else
        return alarms
        #endif
    }
}

// MARK: - Availability Helper

/// Check if AlarmKit is available on this device
public func isAlarmKitAvailable() -> Bool {
    if #available(iOS 26, *) {
        return true
    }
    return false
}

# Feature 007: Nazhigai Alarm

## 1. Goal
Enable users to set alarms based on **Vedic Time (Nazhigai and Vinazhigai)**. Unlike standard solar alarms, these alarms track the sun's position relative to the user's location (Sunrise).

## 2. User Stories
- **US-1**: As a user, I want to set an alarm for a specific Nazhigai (0-59) and Vinazhigai (0-59) so that I am reminded at that Vedic time.
- **US-2**: As a user, I want to see a list of my set alarms.
- **US-3**: As a user, I want to toggle alarms on/off without deleting them.
- **US-4**: As a user, I want the alarm to ring even if the app is in the background.
- **US-5**: As a user, I want the alarm time to automatically adjust for tomorrow's sunrise (since 10 Nazhigai today is not the same wall-clock time as 10 Nazhigai tomorrow).
- **US-6**: As a user, I want to add a custom text label to each alarm (e.g., "Brahma Muhurtam") to remember its purpose.
- **US-7**: As a user, I want to be able to **Snooze** the alarm when it rings (standard 9-minute snooze).

## 3. Technical Approach

### 3.1 Time Calculation
- **Nazhigai**: 1 Nazhigai = 24 minutes (approx).
- **Vinazhigai**: 1 Vinazhigai = 24 seconds (approx).
- **Formula**: `TargetDate = SunriseTime + (Nazhigai * 24 min) + (Vinazhigai * 24 sec)` (Approximation).
- **Precise Formula**: Use `VedicEngine` or `SixPartsLib` to reverse-calculate the exact `Date` where `currentNazhigai == targetNazhigai`.
    - Since `VedicTime` is elapsed time since sunrise:
    - Target Seconds from Sunrise = `(Nazhigai * 60 + Vinazhigai) * 24`. (Assuming standard 60 Nadika/Nazhigai per 24 hours).
    - Actually, 1 day = 60 Nazhigai.
    - 24 hours = 1440 minutes.
    - 1 Nazhigai = 1440 / 60 = 24 minutes.
    - 1 Vinazhigai = 24 minutes / 60 = 0.4 minutes = 24 seconds.
    - **Logic**: For each upcoming day (Today, Tomorrow, etc.), get the `Sunrise` time for the user's location. Add the calculated offset.

### 3.2 Scheduling Strategy
- iOS `UserNotifications` requires a fixed `Date` or `TimeInterval` trigger.
- Since the "Effective Time" changes daily based on Sunrise, we cannot use a simple repeating daily trigger.
- **Strategy**: "Schedule Ahead".
    - When the user sets an alarm, we calculate the wall-clock time for this Nazhigai for the next **7 days** and schedule 7 distinct notifications.
    - **Recalculation Trigger**: Acccording to user refinement, when the alarm rings and the user opens the app, this **triggers the recalculation** of the schedule (e.g., replenishing the 7-day buffer).
    - If the user does not open the app for 7 days, alarms will stop ringing (accepted limitation).
    - We limit the total notifications to avoid the iOS 64-notification limit (e.g., max 5 active alarms * 7 days = 35 notifications).

### 3.3 Data Persistence
- Use `UserDefaults` to store the Alarm configuration.
- **Model**:
```swift
struct NazhigaiAlarm: Codable, Identifiable {
    let id: UUID
    var nazhigai: Int
    var vinazhigai: Int
    var label: String?
    var isEnabled: Bool
}
```

## 4. UI Requirements
- **Alarm List View**: Shows configured alarms. Displays the *next* estimated wall-clock time for context (e.g., "10 Na : 0 Vi (approx 10:05 AM)").
- **Add/Edit Alarm View**:
    - Multi-component picker: [Nazhigai (0-59)] : [Vinazhigai (0-59)].
    - Label text field.
    - Save/Cancel buttons.

## 5. Constraints
- Background execution is limited. We rely on "Scheduling Ahead" during foreground sessions.
- If the user changes location significantly (timezone/lat/long) without opening the app, the pre-scheduled alarms based on old location sunrise will be inaccurate.
    - **Mitigation**: Trigger a reschedule if Background App Refresh runs (optional), or just accept this limitation. The user is expected to open the app to see the clock anyway.

## 6. Clarifications

### Session 2026-01-27
- Q: Snooze behavior? -> A: **Standard Snooze** (Option B). Notification includes a "Snooze" action.
- Q: Sound behavior? -> A: **Default System Sound** (Option A).
- Q: DND/Silent Mode behavior? -> A: **Critical Alerts** (Option A). Alarm must ring even in Silent/DND mode. (Requires Entitlement).

# Data Model: Nazhigai Alarm

## Entities

### `NazhigaiAlarm`
Primary entity representing a user-configured alarm.

```swift
struct NazhigaiAlarm: Codable, Identifiable, Equatable {
    let id: UUID
    var nazhigai: Int          // 0-59
    var vinazhigai: Int        // 0-60 (typically 0-59, sometimes rounded up)
    var label: String
    var isEnabled: Bool
    
    // Default Init
    init(id: UUID = UUID(), nazhigai: Int = 0, vinazhigai: Int = 0, label: String = "", isEnabled: Bool = true) { ... }
}
```

### `AlarmStore` (UserDefaults)
Persists the list of alarms.

- **Key**: `kNazhigaiAlarms`
- **Value**: `Data` (JSON encoded `[NazhigaiAlarm]`)

## Services

### `NotificationService`
Handles scheduling with `UNUserNotificationCenter`.

```swift
protocol NotificationServiceProtocol {
    func requestAuthorization() async throws -> Bool
    func scheduleAlarms(_ alarms: [NazhigaiAlarm], forDays: Int) async
    func cancelAlarms(_ alarms: [NazhigaiAlarm]) // or remove specific IDs
    func removeAllAlarms()
}
```

## Logic flow
1. User adds Alarm -> `AlarmListViewModel` appends to `alarms` array.
2. `AlarmListViewModel` saves to `UserDefaults`.
3. `AlarmListViewModel` calls `NotificationService.scheduleAlarms` to update pending notifications.

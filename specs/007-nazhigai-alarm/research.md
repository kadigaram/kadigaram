# Research: Nazhigai Alarm

## Key Decisions

### 1. Notification Strategy
- **Decision**: Use "Schedule Ahead" (preschedule 7 days).
- **Rationale**: `UNCalendarNotificationTrigger` cannot track dynamic sunrise times. `UNTimeIntervalNotificationTrigger` is fixed duration. Pre-calculating distinct `UNCalendarNotificationTrigger` (DateComponents) for the next 7 days is the only viable native solution without a push server.
- **Alternatives**: 
    - *Background Fetch*: Unreliable timing.
    - *Push Notifications*: Requires server infrastructure (rejected: constitution prefers native/local).

### 2. Critical Alerts Entitlement
- **Decision**: Implement using `.criticalAlert` authorization option.
- **Rationale**: User explicitly requested DND override.
- **Note**: Development builds can simulate this, but App Store release requires Apple approval. We will wrap this in a check `if granted`.

### 3. Storage
- **Decision**: `UserDefaults`.
- **Rationale**: Low data volume (users have ~5-10 alarms). `CoreData`/`SwiftData` is overkill.

### 4. Recalculation Triggers
- **Decision**: `sceneDidBecomeActive` (App Open) and `UNUserNotificationCenterDelegate.userNotificationCenter(_:didReceive:...)` (Notification Response).
- **Rationale**: Ensures the 7-day buffer is replenished whenever the user interacts with the app.

## Resolved Unknowns
- **Notification Limit**: iOS limits to 64 pending notifications. 
    - *Math*: 5 Alarms * 7 Days = 35 notifications. Safe.
    - *Constraint*: Cap active alarms or days if > 9 alarms. (Constraint: 64 / 7 = 9 active alarms max for 7-day schedule).

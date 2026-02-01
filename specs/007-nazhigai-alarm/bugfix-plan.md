# Implementation Plan: Fix Alarm Scheduling Edge Case

**Bug**: Late-night Nazhigai alarms (e.g., 55th Nazhigai) are skipped for the immediate next occurrence if they fall on the next Gregorian morning.
**Cause**: `AlarmKitService.syncAllAlarmsToSystemClock` explicitly calculates the alarm time using `tomorrow` (`Date() + 1 day`) as the base date, ignoring potential occurrences in the remaining hours of the "current" Vedic day.

## Proposed Changes

### `Kadigaram/Services/AlarmKitService.swift`

Modify the `syncAllAlarmsToSystemClock` method:
1.  Calculate `targetDate` based on **Today** (`Date()`).
2.  If `targetDate` > `Date()` (Now), use it.
3.  If `targetDate` <= `Date()` (Past), calculate based on **Tomorrow** (`Date() + 1 day`).

#### Pseudo Logic
```swift
let today = Date()
// Try today first
if let todayTarget = calculateDate(..., on: today, ...) {
    if todayTarget > today {
       schedule(todayTarget)
       continue
    }
}

// If today failed or passed, try tomorrow
let tomorrow = ...
if let tomorrowTarget = calculateDate(..., on: tomorrow, ...) {
    schedule(tomorrowTarget)
}
```

## Verification Plan

### Automated Test (New)
Create a standalone swift test file `AlarmSchedulingTests.swift` in `KadigaramTests` (or temporary reproduction script) to verify logic:
1.  Mock `SixPartsLib.calculateDate` or use real one with a known location.
2.  Set "Now" to `Jan 31, 2026 19:30`.
3.  Set Alarm to `55 Nazhigai`.
4.  Verify `calculateDate(on: Jan 31)` returns `Feb 1, 05:30`.
5.  Verify `Feb 1, 05:30` > `Now`.
6.  Assert that this date is chosen over `Feb 2, 05:30`.

### Manual Verification
1.  Set simulated time or real time to evening.
2.  Set an alarm for 55 Nazhigai.
3.  Check logs/UI to see if the scheduled time is for "Tomorrow morning" (correct) or "Day after tomorrow morning" (bug).

# Implementation Plan: Feature 007 - Nazhigai Alarm

**Branch**: `007-nazhigai-alarm` | **Date**: 2026-01-27 | **Spec**: [Spec](file:///Users/dhilipkumars/dwork/github.com/dhilipkumars/kadigaram/kadigaram/specs/007-nazhigai-alarm/spec.md)
**Input**: Feature specification from `/specs/007-nazhigai-alarm/spec.md`

**Note**: This template is filled in by the `/speckit.plan` command.

## Summary

This feature implements a Vedic Time alarm system ("Nazhigai Alarm"). Unlike standard solar alarms, these alarms are relative to the daily sunrise (e.g., 10 Nazhigai after sunrise). The system uses a "Schedule Ahead" strategy to pre-schedule 7 days of notifications based on calculated sunrise times, storing configuration in `UserDefaults` and leveraging iOS `UserNotifications` with Critical Alerts support.

## Technical Context

**Language/Version**: Swift 6.0
**Primary Dependencies**: `UserNotifications`, `SwiftUI`, `KadigaramCore`, `SixPartsLib`
**Storage**: `UserDefaults` (Alarm Configuration)
**Testing**: `XCTest` (Alarm Calculation Logic), Manual (Notification Delivery)
**Target Platform**: iOS 17+ (Backwards compatible to iOS 16)
**Project Type**: Mobile (iOS)
**Performance Goals**: negligible background impact; accurate calculation (<1s).
**Constraints**: 
- iOS 64-notification limit (per app). 
- Background execution restrictions (cannot recalculate exactly at sunrise without BG fetch).
- **Critical Alerts** entitlement required for DND override.
**Scale/Scope**: < 10 alarms typically.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- **I. Mobile-First Native Excellence**: [PASS] Using native `UserNotifications` and `SwiftUI`.
- **II. Strict Backward Compatibility**: [PASS] `UserNotifications` is stable across versions.
- **III. Comprehensive Testing Strategy**: [PASS] Logic will be unit tested.
- **IV. Intuitive & Aesthetic Design**: [PASS] Native list/picker UI.
- **V. Industry Best Practices**: [PASS] MVVM architecture for Alarm UI.

## Project Structure

### Documentation (this feature)

```text
specs/007-nazhigai-alarm/
├── plan.md              # This file
├── research.md          # Phase 0 output
├── data-model.md        # Phase 1 output
├── quickstart.md        # N/A
├── contracts/           # N/A
└── tasks.md             # Phase 2 output
```

### Source Code

```text
kadigaram/ios/
├── Kadigaram/
│   ├── UI/
│   │   ├── Screens/
│   │   │   └── Alarms/
│   │   │       ├── AlarmListView.swift
│   │   │       ├── AlarmEditView.swift
│   │   │       └── AlarmListViewModel.swift
│   ├── Services/
│   │   └── NotificationService.swift
├── KadigaramCore/
│   └── Sources/
│       └── KadigaramCore/
│           └── Models/
│               └── NazhigaiAlarm.swift
```

**Structure Decision**: 
- `NazhigaiAlarm` model goes into `KadigaramCore` for potential sharing (e.g., Widgets).
- `NotificationService` handles interaction with `UNUserNotificationCenter`.
- UI components grouped under `UI/Screens/Alarms`.

## Complexity Tracking

None.

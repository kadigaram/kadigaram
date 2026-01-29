# Tasks: Feature 007 - Nazhigai Alarm

**Spec**: [Spec](file:///Users/dhilipkumars/dwork/github.com/dhilipkumars/kadigaram/kadigaram/specs/007-nazhigai-alarm/spec.md) | **Plan**: [Plan](file:///Users/dhilipkumars/dwork/github.com/dhilipkumars/kadigaram/kadigaram/specs/007-nazhigai-alarm/plan.md)

## Phase 1: Setup
*Goal: Initialize project structure and file shells.*

- [ ] T001 Create `NazhigaiAlarm.swift` in `KadigaramCore` (file shell)
- [ ] T002 Create `NotificationService.swift` in `Kadigaram/Services` (file shell)
- [ ] T003 Create `AlarmListView.swift` in `Kadigaram/UI/Screens/Alarms` (file shell)
- [ ] T004 Create `AlarmEditView.swift` in `Kadigaram/UI/Screens/Alarms` (file shell)
- [ ] T005 Create `AlarmListViewModel.swift` in `Kadigaram/UI/Screens/Alarms` (file shell)

## Phase 2: Foundation (Core Logic)
*Goal: Implement data model, persistence, and basic notification authorization.*

- [ ] T006 Implement `NazhigaiAlarm` struct (Codable, Identifiable) in `KadigaramCore/Sources/KadigaramCore/Models/NazhigaiAlarm.swift`
- [ ] T007 Implement `AlarmListViewModel`: `loadAlarms()` and `saveAlarms()` using `UserDefaults` in `Kadigaram/UI/Screens/Alarms/AlarmListViewModel.swift`
- [ ] T008 Implement `NotificationService`: `requestAuthorization()` with `.criticalAlert` check in `Kadigaram/Services/NotificationService.swift`
- [ ] T009 Implement `NotificationService`: Internal helper `calculateWallClockTime(nazhigai:vinazhigai:forDate:)` using `VedicEngine`/`SixPartsLib` logic in `Kadigaram/Services/NotificationService.swift`
- [ ] T010 Implement `NotificationService`: `scheduleAlarms(_:forDays:)` loop (7 days) in `Kadigaram/Services/NotificationService.swift`
- [ ] T011 [Test] Unit verify calculation logic (manual run or strict TDD if preferred) for T009

## Phase 3: User Stories 1, 6, 7 (Create & Edit)
*Goal: Allow creating alarms with time, label, and snooze.*

- [ ] T012 [US1] Implement `AlarmEditView`: Nazhigai/Vinazhigai Pickers in `Kadigaram/UI/Screens/Alarms/AlarmEditView.swift`
- [ ] T013 [US6] Implement `AlarmEditView`: Label TextField in `Kadigaram/UI/Screens/Alarms/AlarmEditView.swift`
- [ ] T014 [US1] Wire up `AlarmEditView` to `AlarmListViewModel.addAlarm()` in `Kadigaram/UI/Screens/Alarms/AlarmListViewModel.swift`
- [ ] T015 [US7] Configure Notification Category with "Snooze" action in `NotificationService.swift`
- [ ] T016 [US7] Handle Snooze action delegate method in `NotificationService.swift`

## Phase 4: User Stories 2 & 3 (List & Toggle)
*Goal: View and manage alarm list.*

- [ ] T017 [US2] Implement `AlarmListView`: List row with time, label, and toggle in `Kadigaram/UI/Screens/Alarms/AlarmListView.swift`
- [ ] T018 [US2] Add "Add (+)" button navigation to `AlarmEditView` in `Kadigaram/UI/Screens/Alarms/AlarmListView.swift`
- [ ] T019 [US3] Implement `toggleAlarm(id:)` in `AlarmListViewModel` (save & reschedule) in `Kadigaram/UI/Screens/Alarms/AlarmListViewModel.swift`
- [ ] T020 [US2] Add Delete (swipe to delete) support in `AlarmListView.swift`

## Phase 5: User Stories 4 & 5 (Lifecycle & Reschedule)
*Goal: Ensure reliability across days and app states.*

- [ ] T021 [US5] Implement `sceneDidBecomeActive` (or `onReceive` scenePhase) in `KadigaramApp.swift` or `DashboardView` to trigger `viewModel.refreshSchedule()`
- [ ] T022 [US4] Verify "Critical Alert" capability (Manual verification on device)
- [ ] T023 [US5] Update `NotificationService` to clear old scheduling and re-push 7 days from *now* in `Kadigaram/Services/NotificationService.swift`

## Dependencies
- Phase 2 blocks Phase 3, 4, 5
- Phase 3 & 4 can be partially parallel
- Phase 5 requires working NotificationService (Phase 2)

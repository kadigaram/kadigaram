# Tasks: Accurate Tamil Date Calculation

**Feature Branch**: `005-accurate-tamil-date`  
**Status**: Planning Complete — Ready for Implementation  
**Updated**: 2026-01-19

---

## Phase 1: Setup & Infrastructure

*Goal: Initialize SixPartsLib package structure and prepare iOS project*

- [x] T001 Create SixPartsLib Swift package directory structure at `kadigaram/ios/SixPartsLib/`
- [x] T002 Initialize Package.swift with library manifest for SixPartsLib
- [x] T003 Create folder structure: `Sources/SixPartsLib/{Models,Calculators}` and `Tests/SixPartsLibTests/`
- [x] T004 Add SixPartsLib as local package dependency in `kadigaram/ios/KadigaramCore/Package.swift`
- [x] T005 Create public API file `kadigaram/ios/SixPartsLib/Sources/SixPartsLib/SixPartsLib.swift`

---

## Phase 2: Foundational Components

*Goal: Move existing calculation logic to SixPartsLib and add astronomical foundation*

### Move Existing Code (No Story Dependencies)

- [x] T006 [P] Move `VedicDate` struct from `kadigaram/ios/KadigaramCore/Sources/KadigaramCore/Models/VedicDate.swift` to `kadigaram/ios/SixPartsLib/Sources/SixPartsLib/Models/VedicDate.swift`
- [x] T007 [P] Move `CalendarSystem` and `Paksha` enums to `kadigaram/ios/SixPartsLib/Sources/SixPartsLib/Models/Enums.swift`
- [x] T008 Move `AstronomicalCalculator` from KadigaramCore to `kadigaram/ios/SixPartsLib/Sources/SixPartsLib/Calculators/AstronomicalCalculator.swift`
- [x] T009 Update `kadigaram/ios/KadigaramCore/Sources/KadigaramCore/Engines/VedicEngine.swift` to import SixPartsLib and delegate calculations

### Extend Astronomical Calculations

- [x] T010 [P] Implement `calculateLahiriAyanamsa(date:)` method in `kadigaram/ios/SixPartsLib/Sources/SixPartsLib/Calculators/AstronomicalCalculator.swift`
- [x] T011 Implement `siderealSun Longitude(date:)` method using tropical longitude + Ayanamsa in `AstronomicalCalculator.swift`

---

## Phase 3: US1 - Accurate Tamil Date Display

*Goal: Implement Sankranti-based Tamil calendar calculation*

**Independent Test**: Calculate Tamil date for Jan 14, 2026 — Result should be "Thai 1" (verified against Dhrik Panchang)

### Data Models

- [x] T012 [US1] Create `TamilDate` struct in `kadigaram/ios/SixPartsLib/Sources/SixPartsLib/Models/TamilDate.swift`
- [x] T013 [P] [US1] Create `SankrantiInfo` internal struct in `kadigaram/ios/SixPartsLib/Sources/SixPartsLib/Models/SankrantiInfo.swift`

### Tamil Calendar Calculator

- [x] T014 [US1] Create `TamilCalendarCalculator` class in `kadigaram/ios/SixPartsLib/Sources/SixPartsLib/Calculators/TamilCalendarCalculator.swift`
- [x] T015 [US1] Implement `findSankranti(targetDegree:searchEnd:)` using binary search algorithm in `TamilCalendarCalculator.swift`
- [x] T016 [US1] Implement `applySunsetRule(sankrantiTime:location:timeZone:)` for day-1 determination in `TamilCalendarCalculator.swift`
- [x] T017 [US1] Implement `calculateTamilDate(for:location:timeZone:)` combining all Tamil calendar logic in `TamilCalendarCalculator.swift`

### Public API & Integration

- [x] T018 [US1] Expose `calculateTamilDate()` as static method in `kadigaram/ios/SixPartsLib/Sources/SixPartsLib/SixPartsLib.swift`
- [x] T019 [US1] Update `DashboardView.swift` to display Tamil date using SixPartsLib API

### Unit Tests (US1)

- [ ] T020 [P] [US1] Create `TamilCalendarTests.swift` in `kadigaram/ios/SixPartsLib/Tests/SixPartsLibTests/` with reference data from Dhrik Panchang
- [ ] T021 [P] [US1] Add test case for Thai month transition (Jan 14, 2026) in `TamilCalendarTests.swift`
- [ ] T022 [P] [US1] Add test case for Chithirai month (Tamil New Year, Apr 14, 2025) in `TamilCalendarTests.swift`
- [ ] T023 [P] [US1] Add sunset rule edge case tests (Sankranti ±30 min of sunset) in `TamilCalendarTests.swift`
- [ ] T024 [P] [US1] Create `SankrantiTests.swift` to verify binary search accuracy (±1 minute precision)

---

## Phase 4: US2 - Cultural App Identity (App Icon)

*Goal: Update app icon with Tamil-themed design*

**Independent Test**: App icon displays correctly on iOS home screen, App Store, and app switcher without distortion

- [x] T025 [US2] Create `AppIcon.appiconset` folder in `kadigaram/ios/Kadigaram/Assets.xcassets/`
- [x] T026 [US2] Copy user-provided icon assets (1024x1024, 180x180, 120x120, etc.) into `AppIcon.appiconset/`
- [x] T027 [US2] Update `Contents.json` in `AppIcon.appiconset/` with correct asset mappings for all iOS sizes
- [ ] T028 [US2] Build app and verify icon displays on simulator home screen

---

## Phase 5: US3 - Library Modularity for Testing

*Goal: Complete SixPartsLib structure and testability*

**Independent Test**: SixPartsLib compiles independently and all tests pass without importing UIKit/SwiftUI

### Vedic Calculator Migration

- [ ] T029 [US3] Extract Vedic calculation methods from `VedicEngine.swift` into new `VedicCalculator.swift` in SixP artsLib
- [ ] T030 [US3] Implement `calculateVedicDate(for:location:calendarSystem:)` in `kadigaram/ios/SixPartsLib/Sources/SixPartsLib/Calculators/VedicCalculator.swift`
- [ ] T031 [US3] Expose `calculateVedicDate()` as static method in `SixPartsLib.swift` public API

### Verify Independence

- [ ] T032 [US3] Run `swift build` in `kadigaram/ios/SixPartsLib/` to verify no UI dependencies
- [ ] T033 [US3] Run `swift test` to execute all SixPartsLib unit tests

### Full Test Coverage

- [ ] T034 [P] [US3] Create `VedicCalculatorTests.swift` with tests for Tithi, Nakshatra, Samvatsara calculations
- [ ] T035 [P] [US3] Create `ReferenceData.swift` fixture file with Dhrik Panchang test data for 10+ dates across 2025-2027
- [ ] T036 [US3] Add integration test comparing SixPartsLib output with reference Panchangam data (95% accuracy target)

---

## Phase 6: Polish & Cross-Cutting Concerns

*Goal: Localization, documentation, and final verification*

- [ ] T037 [P] Verify Tamil localization displays "விசுவாவசு" (Viswavasu) for 2026 Samvatsara using existing `ta.lproj/Localizable.strings`
- [ ] T038 [P] Add inline documentation to all public API methods in `SixPartsLib.swift`
- [ ] T039 Perform manual verification of Tamil date against Dhrik Panchang for current date
- [ ] T040 Run performance benchmark: Tamil date calculation completes in <50ms on device
- [ ] T041 Update `quickstart.md` with actual usage examples from implemented code

---

## Dependencies

### Story Completion Order

```
Phase 1 (Setup)
     ↓
Phase 2 (Foundational) ← Must complete before any user story
     ├─→ Phase 3 (US1) — Tamil Date (independent)
     ├─→ Phase 4 (US2) — App Icon (independent)
     └─→ Phase 5 (US3) — Testing (depends on US1 completion)
              ↓
         Phase 6 (Polish)
```

**Independent Stories**: US1 and US2 can be implemented in parallel after Phase 2  
**Dependent Story**: US3 requires US1 complete (tests need Tamil date implementation)

### Task Dependencies Within Stories

**US1 Dependencies**:
- T012-T013 (models) → T014-T017 (calculator) → T018-T019 (API/UI) → T020-T024 (tests)

**US2 Dependencies**:
- No internal dependencies (all icon tasks are sequential)

**US3 Dependencies**:
- T029-T031 (Vedic migration) → T032-T033 (verification) → T034-T036 (tests)

---

## Parallel Execution Opportunities

### Phase 2 Parallelization

- **T006-T007**: Move models (separate files)
- **T010**: Implement Ayanamsa while T008-T009 move existing code

### Phase 3 (US1) Parallelization

- **T012-T013**: Create data models (separate files)
- **T020-T024**: All test files can be written in parallel

### Phase 4 (US2) Parallelization

None (icon tasks are sequential: create folder → copy assets → update JSON)

### Phase 5 (US3) Parallelization

- **T034-T035**: Write test files while T032-T033 run builds

### Phase 6 Parallelization

- **T037-T038**: Localization check + documentation (separate concerns)

---

## Implementation Strategy

### MVP Scope (Recommended First Iteration)

**Minimum Viable Product**: US1 only (Accurate Tamil Date Display)

- Complete Phase 1 (Setup): T001-T005
- Complete Phase 2 (Foundational): T006-T011
- Complete Phase 3 (US1): T012-T024
- **Result**: App displays correct Tamil date; can ship this increment

### Incremental Delivery

1. **Iteration 1** (MVP): Phases 1-3 (US1) → Ship Tamil date feature
2. **Iteration 2**: Phase 4 (US2) → Ship updated icon
3. **Iteration 3**: Phase 5 (US3) + Phase 6 → Ship full test coverage

### Recommended Approach

**Week 1**: Complete Phases 1-3 (US1) — Deploy Tamil date to TestFlight  
**Week 2**: Add Phase 4 (US2) — Update icon in same release  
**Week 3**: Complete Phase 5 (US3) + Phase 6 — Full test suite and performance verification

---

## Task Summary

**Total Tasks**: 41  
**By Phase**:
- Phase 1 (Setup): 5 tasks
- Phase 2 (Foundational): 6 tasks
- Phase 3 (US1): 13 tasks
- Phase 4 (US2): 4 tasks
- Phase 5 (US3): 8 tasks
- Phase 6 (Polish): 5 tasks

**By User Story**:
- US1 (Tamil Date): 13 tasks
- US2 (App Icon): 4 tasks
- US3 (Testing): 8 tasks
- Setup/Infrastructure: 16 tasks

**Parallel Opportunities**: 12 tasks marked [P] (can run concurrently)

**Independent Test Criteria**:
- ✅ US1: Tamil date matches Dhrik Panchang for Jan 14, 2026
- ✅ US2: Icon displays correctly without distortion
- ✅ US3: SixPartsLib builds independently, all tests pass

---

## Verification Plan

### Build Verification

```bash
# Verify SixPartsLib compiles independently
cd kadigaram/ios/SixPartsLib
swift build
```

### Test Execution

```bash
# Run all SixPartsLib unit tests
cd kadigaram/ios/SixPartsLib
swift test

# Run from Xcode
# 1. Open kadigaram.xcodeproj
# 2. Select SixPartsLib scheme
# 3. Press Cmd+U
```

### Manual Verification

1. **Tamil Date Accuracy**:
   - Open app on Jan 14, 2026 (or change system date)
   - Verify display shows "Thai 1"
   - Cross-reference with [Dhrik Panchang](https://www.drikpanchang.com/)

2. **Icon Display**:
   - Build and install on simulator
   - Check home screen icon (Tamil க letter visible, no distortion)
   - Check App Store preview

3. **Performance**:
   - Enable debug logging
   - Measure Tamil date calculation time (<50ms target)

---

**Ready for**: Implementation via `/speckit.implement` or manual task execution


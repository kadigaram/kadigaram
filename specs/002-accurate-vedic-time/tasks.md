# Tasks: Accurate Vedic Time & Enhanced UI

**Feature Number**: 002  
**Feature Branch**: `002-accurate-vedic-time`  
**Prerequisites**: plan.md, spec.md

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

## Path Conventions

- **iOS Project**: `kadigaram/ios/`
- **KadigaramCore**: `kadigaram/ios/KadigaramCore/Sources/KadigaramCore/`
- **App**: `kadigaram/ios/Kadigaram/`
- **Tests**: `kadigaram/ios/KadigaramTests/`
- **Widget**: `kadigaram/ios/KadigaramWidget/`
- **Localization**: `kadigaram/ios/Kadigaram/Resources/*. lproj/Localizable.strings`

---

## Phase 1: Setup (Dependencies & Research)

**Purpose**: Add astronomical libraries and setup infrastructure

- [x] T001 Add Solar package dependency to `kadigaram/ios/KadigaramCore/Package.swift`
- [x] T002 Add suncalc-swift package dependency to `kadigaram/ios/KadigaramCore/Package.swift`
- [x] T003 Verify library integration with minimal test (compile-time check)

---

## Phase 2: Foundational (Astronomical Infrastructure)

**Purpose**: Core astronomical calculation layer that blocks all user stories

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [x] T004 Create `AstronomicalEngine` protocol in `kadigaram/ios/KadigaramCore/Sources/KadigaramCore/Engines/AstronomicalEngine.swift`
- [x] T005 Implement `SolarAstronomicalEngine` concrete class (wraps Solar library) in same file as T004
- [x] T006 Add caching mechanism for sunrise/sunset (last 3 days) in `SolarAstronomicalEngine`
- [x] T007 Create unit tests for `AstronomicalEngine` in `kadigaram/ios/KadigaramTests/AstronomicalEngineTests.swift`

**Checkpoint**: Foundation ready - astronomical calculations available for all user stories

---

## Phase 3: User Story 1 - Accurate Sunrise/Sunset (Priority: P1) 🎯 MVP

**Goal**: Replace mock 6 AM/6 PM times with location-based calculations

**Independent Test**: Open app in Chennai and Delhi; verify Nazhigai shows different values based on actual sunrise times

### Implementation for User Story 1

- [x] T008 [US1] Update `VedicEngine.calculateVedicTime` to accept `AstronomicalEngine` parameter in `kadigaram/ios/KadigaramCore/Sources/KadigaramCore/Engines/VedicEngine.swift`
- [x] T009 [US1] Remove hardcoded sunrise/sunset (6 AM/6 PM) from `VedicEngine.calculateVedicTime`
- [x] T010 [US1] Initialize `AstronomicalEngine` in `DashboardViewModel` at `kadigaram/ios/Kadigaram/UI/Screens/DashboardViewModel.swift`
- [x] T011 [US1] Pass `AstronomicalEngine` to `VedicEngine` calls in `DashboardViewModel.updateTime()`
- [ ] T012 [US1] Update `VedicEngineTests.swift` to use `AstronomicalEngine` mock instead of hardcoded times

**Checkpoint**: Nazhigai calculations now use real sunrise/sunset based on device location

---

## Phase 4: User Story 2 - Vedic Calendar Calculations (Priority: P1)

**Goal**: Calculate accurate Samvatsara, Tithi, Nakshatra, and Paksham

**Independent Test**: Cross-reference app's Vedic date for Jan 15, 2026 with drikpanchang.com; verify Tithi/Nakshatra match

### Implementation for User Story 2

- [x] T013 [P] [US2] Create `SamvatsaraTable.swift` with 60-year cycle lookup in `kadigaram/ios/KadigaramCore/Sources/KadigaramCore/Models/SamvatsaraTable.swift`
- [x] T014 [P] [US2] Implement `tithiCalculation(sunLongitude:moonLongitude:)` method in `VedicEngine.swift`
- [x] T015 [P] [US2] Implement `nakshatraCalculation(moonLongitude:)` method in `VedicEngine.swift`
- [x] T016 [P] [US2] Implement `pakshamCalculation(tithi:)` method in `VedicEngine.swift`
- [x] T017 [US2] Update `VedicEngine.calculateVedicDate` to use suncalc for sun/moon positions
- [x] T018 [US2] Calculate Tithi, Nakshatra, Paksham in `calculateVedicDate` using helper methods (depends on T014-T016)
- [x] T019 [US2] Calculate Samvatsara using `SamvatsaraTable` lookup
- [x] T020 [US2] Calculate `tithiProgress` and `nakshatraProgress` percentages
- [x] T021 [US2] Calculate `pakshamIllumination` (moon phase percentage)
- [ ] T022 [US2] Create unit tests for Vedic calendar calculations in `kadigaram/ios/KadigaramTests/VedicCalendarTests.swift`

**Checkpoint**: App displays accurate Vedic calendar components matching reference Panchang

---

## Phase 5: User Story 3 - Position Indicator (Priority: P2)

**Goal**: Animated sphere on golden ring showing real-time Nazhigai progress

**Independent Test**: Watch golden ring indicator move smoothly over 2-3 minutes; verify it travels ~1% of circle per Nazhigai

### Implementation for User Story 3

- [x] T023 [US3] Add `progressIndicatorAngle` computed property to `VedicTime` model in `kadigaram/ios/KadigaramCore/Sources/KadigaramCore/Models/VedicTime.swift`
- [x] T024 [US3] Update `NazhigaiWheel.swift` to render floating sphere at `kadigaram ios/KadigaramCore/Sources/KadigaramCore/UI/Components/NazhigaiWheel.swift`
- [x] T025 [US3] Calculate sphere position on ring using `GeometryReader` and polar coordinates
- [x] T026 [US3] Apply radial gradient (white→gold) and drop shadow to sphere
- [x] T027 [US3] Add smooth animation with `.animation(.linear(duration: 1))` modifier
- [x] T028 [US3] Optimize rendering with `drawingGroup()` for 60fps performance

**Checkpoint**: Position indicator sphere animates smoothly around golden ring, updating every second

---

## Phase 6: User Story 4 - Paksham Moon Icons (Priority: P2)

**Goal**: Visual moon phase representation next to Paksham text

**Independent Test**: Compare moon icon with astronomy app (e.g., Sky Guide); verify phase matches current lunar cycle

### Implementation for User Story 4

- [x] T029 [P] [US4] Create `MoonPhaseView.swift` component at `kadigaram/ios/Kadigaram/UI/Components/MoonPhaseView.swift`
- [x] T030 [US4] Implement 8-phase moon drawing using `Path` and arcs (New, Crescent, Quarter, Gibbous, Full, reversed)
- [x] T031 [US4] Accept `illuminationPercentage` and `paksha` as parameters in `MoonPhaseView`
- [x] T032 [US4] Add accessibility label for VoiceOver (e.g., "Waxing Gibbous Moon")
- [x] T033 [US4] Update `DualDateHeader.swift` to include `MoonPhaseView` in `kadigaram/ios/Kadigaram/UI/Components/DualDateHeader.swift`
- [x] T034 [US4] Position moon icon next to Paksham text using HStack layout

**Checkpoint**: Moon phase icon displays correctly and matches current lunar illumination

---

## Phase 7: Widget Support (Priority: P3)

**Goal**: Widget shows accurate Nazhigai position with pre-calculated timeline

**Independent Test**: Add widget to home screen; verify it updates every ~5 minutes with correct position indicator

### Implementation for User Story 5

- [x] T035 [US5] Update `NazhigaiProvider.swift` to initialize `AstronomicalEngine` at `kadigaram/ios/KadigaramWidget/NazhigaiProvider.swift`
- [x] T036 [US5] Generate 24-hour timeline with 5-minute intervals (288 entries)
- [x] T037 [US5] Pre-calculate `progressIndicatorAngle` for each timeline entry
- [x] T038 [US5] Use tomorrow's sunrise/sunset for timeline beyond current day
- [x] T039 [US5] Update `KadigaramWidget.swift` to render position indicator in widget view

**Checkpoint**: Widget displays Nazhigai position and updates automatically every 5-10 minutes

---

## Phase 8: Localization (Priority: P3)

**Goal**: Add translations for 60 Samvatsara names, 30 Tithi names, and 27 Nakshatra names

### Implementation for Localization

- [x] T040 [P] Add Samvatsara names (60 keys) to `kadigaram/ios/Kadigaram/Resources/en.lproj/Localizable.strings`
- [x] T041 [P] Add Tithi names (30 keys) to `kadigaram/ios/Kadigaram/Resources/en.lproj/Localizable.strings`
- [x] T042 [P] Add Nakshatra names (27 keys) to `kadigaram/ios/Kadigaram/Resources/en.lproj/Localizable.strings`
- [ ] T043 [P] Add Samvatsara translations to `sa.lproj`, `ta.lproj`, `te.lproj`, `kn.lproj`, `ml.lproj`
- [ ] T044 [P] Add Tithi translations to all language `.lproj` files
- [ ] T045 [P] Add Nakshatra translations to all language `.lproj` files

**Checkpoint**: All Vedic calendar terms support 6 languages (en, sa, ta, te, kn, ml)

---

## Phase 9: Polish & Verification

**Purpose**: Testing, performance optimization, and final validation

- [ ] T046 [P] Manual verification: Compare sunrise for 3 cities (Chennai, Delhi, Mumbai) with timeanddate.com
- [ ] T047 [P] Manual verification: Cross-reference 5 random dates with drikpanchang.com
- [ ] T048 Test edge case: Polar region location (graceful fallback or error message)
- [ ] T049 Test edge case: Offline mode (verify cached sunrise/sunset works)
- [ ] T050 Performance test: Verify calculations complete within 500ms on app launch
- [ ] T051 Performance test: Record video of position indicator; confirm 60fps with Instruments
- [ ] T052 Verify widget updates within 10-minute accuracy on lock screen
- [ ] T053 UI polish: Ensure moon phase icon aligns properly in all screen sizes (iPhone SE to iPad)
- [ ] T054 Documentation: Update `quickstart.md` with verification steps for accurate Vedic calculations

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies - can start immediately
- **Foundational (Phase 2)**: Depends on Setup completion - BLOCKS all user stories
- **User Stories (Phase 3-8)**: All depend on Foundational phase completion
  - US1 (Astronomical): Can start after Phase 2
  - US2 (Vedic Calendar): Can start after Phase 2, independent of US1
  - US3 (Position Indicator): Depends on US1 completion (needs `progressIndicatorAngle`)
  - US4 (Moon Icons): Depends on US2 completion (needs `pakshamIllumination`)
  - US5 (Widget): Depends on US1 and US3 (needs astronomical engine + position angle)
  - Localization: Can start after US2 (needs Samvatsara/Tithi/Nakshatra logic)
- **Polish (Phase 9)**: Depends on all user stories being complete

### User Story Dependencies

- **US1 (Astronomical)**: Can start after Phase 2 - No dependencies on other stories
- **US2 (Vedic Calendar)**: Can start after Phase 2 - Independent of US1
- **US3 (Position Indicator)**: Requires US1 complete (uses `VedicTime.progressIndicatorAngle`)
- **US4 (Moon Icons)**: Requires US2 complete (uses `VedicDate.pakshamIllumination`)
- **US5 (Widget)**: Requires US1, US3 complete (uses astronomical engine + position indicator)

### Parallel Opportunities

- **Phase 1**: All 3 tasks can run in parallel (different package dependencies)
- **Phase 4 (US2)**: T013-T016 can run in parallel (different methods/files)
- **Phase 6 (US4)**: T029 (create component) can run in parallel with T033 (modify header)
- **Phase 8 (Localization)**: T040-T045 can all run in parallel (different `.lproj` files)
- **Phase 9 (Polish)**: T046-T047 (verification tasks) can run in parallel

---

## Parallel Example: User Story 2 (Vedic Calendar)

```bash
# Launch all model/helper tasks together:
Task T013: \"Create SamvatsaraTable.swift with 60-year cycle lookup\"
Task T014: \"Implement tithiCalculation method in VedicEngine.swift\"
Task T015: \"Implement nakshatraCalculation method in VedicEngine.swift\"
Task T016: \"Implement pakshamCalculation method in VedicEngine.swift\"

# After helpers complete, run integration task:
Task T017: \"Update VedicEngine.calculateVedicDate to use suncalc\"
```

---

## Implementation Strategy

### MVP First (US1 + US2 Only)

1. Complete Phase 1: Setup
2. Complete Phase 2: Foundational (CRITICAL - blocks all stories)
3. Complete Phase 3: User Story 1 (Astronomical)
4. Complete Phase 4: User Story 2 (Vedic Calendar)
5. **STOP and VALIDATE**: Cross-reference with drikpanchang.com
6. Deploy/test with users

### Incremental Delivery

1. Setup + Foundational → Foundation ready
2. Add US1 (Astronomical) → Test independently → Deploy/Demo
3. Add US2 (Vedic Calendar) → Test independently → Deploy/Demo (MVP!)
4. Add US3 (Position Indicator) + US4 (Moon Icons) → Test independently → Deploy/Demo
5. Add US5 (Widget) + Localization → Test independently → Deploy/Demo (Full Feature!)
6. Polish → Final release

---

## Notes

- [P] tasks = different files, no dependencies
- [Story] label maps task to specific user story for traceability
- Each user story should be independently completable and testable
- Commit after each task or logical group
- Stop at any checkpoint to validate story independently
- **Astronomical calculations use radians**: Remember to convert degrees ↔ radians
- **Vedic calendar reference**: Surya Siddhanta (document assumptions in code comments)

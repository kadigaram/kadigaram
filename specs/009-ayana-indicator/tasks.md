# Tasks: Ayana Indicator (Uttarayanam/Dakshinayanam)

**Input**: Design documents from `/specs/009-ayana-indicator/`  
**Prerequisites**: plan.md ✅, spec.md ✅

**Organization**: Tasks grouped by implementation phase to enable incremental delivery

## Format: `[ID] [P?] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- Includes exact file paths for all implementation tasks

## Path Conventions

- **Mobile**: `kadigaram/ios/` (Swift/SwiftUI iOS app)
- **Core Library**: `kadigaram/ios/SixPartsLib/` (Swift Package)
- **Tests**: `kadigaram/ios/SixPartsLib/Tests/SixPartsLibTests/`

---

## Phase 1: Research & Foundation

**Purpose**: Establish astronomical basis and design decisions before implementation

- [ ] T001 Research solstice date accuracy requirements
  - Confirm December 21-22 and June 21-22 ranges
  - Document precision requirements (±1 day acceptable for MVP)
  - Record in `specs/009-ayana-indicator/research.md`

- [ ] T002 Select SF Symbol for arrow indicators
  - Test candidates: `arrow.up`, `arrow.down`, `chevron.up`, `chevron.down`, `arrowtriangle.up.fill`
  - Verify visibility at 20-30% of Sun symbol size
  - Screenshot comparison in light/dark modes
  - Record decision in `specs/009-ayana-indicator/research.md`

- [ ] T003 Create data model documentation
  - Document `Ayana` enum design (2 cases)
  - Document `VedicDate` extension (new `ayana` property)
  - Write in `specs/009-ayana-indicator/data-model.md`

- [ ] T004 Define API contract for calculateAyana()
  - Specify input: `Date`
  - Specify output: `Ayana`
  - Document 6 test cases (Jan, Jun 21, Jun 22, Aug, Dec 21, Dec 22)
  - Write in `specs/009-ayana-indicator/contracts/ayana-calculation.md`

- [ ] T005 Write quickstart guide for developers
  - Code example: accessing `vedicDate.ayana`
  - UI integration example: arrow rendering
  - Testing instructions for manual verification
  - Write in `specs/009-ayana-indicator/quickstart.md`

**Checkpoint**: Foundation documented - implementation can begin

---

## Phase 2: User Story 1 - View Current Ayana Direction (Priority: P1) 🎯 MVP

**Goal**: Display arrow indicator (↑/↓) on clock dial showing current Ayana direction

**Independent Test**: Open app, observe arrow above/below Sun symbol, verify direction matches current date

### Tests for User Story 1 ⚠️

> **NOTE: Write these tests FIRST, ensure they FAIL before implementation**

- [ ] T006 [P] [US1] Create test file `kadigaram/ios/SixPartsLib/Tests/SixPartsLibTests/AyanaCalculationTests.swift`
  - Add XCTest imports
  - Add `AstronomicalCalculator` import
  - Create empty test class

- [ ] T007 [P] [US1] Write `testUttarayanamMidWinter()` test
  - Input: Date(Jan 15, 2026)
  - Expected: `.uttarayanam`
  - Verify test FAILS (method doesn't exist yet)

- [ ] T008 [P] [US1] Write `testUttarayanamBeforeSolstice()` test
  - Input: Date(Jun 21, 2026)
  - Expected: `.uttarayanam`
  - Verify test FAILS

- [ ] T009 [P] [US1] Write `testDakshinayanamTransition()` test
  - Input: Date(Jun 22, 2026)
  - Expected: `.dakshinayanam`
  - Verify test FAILS

- [ ] T010 [P] [US1] Write `testDakshinayanamMidSummer()` test
  - Input: Date(Aug 31, 2026)
  - Expected: `.dakshinayanam`
  - Verify test FAILS

- [ ] T011 [P] [US1] Write `testDakshinayanamBeforeSolstice()` test
  - Input: Date(Dec 21, 2026)
  - Expected: `.dakshinayanam`
  - Verify test FAILS

- [ ] T012 [P] [US1] Write `testUttarayanamTransition()` test
  - Input: Date(Dec 22, 2026)
  - Expected: `.uttarayanam`
  - Verify test FAILS

- [ ] T013 [P] [US1] Write `testEdgeCaseSpringEquinox()` test
  - Input: Date(Mar 20, 2026)
  - Expected: `.uttarayanam`
  - Verify test FAILS

- [ ] T014 [P] [US1] Write `testEdgeCaseAutumnEquinox()` test
  - Input: Date(Sep 22, 2026)
  - Expected: `.dakshinayanam`
  - Verify test FAILS

- [ ] T015 [US1] Write `testAyanaCalculationPerformance()` test
  - Measure time for 1000 calculations
  - Expected: < 5ms total (< 0.005ms per calculation)
  - Verify test FAILS

### Implementation for User Story 1

#### SixPartsLib Core Logic

- [ ] T016 [P] [US1] Create `Ayana` enum in `kadigaram/ios/SixPartsLib/Sources/SixPartsLib/Models/Ayana.swift`
  - Add `import Foundation`
  - Define `enum Ayana: String, Equatable, Sendable, Codable`
  - Add cases: `.uttarayanam`, `.dakshinayanam`
  - Add doc comments explaining each case

- [ ] T017 [US1] Extend `VedicDate` struct in `kadigaram/ios/SixPartsLib/Sources/SixPartsLib/Models/VedicDate.swift`
  - Add `public let ayana: Ayana` property
  - Update `init()` to include `ayana` parameter
  - Add `self.ayana = ayana` assignment
  - Update doc comments

- [ ] T018 [US1] Implement `calculateAyana()` in `kadigaram/ios/SixPartsLib/Sources/SixPartsLib/Calculators/AstronomicalCalculator.swift`
  - Add method signature: `public func calculateAyana(for date: Date) -> Ayana`
  - Extract month and day using `Calendar.current.dateComponents([.month, .day], from: date)`
  - Implement logic:
    - June-December: check if before/after Jun 22
    - December 22-31: return `.uttarayanam`
    - January-May: return `.uttarayanam`
    - Jun 22 - Dec 21: return `.dakshinayanam`
  - Add fallback: return `.uttarayanam` if date components fail
  - Add doc comments with examples

- [ ] T019 [US1] Update `VedicEngine` in `kadigaram/ios/SixPartsLib/Sources/SixPartsLib/SixPartsLib.swift`
  - Import `AstronomicalCalculator` if not already imported
  - Call `calculator.calculateAyana(for: date)` when building VedicDate
  - Pass `ayana` parameter to `VedicDate.init()`

- [ ] T020 [US1] Verify all 9 unit tests PASS
  - Run: `xcodebuild test -scheme SixPartsLib -destination 'platform=iOS Simulator,name=iPhone 17 Pro' -only-testing:SixPartsLibTests/AyanaCalculationTests`
  - Expected: 9/9 tests pass
  - If failures: debug and fix `calculateAyana()` logic

#### UI Integration (Kadigaram App)

- [ ] T021 [US1] Update `ClockDialViewModel` in `kadigaram/ios/Kadigaram/UI/Components/ClockDialViewModel.swift`
  - Verify `vedicDate: VedicDate?` property exists (should be published already)
  - No changes needed (Ayana is automatically included in VedicDate)
  - Add comment: `// Ayana (Feature 009) available via vedicDate.ayana`

- [ ] T022 [US1] Add arrow indicator to `ClockDialView` in `kadigaram/ios/Kadigaram/UI/Components/ClockDialView.swift`
  - Locate center `VStack` containing Sun symbol (line ~84-106)
  - After Sun `Image(systemName: "sun.max.fill")` and before Nazhigai time text:
    - Add conditional arrow rendering
    - Check `if let ayana = viewModel.vedicDate?.ayana`
    - For `.uttarayanam`: `Image(systemName: "arrow.up")` positioned above Sun
    - For `.dakshinayanam`: `Image(systemName: "arrow.down")` positioned below Sun
  - Set arrow size: `font(.system(size: width * 0.03))` (30% of Sun size)
  - Set arrow color: `foregroundColor(viewModel.design.colorPalette.primaryGold)`
  - Add subtle shadow for visibility

- [ ] T023 [US1] Adjust VStack spacing in `ClockDialView`
  - Reduce `VStack(spacing:)` from `width * 0.02` to `width * 0.01` to accommodate arrow
  - Ensure Sun + arrow + time fit without crowding

- [ ] T024 [US1] Build and verify no compilation errors
  - Run: `xcodebuild build -scheme kadigaram -destination 'platform=iOS Simulator,name=iPhone 17 Pro'`
  - Expected: Build succeeds
  - Fix any import or type errors

**Checkpoint**: At this point, User Story 1 should be fully functional and testable independently

---

## Phase 3: Verification & Testing

**Purpose**: Manual verification and visual validation

### Manual Testing

- [ ] T025 [US1] Test visual indicator presence (light mode)
  - Launch app on simulator (iPhone 17 Pro, iOS 17+)
  - Navigate to dashboard (clock dial view)
  - Verify arrow visible above or below Sun symbol
  - Verify arrow size is approximately 20-30% of Sun symbol
  - Verify arrow color matches theme (gold)
  - Screenshot: `specs/009-ayana-indicator/screenshots/light-mode-indicator.png`

- [ ] T026 [US1] Test visual indicator presence (dark mode)
  - Switch simulator to dark mode: Settings → Display & Brightness → Dark
  - Relaunch app
  - Verify arrow clearly visible against dark background
  - Verify sufficient contrast (WCAG 2.1 AA minimum)
  - Screenshot: `specs/009-ayana-indicator/screenshots/dark-mode-indicator.png`

- [ ] T027 [US1] Test solstice transition (June)
  - Set simulator date to June 21, 2026, 11:59 PM
  - Launch app → verify ↑ arrow (Uttarayanam)
  - Force-close app
  - Set simulator date to June 22, 2026, 12:01 AM
  - Launch app → verify ↓ arrow (Dakshinayanam)
  - Screenshot both states

- [ ] T028 [US1] Test solstice transition (December)
  - Set simulator date to December 21, 2026, 11:59 PM
  - Launch app → verify ↓ arrow (Dakshinayanam)
  - Force-close app
  - Set simulator date to December 22, 2026, 12:01 AM
  - Launch app → verify ↑ arrow (Uttarayanam)
  - Screenshot both states

- [ ] T029 [US1] Test widget consistency (if applicable)
  - Add Kadigaram widget to home screen (if widget shows Sun symbol)
  - Verify arrow indicator present in widget
  - Verify arrow direction matches main app
  - Screenshot: `specs/009-ayana-indicator/screenshots/widget-indicator.png`
  - If widget doesn't show Sun symbol, mark as N/A

- [ ] T030 [US1] Verify no performance degradation
  - Monitor frame rate on dashboard view (should be 60 fps)
  - Check CPU usage (should not increase noticeably)
  - Verify smooth animations (position indicator movement)
  - Use Xcode Instruments if needed

### Regression Testing

- [ ] T031 [US1] Verify existing clock dial functionality unchanged
  - Nazhigai:Vinazhigai time display works
  - Position indicator (sphere) rotates correctly
  - Hour markers visible
  - Background renders correctly
  - No UI layout issues or overlapping elements

- [ ] T032 [US1] Verify moon phase arrow still visible (Feature 008)
  - Paksha arrow (↑ for Shukla, ↓ for Krishna) still renders
  - No overlap with new Ayana arrow
  - Both arrows clearly distinguishable

---

## Phase 4: Polish & Documentation

**Purpose**: Final cleanup and documentation updates

- [ ] T033 [P] Update `README.md` to mention Ayana indicator feature
  - Add bullet point under "Features" section
  - Example: "- **Ayana Indicator**: Visual arrow showing Sun's northward/southward journey (Uttarayanam/Dakshinayanam)"

- [ ] T034 [P] Add comments to `Ayana.swift`
  - Explain Vedic astronomy background
  - Reference solstice dates
  - Mention cultural significance

- [ ] T035 [P] Update `CHANGELOG.md` (if exists)
  - Add entry: "Added: Ayana indicator (↑/↓ arrows) showing Sun's directional movement"
  - Reference Feature 009

- [ ] T036 [US1] Run full test suite to ensure no regressions
  - Run: `xcodebuild test -scheme kadigaram -destination 'platform=iOS Simulator,name=iPhone 17 Pro'`
  - Expected: All existing tests pass
  - Fix any broken tests

- [ ] T037 [US1] Create walkthrough document
  - Document what was implemented
  - Include before/after screenshots
  - List all modified files
  - Testing results summary
  - Write in `specs/009-ayana-indicator/walkthrough.md`

---

## Dependencies & Execution Order

### Phase Dependencies

- **Research & Foundation (Phase 1)**: No dependencies - can start immediately (T001-T005)
- **User Story 1 (Phase 2)**: Depends on Phase 1 completion (esp. T004 contract definition)
  - Tests (T006-T015) can start once contract is defined
  - Implementation (T016-T024) MUST wait for tests to be FAILING first
- **Verification (Phase 3)**: Depends on Phase 2 implementation completion
- **Polish (Phase 4)**: Depends on Phase 3 validation passing

### Within Phase 2 (User Story 1)

**Tests** (T006-T015):
- T006 (create test file) must complete first
- T007-T014 can run in parallel after T006 (all independent test methods)
- T015 (performance test) can run in parallel with T007-T014

**Implementation** (T016-T024):
- T016 (Ayana enum) and T017 (VedicDate extension) can run in parallel [P]
- T018 (calculateAyana) depends on T016 (needs Ayana type)
- T019 (VedicEngine update) depends on T016, T017, T018 (needs all pieces)
- T020 (verify tests) depends on T016-T019 (implementation complete)
- T021 (ClockDialViewModel) can run in parallel with T016-T019 [P] (no changes needed, just verification)
- T022 (ClockDialView UI) depends on T019 (needs Ayana in VedicDate)
- T023 (VStack spacing) depends on T022 (UI addition complete)
- T024 (build verification) depends on T022-T023

### Within Phase 3 (Verification)

- T025-T026 can run in parallel [P] (light/dark mode screenshots)
- T027-T028 can run in parallel [P] (solstice transitions)
- T029 (widget) can run in parallel with T025-T028 [P]
- T030 (performance) can run in parallel with T025-T029 [P]
- T031-T032 (regression) should run after T025-T030 (final validation)

### Within Phase 4 (Polish)

- T033-T035 can run in parallel [P] (documentation updates)
- T036 (full test suite) should run after code is finalized
- T037 (walkthrough) should run last (after all testing complete)

### Parallel Opportunities

**Maximum Parallelization** (if 3+ team members):
1. Foundation: T001-T005 all together (research/documentation)
2. Tests: T007-T015 all together (after T006 creates file)
3. Core Logic: T016 + T017 together, then T018, then T019
4. UI: T022-T023 (after core logic complete)
5. Verification: T025-T030 all together
6. Polish: T033-T035 together

---

## Implementation Strategy

### MVP First (Recommended)

1. **Phase 1**: Complete T001-T005 (Research & Foundation) → ~2 hours
2. **Phase 2**: Complete T006-T024 (User Story 1 + Tests) → ~3 hours
   - Tests first (T006-T015), ensure FAILING
   - Core logic (T016-T019), verify tests PASSING
   - UI integration (T021-T024)
3. **Phase 3**: Complete T025-T032 (Verification) → ~1 hour
4. **Phase 4**: Complete T033-T037 (Polish) → ~1 hour

**STOP at each phase to validate independently before proceeding**

### Sequential Order (Single Developer)

```
T001 → T002 → T003 → T004 → T005 →
T006 → T007 → ... → T015 → (Verify all FAIL)
T016 → T017 → T018 → T019 → T020 (Verify all PASS) →
T021 → T022 → T023 → T024 →
T025 → T026 → T027 → T028 → T029 → T030 → T031 → T032 →
T033 → T034 → T035 → T036 → T037
```

### Parallel Team Strategy (3 team members)

**Day 1**:
- **Developer A**: T001-T002 (Research)
- **Developer B**: T003-T004 (Data model + Contract)
- **Developer C**: T005 (Quickstart)

**Day 2** (after foundation):
- **Developer A**: T006-T015 (Write all tests, verify FAILING)
- **Developer B**: T016-T017 (Ayana enum + VedicDate)
- **Developer C**: T018-T019 (calculateAyana + VedicEngine)

**Day 2 (continued)**:
- **Developer A**: T020 (Verify tests PASS) + T021-T022 (UI integration)
- **Developer B**: T023-T024 (UI polish + build)
- **Developer C**: T025-T030 (Manual verification)

**Day 3**:
- **Developer A**: T031-T032 (Regression)
- **Developer B**: T033-T036 (Documentation + tests)
- **Developer C**: T037 (Walkthrough)

---

## Notes

- **[P] tasks**: Different files, no dependencies, can run in parallel
- **[US1] label**: All tasks belong to User Story 1 (only one story in this feature)
- **Tests first**: Write tests (T006-T015) BEFORE implementation (T016-T024)
- **Verify tests fail**: Run tests after T015, expect 9 failures
- **Verify tests pass**: Run tests after T020, expect 9 passes
- **Commit frequently**: After each task or logical group
- **Visual validation**: Screenshots are critical for UI verification
- **Performance**: Must not degrade existing clock dial performance
- **Accessibility**: Ensure sufficient contrast in both light/dark modes

---

## Estimated Effort

| Phase | Tasks | Duration | Notes |
|-------|-------|----------|-------|
| Phase 1: Research | T001-T005 | 1-2 hours | Documentation and design decisions |
| Phase 2: Implementation | T006-T024 | 3-4 hours | Tests + core logic + UI |
| Phase 3: Verification | T025-T032 | 1-2 hours | Manual testing + screenshots |
| Phase 4: Polish | T033-T037 | 1 hour | Documentation + walkthrough |
| **Total** | **37 tasks** | **6-9 hours** | Single developer, sequential |
| **Parallel** | **37 tasks** | **3-4 hours** | 3 developers, optimal parallelization |

---

## Success Criteria

- [ ] All 9 unit tests pass (AyanaCalculationTests)
- [ ] Build succeeds without errors or warnings
- [ ] Arrow indicator visible on clock dial in both light and dark modes
- [ ] Arrow changes direction correctly on solstice dates (manual test)
- [ ] Performance: calculateAyana() < 5ms per 1000 calls
- [ ] No regressions in existing clock dial functionality
- [ ] No overlap with moon phase arrow (Feature 008)
- [ ] Screenshots captured for all manual tests
- [ ] Walkthrough document complete with before/after comparison

# Tasks: Moon Phase Arrow and Nakshatra Display

**Input**: Design documents from `/specs/008-moon-nakshatra-ui/`
**Prerequisites**: plan.md ✅, spec.md ✅, research.md ✅, data-model.md ✅

**Tests**: Unit tests included as per Constitution requirement (III. Comprehensive Testing Strategy)

**Organization**: Tasks grouped by user story to enable independent implementation and testing.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (US1, US2)
- Includes exact file paths for each task

---

## Phase 1: Setup

**Purpose**: No setup required - using existing project structure

This feature modifies existing components only. No new project setup needed.

**Checkpoint**: Proceed directly to User Story implementation

---

## Phase 2: Foundational

**Purpose**: No foundational changes required

All required data (Paksha, Nakshatra) already exists in VedicDate model. Localization keys already present.

**Checkpoint**: Foundation ready - user story implementation can begin

---

## Phase 3: User Story 1 - Waxing/Waning Arrow Indicator (Priority: P1) 🎯 MVP

**Goal**: Add small up/down arrow next to moon phase icon to indicate waxing (Shukla) or waning (Krishna) moon phase

**Independent Test**: View dashboard and verify arrow direction matches Paksha state (up = waxing, down = waning)

### Tests for User Story 1

- [x] T001 [P] [US1] Create unit test for arrow direction logic in `kadigaram/ios/KadigaramCore/Tests/KadigaramCoreTests/MoonPhaseViewTests.swift`
  - Test: Shukla Paksha returns "chevron.up"
  - Test: Krishna Paksha returns "chevron.down"

### Implementation for User Story 1

- [x] T002 [US1] Add `showPakshaArrow` parameter to MoonPhaseView in `kadigaram/ios/KadigaramCore/Sources/KadigaramCore/UI/Components/MoonPhaseView.swift`
  - Add `var showPakshaArrow: Bool = true` parameter
  - Default to true for backward compatibility

- [x] T003 [US1] Add arrow view to MoonPhaseView body in `kadigaram/ios/KadigaramCore/Sources/KadigaramCore/UI/Components/MoonPhaseView.swift`
  - Wrap existing Image in HStack
  - Add chevron.up for Shukla, chevron.down for Krishna
  - Use `.caption2` font for small arrow
  - Conditionally show based on `showPakshaArrow`

- [x] T004 [US1] Update accessibility label to include arrow direction in `kadigaram/ios/KadigaramCore/Sources/KadigaramCore/UI/Components/MoonPhaseView.swift`
  - Append "(waxing)" or "(waning)" to accessibility label

**Checkpoint**: Arrow indicator should now appear next to moon phase icon on dashboard

---

## Phase 4: User Story 2 - Nakshatra Label Display (Priority: P1)

**Goal**: Display localized Nakshatra name below the existing date row

**Independent Test**: View dashboard and verify Nakshatra label appears below moon phase row, displayed in device language (English or Tamil)

### Implementation for User Story 2

- [x] T005 [P] [US2] Add Nakshatra label to DualDateHeader in `kadigaram/ios/Kadigaram/UI/Components/DualDateHeader.swift`
  - Add Text below existing HStack
  - Use `vedicDate.nakshatra` property
  - Pass through `bhashaEngine.localizedString()` for translation
  - Apply `.subheadline` font
  - Use `theme.secondaryForegroundColor`

- [x] T006 [US2] Add English Nakshatra translations to `kadigaram/ios/Kadigaram/Resources/en.lproj/Localizable.strings` *(verified: already present)*
  - Add all 27 nakshatra keys with English names (if not already present)
  - Format: `"nakshatra_ashwini" = "Ashwini";`

- [x] T007 [P] [US2] Verify Tamil Nakshatra translations exist in `kadigaram/ios/Kadigaram/Resources/ta.lproj/Localizable.strings` *(verified: all 27 present)*
  - Confirm all 27 nakshatra keys are present
  - Already added by user - verification only

**Checkpoint**: Nakshatra label should now appear below date row in both English and Tamil

---

## Phase 5: Polish & Cross-Cutting Concerns

**Purpose**: Final verification and documentation

- [ ] T008 Run manual visual test on iOS Simulator - verify arrow and Nakshatra display correctly *(user to verify)*
- [ ] T009 Run localization test - switch device to Tamil and verify Nakshatra shows in Tamil script *(user to verify)*
- [ ] T010 Run unit tests via: `cd kadigaram/ios && xcodebuild test -scheme KadigaramCore -destination 'platform=iOS Simulator,name=iPhone 17 Pro,OS=26.1'` *(user to run)*

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: Skipped - no setup needed
- **Foundational (Phase 2)**: Skipped - data already exists
- **User Story 1 (Phase 3)**: Can start immediately
- **User Story 2 (Phase 4)**: Can start immediately, parallel to US1
- **Polish (Phase 5)**: After both user stories complete

### User Story Dependencies

- **User Story 1 (Arrow)**: Modifies `MoonPhaseView.swift` only - no cross-dependencies
- **User Story 2 (Nakshatra)**: Modifies `DualDateHeader.swift` only - no cross-dependencies

### Within Each User Story

- T001 (test) should be written first for US1
- T002-T004 can be done sequentially (same file)
- T005-T007 can be done in parallel (different files)

### Parallel Opportunities

```text
# US1 and US2 can run in parallel:
Developer A: T001-T004 (MoonPhaseView changes)
Developer B: T005-T007 (DualDateHeader + localization)
```

---

## Parallel Example

```bash
# Both user stories can start simultaneously:
Task: T001 [US1] Create unit test for arrow direction
Task: T005 [US2] Add Nakshatra label to DualDateHeader

# Within US2, these can run in parallel:
Task: T006 [US2] Add English translations
Task: T007 [US2] Verify Tamil translations
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete T001-T004 (arrow indicator)
2. **STOP and VALIDATE**: Verify arrow appears correctly
3. Deploy/demo if ready

### Full Feature

1. Complete T001-T004 (arrow indicator)
2. Complete T005-T007 (Nakshatra label)
3. Complete T008-T010 (verification)
4. Ready for PR

---

## Summary

| Metric | Value |
|--------|-------|
| **Total Tasks** | 10 |
| **User Story 1 Tasks** | 4 (T001-T004) |
| **User Story 2 Tasks** | 3 (T005-T007) |
| **Polish Tasks** | 3 (T008-T010) |
| **Parallel Opportunities** | US1 and US2 fully parallelizable |
| **Suggested MVP** | User Story 1 (arrow indicator) |

---

## Notes

- [P] tasks = different files, no dependencies
- [Story] label maps task to specific user story
- Both user stories are P1 priority and can be done in either order
- Unit test (T001) follows Constitution requirement III
- Manual tests (T008-T009) for visual verification

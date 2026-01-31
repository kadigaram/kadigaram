# Tasks: Help Screen

**Input**: Design documents from `/specs/010-help-screen/`  
**Prerequisites**: plan.md ✅, spec.md ✅

**Organization**: Tasks grouped by implementation phase to enable incremental delivery

## Format: `[ID] [P?] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- Includes exact file paths for all implementation tasks

## Path Conventions

- **Mobile**: `kadigaram/ios/` (Swift/SwiftUI iOS app)
- **Tests**: `kadigaram/ios/KadigaramTests/` (or similar test target location)

---

## Phase 1: Setup (Project Initialization)

**Purpose**: Create necessary resource files

- [x] T001 [P] Create English help file in `kadigaram/ios/KadigaramCore/Sources/KadigaramCore/Resources/en.lproj/Help.md`
  - Content: Basic markdown with headers, bold text, and lists explaining app features (Vedic time, Alarms, etc.)

- [x] T002 [P] Create Tamil help file in `kadigaram/ios/KadigaramCore/Sources/KadigaramCore/Resources/ta.lproj/Help.md`
  - Content: Tamil translation of the help content

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Implement core logic for content loading

- [x] T003 Create `HelpContentLoader` in `kadigaram/ios/KadigaramCore/Sources/KadigaramCore/Loaders/HelpContentLoader.swift`
  - Implement static `loadContent(for language: AppLanguage) -> String`
  - Use `Bundle.module` matching `BhashaEngine` logic
  - Implement fallback to "en" if specific language file is missing

- [x] T004 [P] Create unit tests in `kadigaram/ios/KadigaramCore/Tests/KadigaramCoreTests/HelpContentLoaderTests.swift`
  - `testLoadEnglish`: Verify English content loads
  - `testLoadTamil`: Verify Tamil content loads
  - `testFallback`: Verify fallback behavior (mocking inputs if possible, or testing logic separation)

---

## Phase 3: User Story 1 - Access Help Content (Priority: P1) 🎯 MVP

**Goal**: Users can open the Help screen from Dashboard and see correct language content

**Independent Test**: Launch app, tap "..." -> "Help", verify Markdown content appears

### Tests for User Story 1

> **NOTE: Write these tests FIRST, ensure they FAIL before implementation**

- [x] T005 [P] [US1] Write UI test or Unit test validating HelpView existence (Optional per spec, but good practice)
  - Verify `HelpView` initializes with content string

### Implementation for User Story 1

#### UI Components

- [x] T006 [P] [US1] Create `HelpView` in `kadigaram/ios/Kadigaram/UI/Screens/HelpView.swift`
  - Use `ScrollView` containing `Text(LocalizedStringKey(content))`
  - Add "Close" button (toolbar or overlay)
  - Style with padding and appropriate font

- [x] T007 [US1] Update `DashboardView` in `kadigaram/ios/Kadigaram/UI/Screens/DashboardView.swift`
  - Add state variable `@State private var showHelp = false`
  - Add "Help" button to the existing Menu (label: "Help", systemImage: "questionmark.circle")
  - Add `.sheet(isPresented: $showHelp) { HelpView(...) }`
  - Load content using `HelpContentLoader` when sheet appears (or pass to view)

---

## Phase 4: Polish & Documentation

**Purpose**: Final cleanup and verification

- [x] T008 [P] Manual Verification - Light/Dark Mode
  - Verify text readability in both modes
  - Verify Markdown rendering (bold, headers)

- [x] T009 [P] Manual Verification - Localization
  - Switch app language to Tamil -> Verify Tamil help
  - Switch app language to English -> Verify English help

- [x] T010 Build Verification
  - Run `xcodebuild build -scheme kadigaram -destination 'platform=iOS Simulator,name=iPhone 17 Pro'`
  - Ensure no warnings/errors

---

## Dependencies & Execution Order

### Phase Dependencies

- **Phase 1 (Setup)**: No dependencies
- **Phase 2 (Foundational)**: Depends on T001/T002 (needs files to exist for logic to be meaningful, though logic can be written first)
- **Phase 3 (User Story 1)**: Depends on Phase 2 (needs Loader)
- **Phase 4 (Polish)**: Depends on Phase 3

### Parallel Opportunities

- T001 and T002 can run in parallel
- T006 (HelpView UI) can run in parallel with T003 (Loader logic) mocked
- T004 (Tests) can run in parallel with implementation

---

## Implementation Strategy

1.  **Setup**: Create the `.md` files first so we have data.
2.  **Logic**: Implement the loader and verify it can read the files.
3.  **UI**: Build the view and connect it to the dashboard.
4.  **Verify**: Check all scenarios.

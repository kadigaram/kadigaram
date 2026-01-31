# Implementation Plan: Help Screen

**Branch**: `010-help-screen` | **Date**: 2026-01-31 | **Spec**: [spec.md](file:///Users/dhilipkumars/dwork/github.com/dhilipkumars/kadigaram/kadigaram/specs/010-help-screen/spec.md)
**Input**: Feature specification from `/specs/010-help-screen/spec.md`

## Summary

This implementation adds a multi-lingual Help screen to the Dashboard. It renders Markdown content from localized files (`Help.md`) located in the app's resource bundles (`.lproj`). The screen is accessible via a new "Help" option in the existing "..." menu.

**Technical Approach**:
1.  Create `Help.md` files for English (`en.lproj`) and Tamil (`ta.lproj`).
2.  Implement `HelpView` (SwiftUI) that loads and renders Markdown text.
3.  Implement `HelpContentLoader` logic to find the correct file based on `BhashaEngine` language state.
4.  Update `DashboardView` to include the "Help" menu item and present `HelpView` as a sheet.

## Technical Context

**Language/Version**: Swift 6.0
**Primary Dependencies**: SwiftUI (Text with Markdown support), Foundation, BhashaEngine
**Storage**: Read-only bundle resources
**Testing**: Unit tests for content loading; Manual verification for UI
**Target Platform**: iOS 17+ (backward compatible to iOS 16)
**Project Type**: Mobile (iOS)
**Performance Goals**: Instant load (< 200ms)
**Constraints**: Must handle missing files gracefully.

## Constitution Check

*No constitution violations detected:*
- ✅ **Separation of Concerns**: Logic for loading content is separated from the View.
- ✅ **Complexity**: Uses standard SwiftUI and Bundle APIs.
- ✅ **Testing**: Unit tests for the loader logic.
- ✅ **Localization**: Directly supports the app's multi-lingual goals.

## Project Structure

### Documentation
```text
specs/010-help-screen/
├── spec.md
├── plan.md              # This file
└── tasks.md             # Task breakdown
```

### Source Code
```text
kadigaram/ios/
├── Kadigaram/
│   ├── Resources/
│   │   ├── en.lproj/Help.md         # [NEW] English help content
│   │   └── ta.lproj/Help.md         # [NEW] Tamil help content
│   └── UI/
│       ├── Screens/
│       │   ├── HelpView.swift       # [NEW] Help screen UI
│       │   └── DashboardView.swift  # [MODIFY] Add menu item
│       └── Components/
│           └── HelpContentLoader.swift # [NEW] Logic to load markdown
```

---

## Phase 0: Outline & Research

### Objectives
1.  Confirm `BhashaEngine` language interaction (Done).
2.  Verify `SwiftUI.Text` Markdown rendering capabilities (Confirmed: iOS 15+ supports basic Markdown).

### Findings
- `BhashaEngine` manually loads bundles using `Bundle(path: ...)`. We should mirror this approach to find `Help.md` in the correct `.lproj` folder.
- `Text(LocalizedStringKey(string))` or `Text(.init(string))` parses Markdown automatically.

---

## Phase 1: Design & Contracts

### 1.1 Data Model
- No persistent data model.
- **Entity**: `HelpContentLoader`
  - `static func loadContent(for language: AppLanguage) -> String`

### 1.2 Resource Structure
- `Resources/en.lproj/Help.md`
- `Resources/ta.lproj/Help.md`

### 1.3 Quickstart
- **Usage**:
  ```swift
  let markdown = HelpContentLoader.loadContent(for: bhashaEngine.currentLanguage)
  Text(.init(markdown))
  ```

---

## Phase 2: Implementation Tasks

**(Detailed tasks will be generated in tasks.md)**

1.  **Resources**: Create `Help.md` files with placeholder content.
2.  **Logic**: Implement `HelpContentLoader` with fallback to English.
3.  **UI**: Create `HelpView` with a ScrollView and Text.
4.  **Integration**: Add "Help" button to `DashboardView` menu.
5.  **Testing**: Unit tests for loader; Manual UI test.

---

## Verification Plan

### Automated Tests
**Unit Tests**: `HelpContentLoaderTests.swift`
- Test loading English content (default).
- Test loading Tamil content.
- Test fallback when specific language file is missing (simulated).

**Run Command**:
```bash
xcodebuild test -scheme Kadigaram -destination 'platform=iOS Simulator,name=iPhone 17 Pro'
```
*(Note: May need to add files to test target)*

### Manual Tests
1.  **Presence**: Tap "..." -> Verify "Help" exists.
2.  **Content**: Tap "Help" -> Open sheet -> Verify content renders as Markdown (headers, bold).
3.  **Localization**:
    - Change language to Tamil.
    - Open "Help" -> Verify Tamil content.
    - Change language to English.
    - Open "Help" -> Verify English content.

### Build Verification
```bash
xcodebuild build -scheme kadigaram -destination 'platform=iOS Simulator,name=iPhone 17 Pro'
```

---

## Exceptions & Risks
- **Risk**: Markdown file not found.
  - **Mitigation**: Fallback to hardcoded safe string ("Help content not available").
- **Risk**: Large file performance.
  - **Mitigation**: Files are expected to be small (< 10KB). `Text` handles this fine.

## Next Steps
1.  Generate `tasks.md` via `/speckit.tasks`.
2.  Execute tasks.

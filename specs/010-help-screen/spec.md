# Feature Specification: Help Screen

**Feature Branch**: `010-help-screen`  
**Created**: 2026-01-31  
**Status**: Draft  
**Input**: User description: "Add a multi lingual help screen... new section under the '...' menu... render from Markdown"

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Access Help Content (Priority: P1)

A user wants to understand how to use the app or interpret the Vedic time, so they access the help screen from the main dashboard.

**Why this priority**: Core usability feature; essential for explaining complex Vedic concepts to new users.

**Independent Test**: Can be tested by launching the app, changing the language, and opening the Help screen to verify correct content.

**Acceptance Scenarios**:

1. **Given** the app is on the Dashboard, **When** the user taps the "..." menu, **Then** a "Help" option is visible.
2. **Given** the user taps "Help", **When** the sheet opens, **Then** it displays the help content formatted from Markdown.
3. **Given** the app language is Tamil, **When** Help is opened, **Then** `ta_help.md` content is displayed.
4. **Given** the app language is set to a language without a specific help file (e.g., hypothetical future lang), **When** Help is opened, **Then** `en_help.md` is displayed as fallback.

---

### Edge Cases

- **Missing File**: If `en_help.md` is also missing (critical error), display a "Content not found" message.
- **Markdown Parsing**: If Markdown contains unsupported tags, `SwiftUI.Text` should render them gracefully (or ignore).
- **Long Content**: Content must be scrollable if it exceeds screen height.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST display a "Help" (or localized equivalent) button in the Dashboard "..." menu.
- **FR-002**: System MUST render help content in a modal sheet presentation.
- **FR-003**: System MUST load content from Markdown files located in the app bundle.
- **FR-004**: System MUST determine the file to load based on the current active language (e.g., `ta` -> `ta_help.md`).
- **FR-005**: System MUST fallback to `en_help.md` if the specific language file is not found.
- **FR-006**: The Help screen MUST support scrolling for long content.
- **FR-007**: The interface MUST allow dismissing the Help screen (standard sheet behavior).

### Key Entities

- **HelpContent**: Represents the loaded string/attributed string from the Markdown file.
- **LanguageCode**: ISO code used to match file names (e.g., "en", "ta").

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Help screen loads and renders text in under 500ms.
- **SC-002**: User can successfully open and close the help screen.
- **SC-003**: Switching app language updates the Help screen content (upon next open).
- **SC-004**: Valid Markdown (headers, bold, lists) renders with correct visual hierarchy.

## Assumptions

- The `Resources` folder will be available in the main bundle at runtime.
- `SwiftUI.Text` with Markdown support (iOS 15+) is sufficient for rendering. No external Markdown library needed.
- Help files (`en_help.md`, `ta_help.md`) will be provided or created as placeholders during implementation.

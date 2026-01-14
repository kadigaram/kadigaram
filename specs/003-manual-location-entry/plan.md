# Implementation Plan: Manual Location Entry

**Branch**: `003-manual-location-entry` | **Date**: 2026-01-14 | **Spec**: [spec.md](spec.md)
**Input**: Feature specification from `/specs/003-manual-location-entry/spec.md`

## Summary

This feature replaces the existing raw Latitude/Longitude input in `SettingsView` with a user-friendly "Searchable Location" interface. Users who deny GPS permissions or prefer manual entry will be able to search for a city by name and select it. The app will persist the selected location's coordinates and name.

The implementation will be executed in **3 Phases**:
1.  **Core Logic**: Implement `LocationSearchService` using `MKLocalSearch` and add unit tests.
2.  **UI Implementation**: Create `LocationSearchView` and integrate it into `SettingsView`.
3.  **Integration & Fallback**: Wire up `AppConfig` updates, ensure data persistence, and verify fallback behavior when GPS is denied.

## Technical Context

**Language/Version**: Swift 6.0
**Primary Dependencies**: `MapKit` (for search), `CoreLocation`, `SwiftUI`
**Storage**: `UserDefaults` (via existing `AppConfig` class)
**Testing**: `XCTest` for search service logic
**Target Platform**: iOS 17+ (based on Swift 6 usage in constitution)
**Project Type**: Mobile (iOS)

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- **Mobile-First Native Excellence**: PASS. Using native `MapKit` and `CoreLocation`.
- **Strict Backward Compatibility**: PASS. `MKLocalSearch` is available since ancient iOS versions.
- **Comprehensive Testing**: PASS. Service layer will be unit tested.
- **Intuitive & Aesthetic Design**: PASS. Search UI is standard and intuitive compared to Lat/Long entry.

## Project Structure

### Documentation (this feature)

```text
specs/003-manual-location-entry/
├── plan.md              # This file
├── research.md          # Phase 0 output
├── data-model.md        # Phase 1 output
└── tasks.md             # Phase 2 output
```

### Source Code

```text
kadigaram/ios/
├── KadigaramCore/
│   ├── Sources/KadigaramCore/
│   │   ├── Engines/
│   │   │   └── LocationSearchService.swift  # [NEW] Phase 1
│   │   ├── Models/
│   │   │   └── LocationResult.swift         # [NEW] Phase 1
│   └── Tests/KadigaramCoreTests/
│       └── LocationSearchServiceTests.swift # [NEW] Phase 1
│
└── Kadigaram/
    └── UI/
        ├── Sheets/
        │   └── LocationSearchView.swift     # [NEW] Phase 2
        └── Screens/
            └── SettingsView.swift           # [MODIFY] Phase 3
```

**Structure Decision**: Add search logic to `KadigaramCore` for reusability (e.g. Widget), and UI to main app.

## Execution Plan (3 Phases)

### Phase 1: Core Logic & Services
- **Goal**: Enable searching for locations programmatically.
- **Tasks**:
    1.  Create `LocationResult` struct (name, coordinate, timezone).
    2.  Implement `LocationSearchService` using `MKLocalSearch`.
    3.  Add `search(query: String) async -> [LocationResult]` method.
    4.  Write unit tests to verify search behavior (start mock/stub if MKLocalSearch is hard to test, or simple integration test).

### Phase 2: User Interface
- **Goal**: Create the visual components for search.
- **Tasks**:
    1.  Create `LocationSearchView` (SwiftUI).
    2.  Implement search bar and list of results.
    3.  Handle "Loading" and "No Results" states.
    4.  Preview with mock data.

### Phase 3: Integration & Fallback
- **Goal**: Connect UI to Data and ensure fallback works.
- **Tasks**:
    1.  Modify `SettingsView` to present `LocationSearchView` when "Manual" is enabled.
    2.  Update `AppConfig` to store `locationName` (currently missing) alongside lat/long.
    3.  Update `LocationManager` to respect the manual override.
    4.  Verify "Permission Denied" flow -> User sets manual location -> App works.

## Verification Plan

### Automated Tests
- **Unit Tests**: Run `swift test` in `KadigaramCore`.
    - `LocationSearchServiceTests`: Verify query handling and result parsing.

### Manual Verification
1.  **Search Flow**:
    - Go to Settings -> Enable Manual Location.
    - Tap "Search Location".
    - Type "Chennai".
    - Select "Chennai, India".
    - Verify Lat/Long updates in Settings/AppConfig.
2.  **Persistence**:
    - Kill app.
    - Relaunch.
    - Verify "Chennai" is still selected.
3.  **Fallback**:
    - Deny Location Permission (if possible, or simulate).
    - Ensure App uses Manual Location data for calculations.

# Tasks: Manual Location Entry

**Feature Branch**: `003-manual-location-entry`
**Status**: Planning

## Phase 1: Core Logic & Services (Plan Phase 1)
*Goal: Enable searching for locations programmatically using MapKit.*

- [x] T001 [US1] Create `LocationResult` struct in `kadigaram/ios/KadigaramCore/Sources/KadigaramCore/Models/LocationResult.swift`
- [x] T002 [US1] Implement `LocationSearchService` using `MKLocalSearch` in `kadigaram/ios/KadigaramCore/Sources/KadigaramCore/Engines/LocationSearchService.swift`
- [x] T003 [US1] Add `search(query: String) async -> [LocationResult]` method to `LocationSearchService` in `kadigaram/ios/KadigaramCore/Sources/KadigaramCore/Engines/LocationSearchService.swift`
- [x] T004 [US1] Create unit tests for `LocationSearchService` in `kadigaram/ios/KadigaramCore/Tests/KadigaramCoreTests/LocationSearchServiceTests.swift`

## Phase 2: User Interface (Plan Phase 2)
*Goal: Create the visual components for search.*

- [x] T005 [US1] Create `LocationSearchView` SwiftUI view in `kadigaram/ios/Kadigaram/UI/Sheets/LocationSearchView.swift`
- [x] T006 [US1] Implement search bar and results list in `kadigaram/ios/Kadigaram/UI/Sheets/LocationSearchView.swift`
- [x] T007 [US1] Handle "Loading" and "No Results" states in `kadigaram/ios/Kadigaram/UI/Sheets/LocationSearchView.swift`
- [x] T008 [US1] Add preview with mock data to `kadigaram/ios/Kadigaram/UI/Sheets/LocationSearchView.swift`

## Phase 3: Integration & Fallback (Plan Phase 3)
*Goal: Connect UI to Data and ensure fallback works.*

- [x] T009 [US2] Update `AppConfig` to store `locationName` and `timeZone` in `kadigaram/ios/KadigaramCore/Sources/KadigaramCore/Models/AppConfig.swift`
- [x] T010 [US1] Modify `SettingsView` to present `LocationSearchView` when "Manual" is enabled in `kadigaram/ios/Kadigaram/UI/Screens/SettingsView.swift`
- [x] T011 [US3] Update `LocationManager` to respect manual override cleanly in `kadigaram/ios/KadigaramCore/Sources/KadigaramCore/Engines/LocationManager.swift`
- [x] T012 [US2] Verify persistence of manual location across app restarts (Manual Verification)

## Phase 4: Polish & Cross-Cutting
*Goal: Edge cases and final cleanup.*

- [x] T013 [US3] Ensure Settings UI reflects "Manual" vs "GPS" status clearly in `kadigaram/ios/Kadigaram/UI/Screens/SettingsView.swift`
- [x] T014 [US1] Handle error states (e.g., offline) in `LocationSearchView.swift`

## Dependencies

- Phase 2 requires `LocationSearchService` (Phase 1)
- Phase 3 requires `LocationSearchView` (Phase 2) and updated `AppConfig`

## Implementation Strategy
- Build the service layer first to ensure we have data.
- Build the UI in isolation using Previews.
- Wire it all together in `SettingsView`.

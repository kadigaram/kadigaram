# Tasks: UI and Calculation Enhancements

**Feature Branch**: `004-ui-calculation-enhancements`
**Status**: Planning

## Phase 1: Visual Enhancements (Plan Phase 1)
*Goal: Improve dial aesthetics and readability with 3D embossed style and better contrast*

- [x] T001 [US1] Update `NazhigaiWheel.swift` to add 3D embossed visual effects (inner shadow, outer glow, gradient overlay) in `kadigaram/ios/KadigaramCore/Sources/KadigaramCore/UI/Components/NazhigaiWheel.swift`
- [x] T002 [US1] Adjust background colors in `DashboardView.swift` to provide better contrast with golden dial in `kadigaram/ios/Kadigaram/UI/Screens/DashboardView.swift`
- [x] T003 [US1] Change Yamagandam segment color from red to grey with theme-based adaptation (light grey for dark mode, dark grey for light mode) in `kadigaram/ios/KadigaramCore/Sources/KadigaramCore/UI/Components/NazhigaiWheel.swift`
- [x] T004 [US1] Test visual changes on both light and dark system themes to verify contrast and readability

## Phase 2: 24-Hour Time Labels (Plan Phase 2)
*Goal: Add modern time reference aligned to sunrise*

- [x] T005 [US2] Calculate 24 hourly angle positions around dial starting from sunrise time in `kadigaram/ios/KadigaramCore/Sources/KadigaramCore/UI/Components/NazhigaiWheel.swift`
- [x] T006 [US2] Add Text labels for each hour (or every 2 hours if crowded) around dial perimeter with 24hr format (HH:mm) in `kadigaram/ios/KadigaramCore/Sources/KadigaramCore/UI/Components/NazhigaiWheel.swift`
- [x] T007 [US2] Ensure time labels rotate/position correctly relative to dynamic sunrise time for different locations
- [x] T008 [US2] Test time label alignment with actual sunrise times for multiple global cities

## Phase 3: Accurate Vedic Calculations (Plan Phase 3)
*Goal: Replace stub calculations with astronomically accurate ones using Swiss Ephemeris*

- [x] T009 [US3] Research and integrate Swiss Ephemeris Swift wrapper or create minimal C bridge wrapper in `kadigaram/ios/KadigaramCore/Package.swift`
- [x] T010 [US3] Create `AstronomicalCalculator.swift` wrapper class for ephemeris library in `kadigaram/ios/KadigaramCore/Sources/KadigaramCore/Engines/AstronomicalCalculator.swift`
- [x] T011 [US3] Implement accurate Tithi calculation using moon-sun longitudinal difference in `kadigaram/ios/KadigaramCore/Sources/KadigaramCore/Engines/VedicEngine.swift`
- [x] T012 [US3] Implement accurate Nakshatra calculation using moon ecliptic position in `kadigaram/ios/KadigaramCore/Sources/KadigaramCore/Engines/VedicEngine.swift`
- [x] T013 [US3] Verify and update Samvatsara calculation accuracy in `kadigaram/ios/KadigaramCore/Sources/KadigaramCore/Engines/VedicEngine.swift`
- [x] T014 [US3] Implement accurate Maasa calculation based on solar/lunar calendar system in `kadigaram/ios/KadigaramCore/Sources/KadigaramCore/Engines/VedicEngine.swift`
- [x] T015 [US3] Create unit tests comparing output against Dhrik Panchang reference data in `kadigaram/ios/KadigaramCore/Tests/KadigaramCoreTests/VedicEngineAccuracyTests.swift`
- [x] T016 [US3] Manually verify calculations against Dhrik Panchang website for 10+ test dates across different locations

## Dependencies

- Phase 2 requires sunrise time calculation (already available from `AstronomicalEngine`)
- Phase 3 requires astronomical library integration before calculation updates

## Implementation Strategy
- Phase 1 is purely visual and can be completed independently
- Phase 2 builds on existing sunrise/sunset data
- Phase 3 is the most complex, requiring external library integration and extensive testing

# Tasks: Kadigaram Core

**Feature Branch**: `001-kadigaram-core`
**Status**: Generated

## Dependencies

- Phase 1 (Setup) -> Phase 2 (Foundation)
- Phase 2 (Foundation) -> Phase 3 (US1), Phase 4 (US2), Phase 5 (US3)
- Phase 3 (US1) & Phase 2 (Foundation) -> Phase 6 (US4 - Watch)

## Parallel Execution Opportunities

- **US2 (Localization)** can be developed in parallel with **US3 (Settings)** once Phase 2 (Foundation) is complete.
- **US4 (Watch)** requires Core Logic (Phase 2) but can be started before the Main App UI (Phase 3) is polished.

## Implementation Strategy

We will follow a strict **Backend-First (Logic-First)** approach on the client side:
1.  **Engines**: Build the math and logic first (Phase 2).
2.  **UI**: Build the Visuals on top of reliable engines (Phase 3).
3.  **Extensions**: Port the engines to Watch (Phase 6).

---

## Phase 1: Setup

*Goal: Initialize the iOS Monorepo and Project Structure*

- [x] T001 Create `kadigaram/ios` directory structure and initialize Xcode Project `Kadigaram` <!-- id: 18 -->
- [x] T002 Create local Swift Package `KadigaramCore` for shared logic (App + Watch) <!-- id: 19 -->
- [x] T003 Configure App Target to link `KadigaramCore` <!-- id: 20 -->
- [x] T004 Setup Unit Test Target `KadigaramTests` <!-- id: 21 -->
- [x] T005 Setup UI Test Target `KadigaramUITests` <!-- id: 22 -->

## Phase 2: Foundational (Core Architecture)

*Goal: Functional "Headless" Engines (Vedic Math, Location, Date)*

- [x] T006 [P] Implement `VedicTime` struct in `KadigaramCore/Sources/Models/VedicTime.swift` <!-- id: 23 -->
- [x] T007 [P] Implement `VedicDate` struct in `KadigaramCore/Sources/Models/VedicDate.swift` <!-- id: 24 -->
- [x] T008 [P] Implement `VedicEngine` protocol and Math Logic in `KadigaramCore/Sources/Engines/VedicEngine.swift` <!-- id: 25 -->
- [x] T009 Create Unit Tests for `VedicEngine` with known test cases (Chennai sunrise) in `KadigaramTests/VedicEngineTests.swift` <!-- id: 26 -->
- [x] T010 Implement `LocationManager` with `CoreLocation` and Manual Entry support in `KadigaramCore/Sources/Engines/LocationManager.swift` <!-- id: 27 -->
- [x] T011 Create `AppConfig` model for UserDefaults persistence in `KadigaramCore/Sources/Models/AppConfig.swift` <!-- id: 28 -->

## Phase 3: User Story 1 - Dual Time Dashboard (P1)

*Goal: The primary dashboard with Nazhigai Wheel*

- [x] T012 [US1] Create `DashboardView` scaffolding in `Kadigaram/UI/Screens/DashboardView.swift` <!-- id: 29 -->
- [x] T013 [US1] Implement `NazhigaiWheel` custom shape/drawing in `Kadigaram/UI/Components/NazhigaiWheel.swift` <!-- id: 30 -->
- [x] T014 [US1] Implement `DualDateHeader` view in `Kadigaram/UI/Components/DualDateHeader.swift` <!-- id: 31 -->
- [x] T015 [US1] Wire `VedicEngine` to `DashboardView` via ViewModel <!-- id: 32 -->
- [x] T016 [US1] Implement 60fps Timer loop for smooth Wheel rotation <!-- id: 33 -->
- [x] T017 [US1] Verify Layout on iPad Simulator (Scaling check) <!-- id: 34 -->

## Phase 4: User Story 2 - Bhasha Engine (P2)

*Goal: In-app Language Switching*

- [x] T018 [US2] Implement `BhashaEngine` (Localization Manager) in `KadigaramCore/Sources/Engines/BhashaEngine.swift` <!-- id: 35 -->
- [ ] T019 [US2] Import Custom Fonts (Noto Sans, Eczar) into `Kadigaram/Resources/Fonts` and `Info.plist` <!-- id: 36 -->
- [x] T020 [US2] Create String Catalogs (`Localizable.xcstrings`) for supported languages (en, sa, ta, te, kn, ml) <!-- id: 37 -->
- [x] T021 [US2] Create Language Toggle UI/Menu in `Kadigaram/UI/Components/LanguageToggle.swift` <!-- id: 38 -->
- [x] T022 [US2] Integrate `BhashaEngine` into `DashboardView` environment <!-- id: 39 -->

## Phase 5: User Story 3 - Calendar Configuration (P3)

*Goal: Solar/Lunar Settings*

- [x] T023 [US3] Create `SettingsView` in `Kadigaram/UI/Screens/SettingsView.swift` <!-- id: 40 -->
- [x] T024 [US3] Implement Month System Toggle (Solar/Lunar) binding to `AppConfig` <!-- id: 41 -->
- [x] T025 [US3] Update `VedicEngine` to respect selected Month System <!-- id: 42 -->

## Phase 6: User Story 4 - Apple Watch Complications (P4)

*Goal: WidgetKit Integration*

- [x] T026 [US4] Add Widget Extension Target `KadigaramWidget` <!-- id: 43 -->
- [x] T027 [US4] Link `KadigaramCore` to Widget Target <!-- id: 44 -->
- [x] T028 [US4] Implement `NazhigaiProvider` (TimelineProvider) in `KadigaramWidget/NazhigaiProvider.swift` <!-- id: 45 -->
- [x] T029 [US4] Create Complication UI Views in `KadigaramWidget/Complications.swift` <!-- id: 46 -->
- [ ] T030 [US4] Verify Complications in Watch Simulator <!-- id: 47 -->

## Implementation: Phase 7 (Polish & UI Upgrade)

- [ ] T031 [US5] Implement Manual Location Entry in `SettingsView` <!-- id: 51 -->
- [x] T032 [US5] Implement Premium UI (Golden Wheel, Info Cards) to match design <!-- id: 52 -->
- [x] T033 [US5] Implement Info.plist for Custom Fonts (User to provide files) <!-- id: 53 -->
- [x] T034 [P7] Verify Bundle Size & Performance <!-- id: 54 -->


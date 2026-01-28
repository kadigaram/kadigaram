# Implementation Tasks: Clock UI Improvements

**Feature**: 006-clock-ui-improvements  
**Branch**: `006-clock-ui-improvements`  
**Created**: 2026-01-24  
**Status**: Ready for Implementation

---

## Task Overview

This document provides a dependency-ordered, actionable task list for implementing the Clock UI Improvements feature. Tasks are organized into **3 phases** to enable incremental development, testing, and validation.

### Phase Summary

| Phase | Focus | Tasks | Estimated Effort |
|-------|-------|-------|------------------|
| **Phase 1** | Theme & Foundation | T001-T010 | 2-3 days |
| **Phase 2** | Clock Dial & Layout | T011-T020 | 3-4 days |
| **Phase 3** | Widget & Testing | T021-T030 | 2-3 days |

**Total**: 30 tasks | **8-10 days** estimated

---

## Phase 1: Theme & Foundation

**Goal**: Implement theme system and light mode background

**Duration**: 2-3 days  
**Deliverables**: Working theme system with light mode grey background

### T001: Create Theme Configuration Data Structures

**Priority**: P0 (Blocker for all theme-related tasks)  
**Estimated Time**: 2 hours  
**Dependencies**: None

**Description**:
Create the foundational data structures for theme management based on `data-model.md`.

**Acceptance Criteria**:
- [x] Create `ThemeConfiguration` struct with all properties from data model
- [x] Create `BackgroundColors` struct with light/dark mode variants
- [x] Create `ForegroundColors` struct for text colors
- [x] Create `AccessibilitySettings` struct
- [x] All structs compile without errors
- [x] Add unit tests for struct initialization

**Files to Create/Modify**:
- `kadigaram/ios/Kadigaram/UI/Theme/ThemeConfiguration.swift` [NEW]
- `kadigaram/ios/KadigaramTests/ThemeConfigurationTests.swift` [NEW]

---

### T002: Implement AppTheme Class

**Priority**: P0 (Blocker)  
**Estimated Time**: 3 hours  
**Dependencies**: T001

**Description**:
Implement the `AppTheme` ObservableObject class that manages theme state.

**Acceptance Criteria**:
- [x] Create `AppTheme` class conforming to `ObservableObject`
- [x] Implement `@Published` properties for color scheme
- [x] Implement `color(for:)` method for scheme-based colors
- [x] Implement `updateColorScheme(_:)` method
- [x] Add default factory method
- [x] Write unit tests for all methods

**Files to Create/Modify**:
- `kadigaram/ios/Kadigaram/UI/Theme/AppTheme.swift` [NEW]
- `kadigaram/ios/KadigaramTests/AppThemeTests.swift` [NEW]

---

### T003: Define Light Mode Color Constants

**Priority**: P0 (Blocker)  
**Estimated Time**: 1 hour  
**Dependencies**: T001

**Description**:
Define color constants using iOS system colors for light mode background.

**Acceptance Criteria**:
- [x] Add `Color.systemGray6Background` extension
- [x] Add `Color.lightModeBackground` convenience property
- [x] Add color preview in SwiftUI Previews
- [x] Verify color matches #F2F2F7 approximate
- [x] Test on light and dark mode

**Files to Create/Modify**:
- `kadigaram/ios/Kadigaram/UI/Theme/ColorExtensions.swift` [NEW]

---

### T004: Integrate Theme into App Entry Point

**Priority**: P0 (Blocker)  
**Estimated Time**: 1 hour  
**Dependencies**: T002

**Description**:
Inject `AppTheme` as environment object in main app.

**Acceptance Criteria**:
- [x] Create `@StateObject var theme = AppTheme()` in App struct
- [x] Add `.environmentObject(theme)` to root view
- [x] Verify theme is accessible in child views
- [x] Test hot reload works with theme changes

**Files to Create/Modify**:
- `kadigaram/ios/Kadigaram/KadigaramApp.swift` [MODIFY]

---

### T005: Apply Light Mode Background to DashboardView

**Priority**: P1 (Critical)  
**Estimated Time**: 2 hours  
**Dependencies**: T002, T004

**Description**:
Update `DashboardView` to use theme-based background color.

**Acceptance Criteria**:
- [x] Add `@EnvironmentObject var theme: AppTheme`
- [x] Replace background with `theme.backgroundColor`
- [x] Use `.ignoresSafeArea()` for edge-to-edge background
- [x] Test in light mode (should be grey)
- [x] Test in dark mode (should stay dark)
- [x] Verify smooth transition between modes

**Files to Create/Modify**:
- `kadigaram/ios/Kadigaram/UI/Screens/DashboardView.swift` [MODIFY]

---

### T006: Apply Theme to DualDateHeader

**Priority**: P1 (Critical)  
**Estimated Time**: 1 hour  
**Dependencies**: T005

**Description**:
Update `DualDateHeader` to use theme colors for text.

**Acceptance Criteria**:
- [x] Add `@EnvironmentObject var theme: AppTheme`
- [x] Use `theme.foregroundColor` for text
- [x] Ensure Dynamic Type support maintained
- [x] Test contrast in both modes

**Files to Create/Modify**:
- `kadigaram/ios/Kadigaram/UI/Components/DualDateHeader.swift` [MODIFY]

---

### T007: Implement Accessibility Support

**Priority**: P1 (Critical)  
**Estimated Time**: 2 hours  
**Dependencies**: T002

**Description**:
Add support for iOS accessibility features (Increase Contrast, Reduce Transparency).

**Acceptance Criteria**:
- [x] Observe `@Environment(\.colorSchemeContrast)` in AppTheme
- [x] Implement `applyIncreasedContrast()` method
- [x] Adjust colors when contrast is increased
- [x] Test with Increase Contrast enabled
- [x] Verify WCAG AA compliance (4.5:1 minimum)

**Files to Create/Modify**:
- `kadigaram/ios/Kadigaram/UI/Theme/AppTheme.swift` [MODIFY]
- `kadigaram/ios/KadigaramTests/AccessibilityTests.swift` [NEW]

---

### T008: Create Theme Unit Tests

**Priority**: P2 (Important)  
**Estimated Time**: 2 hours  
**Dependencies**: T002, T003

**Description**:
Write comprehensive unit tests for theme system.

**Acceptance Criteria**:
- [x] Test light mode color selection
- [x] Test dark mode color selection
- [x] Test color scheme switching
- [x] Test accessibility contrast adjustments
- [x] Test default theme initialization
- [x] Achieve 90%+ code coverage for theme code

**Files to Create/Modify**:
- `kadigaram/ios/KadigaramTests/ThemeTests.swift` [NEW]

---

### T009: Create Theme UI Tests

**Priority**: P2 (Important)  
**Estimated Time**: 2 hours  
**Dependencies**: T005, T006

**Description**:
Create UI tests to verify theme application across screens.

**Acceptance Criteria**:
- [ ] Test launching app in light mode
- [ ] Test launching app in dark mode
- [ ] Test switching modes while app is running
- [ ] Verify background color changes
- [ ] Verify text remains readable

**Files to Create/Modify**:
- `kadigaram/ios/KadigaramUITests/ThemeUITests.swift` [NEW]

---

### T010: Document Theme Usage

**Priority**: P3 (Nice to have)  
**Estimated Time**: 1 hour  
**Dependencies**: T002

**Description**:
Add documentation and usage examples for theme system.

**Acceptance Criteria**:
- [ ] Add header documentation to `AppTheme.swift`
- [ ] Add usage examples in comments
- [ ] Add code snippets to README (if exists)
- [ ] Create SwiftUI Previews showing theme variants

**Files to Create/Modify**:
- `kadigaram/ios/Kadigaram/UI/Theme/AppTheme.swift` [MODIFY]

---

## Phase 2: Clock Dial & Layout

**Goal**: Redesign clock dial and implement adaptive layout

**Duration**: 3-4 days  
**Deliverables**: Icon-matched clock dial with landscape optimization

### T011: Extract Colors from App Icon

**Priority**: P0 (Blocker for dial design)  
**Estimated Time**: 2 hours  
**Dependencies**: None (can run parallel to Phase 1)

**Description**:
Create utility to extract dominant colors from app icon for dial design.

**Acceptance Criteria**:
- [x] Create `UIImage` extension for color extraction
- [x] Extract primary burgundy/maroon color from icon
- [x] Extract secondary gold/amber color from icon
- [x] Store colors in `DialColorPalette` struct
- [x] Add unit tests for color extraction
- [x] Verify extracted colors match icon visually

**Files to Create/Modify**:
- `kadigaram/ios/Kadigaram/UI/Utilities/ImageColorExtraction.swift` [NEW]
- `kadigaram/ios/KadigaramTests/ColorExtractionTests.swift` [NEW]

---

### T012: Create Clock Dial Data Structures

**Priority**: P0 (Blocker)  
**Estimated Time**: 2 hours  
**Dependencies**: T011

**Description**:
Implement data structures for clock dial design from `data-model.md`.

**Acceptance Criteria**:
- [x] Create `ClockDialDesign` struct
- [x] Create `DialColorPalette` struct
- [x] Create `RadialGradientConfig` struct
- [x] Create `DialStrokeStyles` struct
- [x] Create `DialGeometry` struct
- [x] Create `DialAnimationConfig` struct
- [x] Add default factory methods

**Files to Create/Modify**:
- `kadigaram/ios/Kadigaram/UI/Components/ClockDialDesign.swift` [NEW]

---

### T013: Implement ClockDialViewModel

**Priority**: P0 (Blocker)  
**Estimated Time**: 3 hours  
**Dependencies**: T012

**Description**:
Create view model for clock dial with time calculations.

**Acceptance Criteria**:
- [x] Create `ClockDialViewModel` as `ObservableObject`
- [x] Implement `@Published var currentTime: Date`
- [x] Implement `hourHandAngle()` method (0-360 degrees)
- [x] Implement `minuteHandAngle()` method (0-360 degrees)
- [x] Implement `updateTime()` method with Timer
- [x] Implement `applyIconDesign(iconColors:)` method
- [x] Add unit tests for angle calculations

**Files to Create/Modify**:
- `kadigaram/ios/Kadigaram/UI/Components/ClockDialViewModel.swift` [NEW]
- `kadigaram/ios/KadigaramTests/ClockDialViewModelTests.swift` [NEW]

---

### T014: Create ClockDialShape Custom Shape

**Priority**: P1 (Critical)  
**Estimated Time**: 4 hours  
**Dependencies**: T012

**Description**:
Implement SwiftUI `Shape` for rendering clock dial with icon-matched design.

**Acceptance Criteria**:
- [x] Create `ClockDialShape` conforming to `Shape` protocol
- [x] Implement `path(in:)` method
- [x] Draw outer circle
- [x] Draw concentric inner rings (based on geometry)
- [x] Draw hour markers at 12 positions
- [x] Draw decorative elements at cardinal points
- [x] Ensure path is animatable
- [x] Test rendering at multiple sizes

**Files to Create/Modify**:
- `kadigaram/ios/Kadigaram/UI/Components/ClockDialShape.swift` [NEW]

---

### T015: Create ClockRingShape for Concentric Circles

**Priority**: P2 (Important)  
**Estimated Time**: 2 hours  
**Dependencies**: T014

**Description**:
Create reusable shape for concentric rings within clock dial.

**Acceptance Criteria**:
- [x] Create `ClockRingShape` conforming to `Shape`
- [x] Accept `ringIndex` and `design` parameters
- [x] Calculate ring radius based on index and spacing
- [x] Return circular path at calculated radius
- [x] Support configurable stroke styles

**Files to Create/Modify**:
- `kadigaram/ios/Kadigaram/UI/Components/ClockRingShape.swift` [NEW]

---

### T016: Implement ClockDialView

**Priority**: P1 (Critical)  
**Estimated Time**: 4 hours  
**Dependencies**: T013, T014, T015

**Description**:
Create main clock dial view integrating all components.

**Acceptance Criteria**:
- [x] Create `ClockDialView` SwiftUI view
- [x] Add `@ObservedObject var viewModel: ClockDialViewModel`
- [x] Render gradient background using `ClockDialShape`
- [x] Render concentric rings using `ClockRingShape`
- [x] Render hour markers
- [x] Render hour and minute hands
- [x] Apply radial gradient from design
- [x] Add smooth animations for hand rotation
- [x] Maintain 60fps performance
- [x] Create SwiftUI Previews

**Files to Create/Modify**:
- `kadigaram/ios/Kadigaram/UI/Components/ClockDialView.swift` [MODIFY or NEW]

---

### T017: Create Layout Configuration Structures

**Priority**: P0 (Blocker for layout)  
**Estimated Time**: 2 hours  
**Dependencies**: None (parallel)

**Description**:
Implement layout configuration data structures from `data-model.md`.

**Acceptance Criteria**:
- [x] Create `LayoutConfiguration` struct
- [x] Create `SizeClassConfiguration` struct
- [x] Create `ScalingFactors` struct
- [x] Create `LayoutConstraints` struct
- [x] Create `SafeAreaStrategy` enum
- [x] Implement `dialSize(for:)` computed method
- [x] Add unit tests for size calculations

**Files to Create/Modify**:
- `kadigaram/ios/Kadigaram/UI/Layout/LayoutConfiguration.swift` [NEW]
- `kadigaram/ios/KadigaramTests/LayoutConfigurationTests.swift` [NEW]

---

### T018: Implement AdaptiveLayoutModifier

**Priority**: P1 (Critical)  
**Estimated Time**: 3 hours  
**Dependencies**: T017

**Description**:
Create ViewModifier for adaptive layout based on orientation.

**Acceptance Criteria**:
- [x] Create `AdaptiveLayoutModifier` conforming to `ViewModifier`
- [x] Observe `@Environment(\.horizontalSizeClass)`
- [x] Observe `@Environment(\.verticalSizeClass)`
- [x] Implement `isLandscape` computed property
- [x] Implement `scalingFactor(for:)` method
- [x] Apply frame with calculated size
- [x] Add smooth animation on orientation change
- [x] Test portrait and landscape modes

**Files to Create/Modify**:
- `kadigaram/ios/Kadigaram/UI/ViewModifiers/AdaptiveLayoutModifier.swift` [NEW]

---

### T019: Create AdaptiveClockDialView

**Priority**: P1 (Critical)  
**Estimated Time**: 3 hours  
**Dependencies**: T016, T018

**Description**:
Wrapper view that applies adaptive layout to clock dial.

**Acceptance Criteria**:
- [x] Create `AdaptiveClockDialView`
- [x] Use `GeometryReader` to get available space
- [x] Calculate dial size using `LayoutConfiguration`
- [x] Apply size to `ClockDialView`
- [x] Center dial in available space
- [x] Respect safe areas
- [x] Handle orientation changes with `.onChange`
- [x] Test on multiple device sizes

**Files to Create/Modify**:
- `kadigaram/ios/Kadigaram/UI/Components/AdaptiveClockDialView.swift` [NEW]

---

### T020: Integrate Adaptive Dial into DashboardView

**Priority**: P1 (Critical)  
**Estimated Time**: 2 hours  
**Dependencies**: T019, T005

**Description**:
Replace existing clock dial in DashboardView with adaptive version.

**Acceptance Criteria**:
- [ ] Replace old clock dial with `AdaptiveClockDialView`
- [ ] Verify portrait mode works
- [ ] Verify landscape mode maximizes height
- [ ] Verify rotation animations are smooth
- [ ] Test on iPhone SE, iPhone 15 Pro, iPhone 15 Pro Max
- [ ] Test on iPad in various configurations

**Files to Create/Modify**:
- `kadigaram/ios/Kadigaram/UI/Screens/DashboardView.swift` [MODIFY]

---

## Phase 3: Widget & Testing

**Goal**: Implement live widget updates and comprehensive testing

**Duration**: 2-3 days  
**Deliverables**: Working widget with live time, full test suite

### T021: Create Widget Data Cache

**Priority**: P0 (Blocker for widget)  
**Estimated Time**: 2 hours  
**Dependencies**: None

**Description**:
Implement shared data cache for app ↔ widget communication.

**Acceptance Criteria**:
- [ ] Create `WidgetDataCache` class
- [ ] Initialize with App Group container (`group.com.kadigaram.app`)
- [ ] Implement `saveLocation(_:)` method
- [ ] Implement `retrieveLocation()` method
- [ ] Implement `saveVedicTime(_:)` method
- [ ] Implement `retrieveVedicTime()` method
- [ ] Implement `triggerWidgetReload()` method
- [ ] Add unit tests for all methods

**Files to Create/Modify**:
- `kadigaram/ios/Kadigaram/Widget/WidgetDataCache.swift` [NEW]
- `kadigaram/ios/KadigaramTests/WidgetDataCacheTests.swift` [NEW]

---

### T022: Configure App Group Entitlement

**Priority**: P0 (Blocker for widget data sharing)  
**Estimated Time**: 30 minutes  
**Dependencies**: T021

**Description**:
Add App Group entitlement for data sharing between app and widget.

**Acceptance Criteria**:
- [ ] Add App Group capability to main app target
- [ ] Add App Group capability to widget extension target
- [ ] Use identifier: `group.com.kadigaram.app`
- [ ] Verify entitlements file is updated
- [ ] Test data can be written and read across targets

**Files to Create/Modify**:
- `kadigaram/ios/Kadigaram/Kadigaram.entitlements` [MODIFY]
- `kadigaram/ios/KadigaramWidget/KadigaramWidget.entitlements` [MODIFY]

---

### T023: Create Widget Timeline Configuration

**Priority**: P0 (Blocker)  
**Estimated Time**: 2 hours  
**Dependencies**: None

**Description**:
Implement widget timeline configuration from `data-model.md`.

**Acceptance Criteria**:
- [ ] Create `WidgetTimelineConfiguration` struct
- [ ] Define `TimelineReloadPolicy` enum
- [ ] Define `WidgetUpdateTrigger` enum
- [ ] Create `ClockWidgetEntry` conforming to `TimelineEntry`
- [ ] Add default factory method
- [ ] Add unit tests

**Files to Create/Modify**:
- `kadigaram/ios/KadigaramWidget/WidgetTimelineConfiguration.swift` [NEW]

---

### T024: Implement KadigaramWidgetTimelineProvider

**Priority**: P1 (Critical)  
**Estimated Time**: 4 hours  
**Dependencies**: T021, T023

**Description**:
Create timeline provider for widget with battery-efficient updates.

**Acceptance Criteria**:
- [ ] Create `KadigaramWidgetTimelineProvider` conforming to `TimelineProvider`
- [ ] Implement `placeholder(in:)` method
- [ ] Implement `getSnapshot(in:completion:)` method
- [ ] Implement `getTimeline(in:completion:)` method
- [ ] Generate timeline entries (15-60 min intervals)
- [ ] Use `.atEnd` refresh policy
- [ ] Fetch data from `WidgetDataCache`
- [ ] Calculate Vedic time for each entry
- [ ] Add error handling

**Files to Create/Modify**:
- `kadigaram/ios/KadigaramWidget/KadigaramWidgetTimelineProvider.swift` [MODIFY or NEW]

---

### T025: Create ClockWidgetEntryView with Dynamic Time

**Priority**: P1 (Critical)  
**Estimated Time**: 3 hours  
**Dependencies**: T023, T024

**Description**:
Implement widget view using `Text(date, style: .time)` for live updates.

**Acceptance Criteria**:
- [ ] Create `ClockWidgetEntryView` SwiftUI view
- [ ] Use `Text(entry.date, style: .time)` for time display
- [ ] Display location name from entry
- [ ] Display Vedic time information from entry
- [ ] Support multiple widget families (small, medium, large)
- [ ] Apply theme colors
- [ ] Create SwiftUI Previews
- [ ] Verify time updates every minute automatically

**Files to Create/Modify**:
- `kadigaram/ios/KadigaramWidget/ClockWidgetEntryView.swift` [NEW or MODIFY]

---

### T026: Integrate Widget Reload Triggers in App

**Priority**: P1 (Critical)  
**Estimated Time**: 2 hours  
**Dependencies**: T021, T024

**Description**:
Add widget reload triggers when app data changes.

**Acceptance Criteria**:
- [ ] Call `dataCache.triggerWidgetReload()` when location changes
- [ ] Call reload when settings change
- [ ] Call reload when time zone changes
- [ ] Test widget updates after each trigger
- [ ] Verify updates happen within system budget

**Files to Create/Modify**:
- `kadigaram/ios/Kadigaram/UI/Screens/DashboardViewModel.swift` [MODIFY]
- Location manager files [MODIFY]

---

### T027: Create Orientation UI Tests

**Priority**: P2 (Important)  
**Estimated Time**: 3 hours  
**Dependencies**: T020

**Description**:
Create automated UI tests for orientation changes.

**Acceptance Criteria**:
- [ ] Test portrait to landscape rotation
- [ ] Test landscape to portrait rotation
- [ ] Verify dial scales correctly in landscape
- [ ] Verify dial returns to normal in portrait
- [ ] Test rapid rotations (5+ in sequence)
- [ ] Test on multiple device sizes
- [ ] Measure animation duration (should be ~0.3s)

**Files to Create/Modify**:
- `kadigaram/ios/KadigaramUITests/OrientationTests.swift` [NEW]

---

### T028: Create Clock Dial Visual Tests

**Priority**: P2 (Important)  
**Estimated Time**: 2 hours  
**Dependencies**: T016

**Description**:
Create UI tests to verify clock dial rendering and design.

**Acceptance Criteria**:
- [ ] Test clock dial appears on screen
- [ ] Verify dial is circular (not squashed)
- [ ] Verify hands rotate correctly
- [ ] Verify colors match expected palette
- [ ] Test at multiple sizes
- [ ] Capture screenshots for visual regression

**Files to Create/Modify**:
- `kadigaram/ios/KadigaramUITests/ClockDialVisualTests.swift` [NEW]

---

### T029: Integration Testing

**Priority**: P1 (Critical)  
**Estimated Time**: 4 hours  
**Dependencies**: All previous tasks

**Description**:
Perform end-to-end integration testing of all improvements.

**Acceptance Criteria**:
- [ ] Verify all four improvements work together
- [ ] Test theme + dial + layout + widget as a system
- [ ] Verify no performance regressions (60fps maintained)
- [ ] Test on physical device (not just simulator)
- [ ] Test on iOS 16 and iOS 17
- [ ] Verify battery impact is minimal
- [ ] Check memory usage is acceptable
- [ ] Complete manual testing checklist from quickstart.md

**Files to Create/Modify**:
- Various test files [MODIFY]

---

### T030: Documentation and Cleanup

**Priority**: P3 (Nice to have)  
**Estimated Time**: 2 hours  
**Dependencies**: T029

**Description**:
Final documentation and code cleanup.

**Acceptance Criteria**:
- [ ] Add header comments to all new files
- [ ] Remove any debug print statements
- [ ] Update README with new features (if applicable)
- [ ] Create PR description from quickstart.md
- [ ] Run SwiftLint and fix any warnings
- [ ] Verify all files follow project conventions
- [ ] Create demo video/screenshots for PR

**Files to Create/Modify**:
- All modified files [CLEANUP]
- README.md [MODIFY if exists]

---

## Task Dependencies Visualization

```
Phase 1: Theme & Foundation
├─ T001 (Theme Data Structures) ← Foundation
│  ├─ T002 (AppTheme Class)
│  │  ├─ T004 (Integrate into App)
│  │  │  ├─ T005 (Apply to Dashboard)
│  │  │  │  ├─ T006 (Apply to Header)
│  │  │  │  └─ T009 (Theme UI Tests)
│  │  ├─ T007 (Accessibility)
│  │  └─ T008 (Theme Unit Tests)
│  └─ T003 (Color Constants)
└─ T010 (Documentation)

Phase 2: Clock Dial & Layout
├─ T011 (Extract Icon Colors) ← Can run parallel to Phase 1
│  ├─ T012 (Dial Data Structures)
│  │  ├─ T013 (DialViewModel)
│  │  │  └─ T016 (ClockDialView)
│  │  ├─ T014 (ClockDialShape)
│  │  │  ├─ T015 (ClockRingShape)
│  │  │  └─ T016 (ClockDialView)
├─ T017 (Layout Configuration) ← Can run parallel
│  ├─ T018 (AdaptiveLayoutModifier)
│  │  └─ T019 (AdaptiveClockDialView)
│  │     └─ T020 (Integrate into Dashboard)
└─ T016 → T019 → T020

Phase 3: Widget & Testing
├─ T021 (WidgetDataCache) ← Foundation for widget
│  ├─ T022 (App Group Entitlement)
│  ├─ T024 (TimelineProvider)
│  │  └─ T025 (WidgetEntryView)
│  └─ T026 (Reload Triggers)
├─ T023 (Timeline Configuration)
│  └─ T024 (TimelineProvider)
├─ T027 (Orientation UI Tests) ← Requires T020
├─ T028 (Dial Visual Tests) ← Requires T016
├─ T029 (Integration Testing) ← Requires ALL
└─ T030 (Documentation) ← Final step
```

---

## Progress Tracking

### Phase 1: Theme & Foundation
- [x] T001 - Theme Data Structures
- [x] T002 - AppTheme Class
- [x] T003 - Color Constants
- [x] T004 - Integrate into App
- [x] T005 - Apply to Dashboard
- [x] T006 - Apply to Header
- [x] T007 - Accessibility Support
- [x] T008 - Theme Unit Tests
- [ ] T009 - Theme UI Tests
- [ ] T010 - Documentation

**Phase 1 Progress**: 8/10 tasks complete (80%)

### Phase 2: Clock Dial & Layout
- [x] T011 - Extract Icon Colors
- [x] T012 - Dial Data Structures
- [x] T013 - DialViewModel
- [x] T014 - ClockDialShape
- [x] T015 - ClockRingShape
- [x] T016 - ClockDialView
- [x] T017 - Layout Configuration
- [x] T018 - AdaptiveLayoutModifier
- [x] T019 - AdaptiveClockDialView
- [x] T020 - Integrate into Dashboard

**Phase 2 Progress**: 10/10 tasks complete (100%)

### Phase 3: Widget & Testing
- [ ] T021 - WidgetDataCache
- [ ] T022 - App Group Entitlement
- [ ] T023 - Timeline Configuration
- [ ] T024 - TimelineProvider
- [ ] T025 - WidgetEntryView
- [ ] T026 - Reload Triggers
- [ ] T027 - Orientation UI Tests
- [ ] T028 - Dial Visual Tests
- [ ] T029 - Integration Testing
- [ ] T030 - Documentation

**Phase 3 Progress**: 0/10 tasks complete (0%)

---

## Overall Progress

**Total**: 10/30 tasks complete (33%)

**Estimated Time Remaining**: 8-10 days

---

## Notes

- Tasks are dependency-ordered within each phase
- Some tasks in Phase 2 can start in parallel with Phase 1
- All tasks must pass before moving to next phase
- Each task includes acceptance criteria for validation
- Refer to `quickstart.md` for testing procedures
- Unit tests must achieve 85%+ coverage
- UI tests must pass on both simulator and device

---

## Quick Start

To begin implementation:

1. Start with **T001** (Theme Data Structures)
2. Work through Phase 1 tasks sequentially
3. After T004, you can start T011 (Extract Icon Colors) in parallel
4. Complete Phase 1 before heavily investing in Phase 2
5. Phase 3 requires completion of both Phase 1 and Phase 2

**Next Task**: T001 - Create Theme Configuration Data Structures

Good luck! 🚀

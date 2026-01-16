# Implementation Plan: UI and Calculation Enhancements

**Branch**: `004-ui-calculation-enhancements` | **Date**: 2026-01-14 | **Spec**: [spec.md](spec.md)
**Input**: Feature specification from `/specs/004-ui-calculation-enhancements/spec.md`

## Summary

This feature enhances both the visual design and calculation accuracy of the Kadigaram app. The Nazhigai dial will receive 3D embossed styling with improved contrast and theme-adaptive colors. A 24-hour time ring will be added around the dial, starting from sunrise. Most critically, Vedic calculations (Samvatsara, Tithi, Nakshatra, Maasa) will be corrected to match authoritative sources like Dhrik Panchang using proper astronomical calculations.

The implementation will be executed in **3 Phases**:
1. **Visual Enhancements**: 3D embossed dial styling, contrast improvements, Yamagandam color fix
2. **24-Hour Time Labels**: Add sunrise-aligned modern time reference
3. **Accurate Calculations**: Integrate Swiss Ephemeris or equivalent for precise Vedic calendar

## Technical Context

**Language/Version**: Swift 6.0  
**Primary Dependencies**: SwiftUI, existing `VedicEngine`, **NEW: Swiss Ephemeris library (or equivalent astronomical calculation library)**
**Storage**: No new storage requirements  
**Testing**: XCTest for calculation accuracy, visual testing for UI  
**Target Platform**: iOS 17+  
**Project Type**: Mobile (iOS)  
**Performance Goals**: Maintain 60fps UI rendering  
**Constraints**: Must remain native iOS, calculations must be astronomically accurate  

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- **Mobile-First Native Excellence**: PASS. Using native SwiftUI, no cross-platform deps.
- **Strict Backward Compatibility**: PASS. Visual changes don't break compatibility.
- **Comprehensive Testing**: PASS. Will add unit tests for calculation accuracy.
- **Intuitive & Aesthetic Design**: PASS. This IS the aesthetic improvement goal.

## Project Structure

### Documentation (this feature)

```text
specs/004-ui-calculation-enhancements/
├── plan.md              # This file
├── research.md          # Phase 0 output
├── data-model.md        # Phase 1 output (if needed)
└── tasks.md             # Phase 2 output
```

### Source Code

```text
kadigaram/ios/
├── KadigaramCore/
│   ├── Sources/KadigaramCore/
│   │   ├── Engines/
│   │   │   ├── VedicEngine.swift           # [MODIFY] Phase 3: Replace stub calculations
│   │   │   └── AstronomicalCalculator.swift # [NEW] Phase 3: Wrapper for ephemeris
│   │   ├── UI/Components/
│   │       └── NazhigaiWheel.swift          # [MODIFY] Phase 1 & 2: Visual updates
│   └── Tests/KadigaramCoreTests/
│       └── VedicEngineAccuracyTests.swift   # [NEW] Phase 3: Verify against known dates
└── Kadigaram/
    └── UI/
        └── Screens/
            └── DashboardView.swift          # [MODIFY] Phase 1: Background contrast
```

**Structure Decision**: Keep existing structure. Add astronomical library via SPM. Modify existing engine and wheel component.

## Execution Plan (3 Phases)

### Phase 1: Visual Enhancements
- **Goal**: Improve dial aesthetics and readability
- **Tasks**:
    1. Update `NazhigaiWheel.swift` to add 3D embossed effects (shadows, inner/outer glows, gradients)
    2. Adjust background colors in `DashboardView.swift` for better contrast
    3. Change Yamagandam segment color from red to grey with theme adaptation
    4. Test on both light/dark modes

### Phase 2: 24-Hour Time Labels
- **Goal**: Add modern time reference aligned to sunrise
- **Tasks**:
    1. Calculate 24 hourly positions around the dial starting from sunrise angle
    2. Add Text labels every hour (or every 2 hours if too crowded) around perimeter
    3. Format times in 24hr format (HH:mm)
    4. Ensure labels rotate/position correctly relative to sunrise time

### Phase 3: Accurate Vedic Calculations
- **Goal**: Replace stub calculations with astronomically accurate ones
- **Tasks**:
    1. Research and integrate Swiss Ephemeris library (or alternative)
    2. Implement accurate Tithi calculation (moon-sun longitude difference)
    3. Implement accurate Nakshatra calculation (moon ecliptic position)
    4. Verify Samvatsara calculation (likely already correct, but confirm)
    5. Implement Maasa calculation based on solar/lunar system
    6. Add unit tests comparing output to Dhrik Panchang data

## Verification Plan

### Automated Tests
- **Unit Tests**: Run `swift test` in `KadigaramCore`
    - `VedicEngineAccuracyTests`: Compare Tithi, Nakshatra, Samvatsara for known dates against Dhrik Panchang reference data

### Manual Verification
1. **Visual Testing (Phase 1)**:
    - Open app on simulator/device
    - Switch between light and dark modes
    - Verify dial has 3D appearance, good contrast, grey Yamagandam
2. **Time Labels (Phase 2)**:
    - Check that 24hr labels start at sunrise position
    - Verify times increment correctly around dial
3. **Calculation Accuracy (Phase 3)**:
    - Compare app output for today's date with Dhrik Panchang website
    - Test multiple dates (past, present, future)
    - Test different locations

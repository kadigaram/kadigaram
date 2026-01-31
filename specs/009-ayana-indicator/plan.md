# Implementation Plan: Ayana Indicator (Uttarayanam/Dakshinayanam)

**Branch**: `009-ayana-indicator` | **Date**: 2026-01-31 | **Spec**: [spec.md](file:///Users/dhilipkumars/dwork/github.com/dhilipkumars/kadigaram/kadigaram/specs/009-ayana-indicator/spec.md)  
**Input**: Feature specification from `/specs/009-ayana-indicator/spec.md`

## Summary

This implementation adds a visual arrow indicator on the clock dial center showing the Sun's annual directional movement (Ayana). The feature displays:
- **↑ arrow above Sun symbol** = Uttarayanam (northward journey, Winter Solstice ~Dec 22 → Summer Solstice ~Jun 21)
- **↓ arrow below Sun symbol** = Dakshinayanam (southward journey, Summer Solstice ~Jun 22 → Winter Solstice ~Dec 21)

**Technical Approach**: 
1. Add `Ayana` enum (`.uttarayanam`, `.dakshinayanam`) to **SixPartsLib**/Models
2. Extend `VedicDate` struct with `ayana` property
3. Implement solstice-based calculation in `AstronomicalCalculator`
4. Update `ClockDialViewModel` to include Ayana in published state
5. Add arrow indicator to `ClockDialView` center VStack

## Technical Context

**Language/Version**: Swift 6.0  
**Primary Dependencies**: SwiftUI, SixPartsLib, Foundation  
**Storage**: N/A (real-time calculation, no persistence)  
**Testing**: XCTest (SixPartsLib unit tests), Manual verification (visual UI)  
**Target Platform**: iOS 17+ (backward compatible to iOS 16)  
**Project Type**: Mobile (iOS) - existing SwiftUI app  
**Performance Goals**: < 5ms calculation time, 60 fps rendering  
**Constraints**: Calculation must use date-based ranges (no real-time solar declination), location-independent  
**Scale/Scope**: Single enum, 1 struct property, 1 calculation method, 1 UI element

## Constitution Check

*No constitution violations detected for this feature:*

- ✅ **Separation of Concerns**: Calculation logic in SixPartsLib, UI presentation in Kadigaram app (matches existing pattern)
- ✅ **Complexity**: Adds 1 new model (Ayana enum), extends existing VedicDate struct (minimal complexity)
- ✅ **Testing**: Unit tests for calculation logic, manual verification for UI visibility
- ✅ **Localization**: No text labels required at this phase (visual-only indicator as per clarification)

## Project Structure

### Documentation (this feature)

```text
specs/009-ayana-indicator/
├── spec.md              # Feature specification
├── plan.md              # This file
├── research.md          # Phase 0: Astronomical research & solstice dates
├── data-model.md        # Phase 1: Ayana enum & VedicDate extension design
└── tasks.md             # Phase 2: Task breakdown (created by /speckit.tasks)
```

### Source Code (repository root)

```text
kadigaram/ios/
├── SixPartsLib/
│   ├── Sources/SixPartsLib/
│   │   ├── Models/
│   │   │   ├── VedicDate.swift              # [MODIFY] Add ayana: Ayana property
│   │   │   └── Ayana.swift                  # [NEW] Enum: .uttarayanam, .dakshinayanam
│   │   ├── Calculators/
│   │   │   └── AstronomicalCalculator.swift # [MODIFY] Add calculateAyana(date:) method
│   │   └── SixPartsLib.swift                # [MODIFY] Include Ayana in VedicEngine output
│   └── Tests/SixPartsLibTests/
│       └── AyanaCalculationTests.swift      # [NEW] Unit tests for Ayana logic
│
└── Kadigaram/
    └── UI/Components/
        ├── ClockDialView.swift              # [MODIFY] Add arrow indicator in center VStack
        └── ClockDialViewModel.swift         # [MODIFY] Publish Ayana from VedicDate
```

**Structure Decision**: Follows existing mobile app structure with core logic in SixPartsLib package and UI presentation in Kadigaram app. New files follow established naming conventions (`Ayana.swift`, `AyanaCalculationTests.swift`).

---

## Phase 0: Research & Foundation

### Objectives
1. Research accurate solstice date ranges for Ayana transitions
2. Understand astronomical basis for Uttarayanam/Dakshinayanam
3. Identify appropriate SF Symbol for arrow indicators
4. Document decision rationale in `research.md`

### Key Research Questions
- **Solstice Dates**: Winter Solstice (Dec 21-22) and Summer Solstice (Jun 21-22) - confirm with astronomical ephemeris
- **Precession**: Should calculation account for axial precession? (Decision: Use simplified date ranges for MVP, note in assumptions)
- **Arrow Icons**: Which SF Symbols work best? (Candidates: `chevron.up`, `arrow.up`, `arrowtriangle.up.fill`)
- **Edge Cases**: What happens on solstice transition day? (Decision: Switch at midnight UTC for simplicity)

### Deliverable
**File**: `specs/009-ayana-indicator/research.md`

**Contents**:
- Astronomical background on Uttarayanam/Dakshinayanam
- Solstice date calculation method (simplified vs. precise)
- Arrow icon selection with visual mockup references
- Edge case handling decisions
- References to Vedic astronomical texts/sources

---

## Phase 1: Data Model & Contracts

### 1.1 Data Model Design

**File**: `specs/009-ayana-indicator/data-model.md`

#### New Model: `Ayana` Enum

```swift
// kadigaram/ios/SixPartsLib/Sources/SixPartsLib/Models/Ayana.swift

import Foundation

/// Represents the Sun's annual north-south directional movement
public enum Ayana: String, Equatable, Sendable, Codable {
    /// Uttarayanam: Sun's northward journey (Winter → Summer Solstice)
    /// Approximately December 22 - June 21
    case uttarayanam
    
    /// Dakshinayanam: Sun's southward journey (Summer → Winter Solstice)
    /// Approximately June 22 - December 21
    case dakshinayanam
}
```

#### Modified Model: `VedicDate`

```swift
// kadigaram/ios/SixPartsLib/Sources/SixPartsLib/Models/VedicDate.swift

public struct VedicDate: Equatable, Sendable {
    // ... existing properties ...
    public let day: Int
    
    // NEW: Ayana property
    public let ayana: Ayana  // Added for feature 009
    
    public init(
        // ... existing parameters ...
        day: Int,
        ayana: Ayana  // NEW parameter
    ) {
        // ... existing assignments ...
        self.day = day
        self.ayana = ayana  // NEW assignment
    }
}
```

#### Calculation Method: `AstronomicalCalculator`

```swift
// kadigaram/ios/SixPartsLib/Sources/SixPartsLib/Calculators/AstronomicalCalculator.swift

// MARK: - Ayana Calculation (Feature 009)

/// Calculate current Ayana (Sun's directional movement) based on date
/// Uses simplified calendar-based approach with standard solstice dates
/// - Parameter date: The date to calculate Ayana for
/// - Returns: Current Ayana (Uttarayanam or Dakshinayanam)
public func calculateAyana(for date: Date) -> Ayana {
    let calendar = Calendar.current
    let components = calendar.dateComponents([.month, .day], from: date)
    
    guard let month = components.month, let day = components.day else {
        // Fallback: assume Uttarayanam (safer default for most of year)
        return .uttarayanam
    }
    
    // Winter Solstice: December 22 marks transition to Uttarayanam
    // Summer Solstice: June 22 marks transition to Dakshinayanam
    
    // Uttarayanam: Dec 22 - Jun 21
    // Dakshinayanam: Jun 22 - Dec 21
    
    if month >= 6 && month <= 12 {
        // June-December: Check if before or after Jun 22
        if month == 6 && day < 22 {
            return .uttarayanam  // Still in Uttarayanam (Jun 1-21)
        } else if month == 12 && day >= 22 {
            return .uttarayanam  // Transitioned to Uttarayanam (Dec 22-31)
        } else {
            return .dakshinayanam  // Jun 22 - Dec 21
        }
    } else {
        // January-May: Always Uttarayanam
        return .uttarayanam
    }
}
```

### 1.2 API Contracts

**File**: `specs/009-ayana-indicator/contracts/ayana-calculation.md`

#### Contract: `AstronomicalCalculator.calculateAyana(for:)`

**Input**: 
- `date: Date` - Any valid Date object

**Output**:
- `Ayana` - Either `.uttarayanam` or `.dakshinayanam`

**Behavior**:
- Returns `.uttarayanam` for dates from Dec 22 to Jun 21
- Returns `.dakshinayanam` for dates from Jun 22 to Dec 21
- Solstice transition happens at midnight (start of day)
- Falls back to `.uttarayanam` if date components cannot be extracted

**Test Cases**:
| Date | Expected Ayana | Reason |
|------|---------------|---------|
| Jan 15, 2026 | `.uttarayanam` | Mid-winter (northward phase) |
| Jun 21, 2026 | `.uttarayanam` | Last day before transition |
| Jun 22, 2026 | `.dakshinayanam` | Summer solstice transition |
| Aug 31, 2026 | `.dakshinayanam` | Mid-summer (southward phase) |
| Dec 21, 2026 | `.dakshinayanam` | Last day before transition |
| Dec 22, 2026 | `.uttarayanam` | Winter solstice transition |

### 1.3 Quickstart Guide

**File**: `specs/009-ayana-indicator/quickstart.md`

#### For Developers: Adding Ayana to UI

```swift
// 1. Get Ayana from VedicDate
if let vedicDate = viewModel.vedicDate {
    let currentAyana = vedicDate.ayana
    
    // 2. Display appropriate arrow
    let arrowSymbol = currentAyana == .uttarayanam ? "arrow.up" : "arrow.down"
    
    Image(systemName: arrowSymbol)
        .foregroundColor(.gold)
        .font(.system(size: 16))
}
```

#### For Testers: Manual Verification

**Test 1: Visual Arrow Indicator**
1. Open Kadigaram app
2. Navigate to clock dial view
3. Observe center of clock (above/below Sun symbol)
4. Verify arrow present and correctly oriented based on current date:
   - Dec 22 - Jun 21: ↑ arrow above Sun
   - Jun 22 - Dec 21: ↓ arrow below Sun

**Test 2: Solstice Transition** (requires date simulation)
1. Change device date to June 21, 2026
2. Open app → verify ↑ arrow (Uttarayanam)
3. Change device date to June 22, 2026
4. Open app → verify ↓ arrow (Dakshinayanam)
5. Repeat for Dec 21-22 transition

---

## Phase 2: Implementation Tasks

### Task Breakdown (High-Level)

**T001**: Create Ayana enum model  
**T002**: Extend VedicDate struct with ayana property  
**T003**: Implement calculateAyana() in AstronomicalCalculator  
**T004**: Update VedicEngine to include Ayana in calculations  
**T005**: Write unit tests for Ayana calculation logic  
**T006**: Update ClockDialViewModel to publish Ayana  
**T007**: Add arrow indicator UI to ClockDialView  
**T008**: Verify UI visibility in light/dark modes  
**T009**: Manual testing on solstice dates

*Detailed task breakdown will be generated by `/speckit.tasks` command*

---

## Verification Plan

### Automated Tests

#### Unit Tests: Ayana Calculation Logic

**File**: `kadigaram/ios/SixPartsLib/Tests/SixPartsLibTests/AyanaCalculationTests.swift`

**Test Coverage**:
- `testUttarayanamMidWinter()` - Verify Jan 15 returns `.uttarayanam`
- `testUttarayanamBeforeSolstice()` - Verify Jun 21 returns `.uttarayanam`
- `testDakshinayanamTransition()` - Verify Jun 22 returns `.dakshinayanam`
- `testDakshinayanamMidSummer()` - Verify Aug 31 returns `.dakshinayanam`
- `testDakshinayanamBeforeSolstice()` - Verify Dec 21 returns `.dakshinayanam`
- `testUttarayanamTransition()` - Verify Dec 22 returns `.uttarayanam`
- `testEdgeCaseSpring()` - Verify Mar 20 (equinox) returns `.uttarayanam`
- `testEdgeCaseAutumn()` - Verify Sep 22 (equinox) returns `.dakshinayanam`

**Run Command** (from `kadigaram/ios/`):
```bash
xcodebuild test \
  -scheme SixPartsLib \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro' \
  -only-testing:SixPartsLibTests/AyanaCalculationTests
```

**Success Criteria**: All 8 tests pass with 100% coverage of `calculateAyana()` method

---

### Manual Tests

#### Manual Test 1: Visual Indicator Presence

**Objective**: Verify arrow indicator is visible on clock dial

**Prerequisites**: 
- App installed on iOS device or simulator
- Current date is known (check which Ayana period)

**Steps**:
1. Launch Kadigaram app
2. Navigate to main dashboard (clock dial view)
3. Observe the center of the clock dial where the Sun symbol (`sun.max.fill`) is displayed
4. Look above or below the Sun symbol for a small arrow indicator

**Expected Result**:
- If current date is Dec 22 - Jun 21: **↑ arrow visible above Sun symbol**
- If current date is Jun 22 - Dec 21: **↓ arrow visible below Sun symbol**
- Arrow size is approximately 20-30% of Sun symbol height
- Arrow color matches theme (gold/bronze for light mode, visible in dark mode)

**Pass Criteria**: Arrow is clearly visible and correctly positioned

---

#### Manual Test 2: Dark Mode Visibility

**Objective**: Verify arrow indicator is visible in dark mode

**Steps**:
1. Open iOS Settings → Display & Brightness → Dark
2. Launch Kadigaram app
3. Observe arrow indicator on clock dial

**Expected Result**:
- Arrow is clearly visible against dark background
- Color contrast is sufficient (minimum WCAG 2.1 AA ratio)
- Arrow does not blend into background or Sun symbol

**Pass Criteria**: Arrow is easily distinguishable in dark mode

---

#### Manual Test 3: Solstice Transition Verification

**Objective**: Verify arrow changes direction on solstice dates

**Prerequisites**: 
- Ability to change device date (Settings → General → Date & Time → Set Manually)

**Steps**:
1. Set device date to **June 21, 2026** (11:59 PM)
2. Open Kadigaram app
3. Note arrow direction (should be ↑)
4. Change device date to **June 22, 2026** (12:01 AM)
5. Force-close and reopen app
6. Note arrow direction (should be ↓)
7. Repeat for **Dec 21-22, 2026** transition

**Expected Result**:
- Jun 21: ↑ arrow (Uttarayanam)
- Jun 22: ↓ arrow (Dakshinayanam)
- Dec 21: ↓ arrow (Dakshinayanam)
- Dec 22: ↑ arrow (Uttarayanam)

**Pass Criteria**: Arrow direction changes correctly at both solstice transitions

---

#### Manual Test 4: Widget View Consistency

**Objective**: Verify arrow indicator appears in widget views (if applicable)

**Steps**:
1. Add Kadigaram widget to home screen (if widget exists)
2. Observe whether arrow indicator is shown in widget
3. Compare widget arrow direction with main app

**Expected Result**:
- If widget shows Sun symbol, arrow should also be present
- Arrow direction matches main app
- Rendering is consistent across views

**Pass Criteria**: Widget shows same Ayana indicator as main app (or N/A if no widget with Sun symbol)

---

### Build Verification

**Command** (from `kadigaram/ios/`):
```bash
xcodebuild build \
  -scheme kadigaram \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro' \
  -skipPackagePluginValidation
```

**Success Criteria**: Build succeeds with no errors or warnings related to Ayana feature

---

### Performance Verification

**Objective**: Ensure Ayana calculation adds negligible performance overhead

**Method**: Measure `calculateAyana()` execution time in unit tests

**Test Code** (add to `AyanaCalculationTests.swift`):
```swift
func testAyanaCalculationPerformance() {
    let calculator = AstronomicalCalculator()
    let testDate = Date()
    
    measure {
        for _ in 0..<1000 {
            _ = calculator.calculateAyana(for: testDate)
        }
    }
}
```

**Run Command**:
```bash
xcodebuild test \
  -scheme SixPartsLib \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro' \
  -only-testing:SixPartsLibTests/AyanaCalculationTests/testAyanaCalculationPerformance
```

**Success Criteria**: Average time < 0.005 ms per calculation (5 microseconds)

---

## Risk Assessment

### Low Risk
- ✅ Calculation logic is simple (date-based, no complex astronomy)
- ✅ UI change is minimal (single arrow indicator)
- ✅ No user data or settings involved
- ✅ Feature is purely additive (no breaking changes)

### Medium Risk
- ⚠️ **Solstice date accuracy**: Using simplified dates (Dec 22, Jun 22) may be off by ±1 day in some years
  - **Mitigation**: Document assumption in spec, consider precise calculation in future enhancement
- ⚠️ **Visual clutter**: Adding arrow may crowd center UI
  - **Mitigation**: Size arrow at 20-30% of Sun symbol, test multiple sizes during implementation

### High Risk
- ❌ None identified

---

## Dependencies

### Internal
- **SixPartsLib**: Core calculation engine (existing)
- **VedicDate**: Model struct (existing, will be extended)
- **AstronomicalCalculator**: Astronomical calculations (existing, will add method)
- **ClockDialView**: Main UI component (existing, will add arrow)

### External
- **SwiftUI**: UI framework (already in use)
- **SF Symbols**: Arrow icons (`arrow.up`, `arrow.down` or `chevron.up/down`)

---

## Rollout Plan

### Phase 0: Research & Design
- **Duration**: 1-2 hours
- **Deliverable**: `research.md`, `data-model.md`, `contracts/`, `quickstart.md`
- **Blocker**: Need to confirm SF Symbol choice

### Phase 1: Core Implementation
- **Duration**: 2-3 hours
- **Tasks**: T001-T005 (model, calculation, tests)
- **Blocker**: None (can proceed independently)

### Phase 2: UI Integration
- **Duration**: 1-2 hours
- **Tasks**: T006-T007 (ViewModel, View updates)
- **Blocker**: Depends on Phase 1 completion

### Phase 3: Verification
- **Duration**: 1 hour
- **Tasks**: T008-T009 (manual testing, theme verification)
- **Blocker**: Depends on Phase 2 completion

**Total Estimated Effort**: 5-8 hours

---

## Success Metrics

- [ ] All unit tests pass (8/8 tests)
- [ ] Build succeeds without errors
- [ ] Arrow indicator visible in both light and dark modes
- [ ] Arrow changes direction on solstice dates (manual test)
- [ ] Performance: `calculateAyana()` executes in < 5ms
- [ ] Code review approved
- [ ] No regressions in existing clock dial functionality

---

## Next Steps

1. **Run `/speckit.tasks`** to generate detailed task breakdown in `tasks.md`
2. **Execute Phase 0**: Research solstice dates and SF Symbol selection
3. **Review & Approve**: Get user confirmation on plan before implementation
4. **Implement**: Follow task sequence T001 → T009
5. **Verify**: Run automated tests + manual verification checklist
6. **Merge**: Create PR from `009-ayana-indicator` branch

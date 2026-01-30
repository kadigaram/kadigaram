# Implementation Plan: Moon Phase Arrow and Nakshatra Display

**Branch**: `008-moon-nakshatra-ui` | **Date**: 2026-01-29 | **Spec**: [spec.md](file:///Users/dhilipkumars/dwork/github.com/dhilipkumars/kadigaram/kadigaram/specs/008-moon-nakshatra-ui/spec.md)
**Input**: Feature specification from `/specs/008-moon-nakshatra-ui/spec.md`

## Summary

Add two UI enhancements to the DualDateHeader component:
1. **Waxing/Waning Arrow**: Small up (▲) or down (▼) arrow next to moon phase icon based on Paksha (Shukla = waxing = up, Krishna = waning = down)
2. **Nakshatra Label**: Display the current Nakshatra name below the existing date row, localized in Tamil and English

Both features use existing data from VedicDate (paksha and nakshatra properties) - no new calculations needed.

## Technical Context

**Language/Version**: Swift 6.0  
**Primary Dependencies**: SwiftUI, KadigaramCore, SixPartsLib  
**Storage**: N/A (display only, uses existing VedicDate model)  
**Testing**: XCTest (unit tests), manual visual verification  
**Target Platform**: iOS 17+ (with N-1 backward compatibility to iOS 16)  
**Project Type**: Mobile (iOS app)  
**Performance Goals**: 60fps UI rendering, no additional calculations  
**Constraints**: Minimal battery impact (display-only change)  
**Scale/Scope**: 2 UI components, 2 files to modify

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Principle | Status | Notes |
|-----------|--------|-------|
| I. Mobile-First Native Excellence | ✅ PASS | Using native SwiftUI, SF Symbols for arrows |
| II. Strict Backward Compatibility | ✅ PASS | SF Symbols chevron.up/down available iOS 14+ |
| III. Comprehensive Testing Strategy | ✅ PASS | Unit tests for arrow logic, visual verification |
| IV. Intuitive & Aesthetic Design | ✅ PASS | Small subtle arrow, consistent theming |
| V. Industry Best Practices | ✅ PASS | SOLID principles, modular components |

## Project Structure

### Documentation (this feature)

```text
specs/008-moon-nakshatra-ui/
├── plan.md              # This file
├── research.md          # Phase 0 output (minimal - no unknowns)
├── data-model.md        # Phase 1 output
├── checklists/          # Quality checklists
└── tasks.md             # Phase 2 output
```

### Source Code (repository root)

```text
kadigaram/ios/
├── Kadigaram/
│   └── UI/Components/
│       └── DualDateHeader.swift       # MODIFY - add arrow and Nakshatra row
├── KadigaramCore/
│   ├── Sources/KadigaramCore/UI/Components/
│   │   └── MoonPhaseView.swift        # MODIFY - add arrow indicator
│   └── Tests/KadigaramCoreTests/      # ADD - unit tests for arrow logic
└── SixPartsLib/                        # NO CHANGES - data already exists
```

**Structure Decision**: Mobile app structure with modifications to existing UI components. No new files needed except tests.

---

## Proposed Changes

### Component 1: Moon Phase View with Arrow

#### [MODIFY] [MoonPhaseView.swift](file:///Users/dhilipkumars/dwork/github.com/dhilipkumars/kadigaram/kadigaram/kadigaram/ios/KadigaramCore/Sources/KadigaramCore/UI/Components/MoonPhaseView.swift)

- Add optional `showPakshaArrow: Bool = true` parameter
- Wrap existing moon icon in HStack
- Add chevron.up (▲) for Shukla Paksha (waxing)
- Add chevron.down (▼) for Krishna Paksha (waning)
- Use `.caption2` font for small arrow
- Match foreground color styling

```swift
// Before
Image(systemName: moonSymbolName)
    .font(.title3)

// After
HStack(spacing: 2) {
    Image(systemName: moonSymbolName)
        .font(.title3)
    if showPakshaArrow {
        Image(systemName: paksha == .shukla ? "chevron.up" : "chevron.down")
            .font(.caption2)
    }
}
```

---

### Component 2: Dual Date Header with Nakshatra

#### [MODIFY] [DualDateHeader.swift](file:///Users/dhilipkumars/dwork/github.com/dhilipkumars/kadigaram/kadigaram/kadigaram/ios/Kadigaram/UI/Components/DualDateHeader.swift)

- Add Nakshatra label in new row below existing HStack
- Use `vedicDate.nakshatra` which is already a localization key (e.g., "nakshatra_ashwini")
- Pass through `bhashaEngine.localizedString()` for Tamil/English translation
- Apply same theme styling as Tithi text

```swift
// After existing HStack, add:
Text(bhashaEngine.localizedString(vedicDate.nakshatra))
    .font(.subheadline)
    .foregroundColor(theme.secondaryForegroundColor)
```

---

## Verification Plan

### Automated Tests

#### Unit Test: Arrow Direction Logic

**File**: `kadigaram/ios/KadigaramCore/Tests/KadigaramCoreTests/MoonPhaseViewTests.swift`

**What to test**:
- Given Shukla Paksha, arrow should be "chevron.up"
- Given Krishna Paksha, arrow should be "chevron.down"

**Command to run**:
```bash
cd kadigaram/ios && xcodebuild test -scheme KadigaramCore -destination 'platform=iOS Simulator,name=iPhone 16,OS=latest' -only-testing:KadigaramCoreTests/MoonPhaseViewTests
```

---

### Manual Verification

#### Test 1: Visual Arrow Verification

**Steps**:
1. Build and run app on simulator
2. Navigate to Dashboard (main screen)
3. Observe the moon phase icon in the header

**Expected**:
- See small arrow next to moon icon
- Arrow points UP if current lunar phase is Shukla Paksha (waxing, new moon → full moon)
- Arrow points DOWN if current lunar phase is Krishna Paksha (waning, full moon → new moon)
- Arrow uses same color as moon icon

**How to check current Paksha**: Run app and check if tithi number is 1-15 (Shukla) or 16-30 (Krishna), or verify visually that moon is waxing/waning.

#### Test 2: Nakshatra Label Display

**Steps**:
1. Build and run app on simulator
2. Navigate to Dashboard (main screen)
3. Observe the header area

**Expected**:
- Nakshatra name appears below the date row (moon phase, year, month, tithi)
- Text is readable and properly styled

#### Test 3: Tamil Localization

**Steps**:
1. On simulator: Settings → General → Language → Add Tamil
2. Switch primary language to Tamil
3. Relaunch app

**Expected**:
- Nakshatra label displays in Tamil script (e.g., "அசுவினி" instead of "Ashwini")

---

## Complexity Tracking

No violations. All changes comply with Constitution principles.

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| (none) | | |

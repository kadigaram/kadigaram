# Implementation Plan: Accurate Tamil Date Calculation

**Branch**: `005-accurate-tamil-date` | **Date**: 2026-01-19 | **Spec**: [spec.md](spec.md)  
**Input**: Feature specification from `/specs/005-accurate-tamil-date/spec.md`

## Summary

This feature implements astronomically accurate Tamil calendar date calculation using Sankranti-based month transitions (Lahiri Ayanamsa), updates the app icon with a culturally appropriate design, and restructures the codebase by extracting all Panchangam/Kadigaram calculation logic into a separate testable library called "SixPartsLib".

**Technical Approach**:
- Extend `AstronomicalCalculator` to compute sidereal sun longitude (tropical + Lahiri Ayanamsa offset ~24°)
- Implement inverse search algorithm to find exact Sankranti timestamp within 32-day window
- Apply sunset rule (Vakya/Thirukanitha) to determine Tamil day 1
- Create new Swift package `SixPartsLib` containing all calculation logic without UI dependencies
- Update iOS asset catalog with provided icon in all required sizes

## Technical Context

**Language/Version**: Swift 6.0 (iOS 17+, backward compatible to iOS 16)  
**Primary Dependencies**: 
- `Solar` library (existing, for sunrise/sunset)
- Swift Package Manager for SixPartsLib module
- Foundation, CoreLocation (existing)

**Storage**: N/A (calculations are real-time, no persistence)  
**Testing**: XCTest for unit tests in SixPartsLib  
**Target Platform**: iOS 17+ (with iOS 16 fallback support per constitution)  
**Project Type**: Mobile (iOS native)  
**Performance Goals**: Tamil date calculation completes in <50ms on device  
**Constraints**: 
- Sankranti timestamp accuracy: ±1 minute
- Offline-capable (no network dependencies)
- Battery-efficient (minimize ephemeris calculations)

**Scale/Scope**: 
- New library module: ~500-800 LOC
- Modified files: 5-8 files
- New icon assets: 10+ size variants

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

✅ **I. Mobile-First Native Excellence**
- Using Swift + SwiftUI (native frameworks)
- No cross-platform abstractions
- SixPartsLib is pure Swift, optimized for iOS

✅ **II. Strict Backward Compatibility**
- Target iOS 17+, support iOS 16
- No new OS-specific APIs required (using Foundation/CoreLocation only)
-Tests will run on both iOS 17 and iOS 16 simulators

✅ **III. Comprehensive Testing Strategy**
- SixPartsLib will have unit tests for all calculation methods
- Test data from Dhrik Panchang for 10+ reference dates
- Manual verification against traditional Panchangam

✅ **IV. Intuitive & Aesthetic Design**
- New app icon is visually polished and culturally authentic
- No UI changes beyond icon (calculation accuracy is invisible to UX)

✅ **V. Industry Best Practices**
- SOLID principles: SixPartsLib follows Single Responsibility
- Clean separation of concerns (logic vs. UI)
- Modular architecture for testability

**Gate Status**: ✅ PASSED — No constitution violations

## Project Structure

### Documentation (this feature)

```text
specs/005-accurate-tamil-date/
├── spec.md              # Feature specification (complete)
├── plan.md              # This file
├── research.md          # Phase 0 output (astronomy algorithms, Ayanamsa)
├── data-model.md        # Phase 1 output (TamilDate, SankrantiInfo structures)
├── quickstart.md        # Phase 1 output (how to use SixPartsLib API)
├── contracts/           # Phase 1 output (Swift API signatures)
└── tasks.md             # Phase 2 output (/speckit.tasks - NOT created yet)
```

### Source Code (repository root)

```text
kadigaram/
├── ios/
│   ├── Kadigaram/               # Main iOS app
│   │   ├── Assets.xcassets/     # [MODIFY] Add new AppIcon asset
│   │   └── ...
│   │
│   ├── KadigaramCore/           # [MODIFY] Existing shared code
│   │   ├── Sources/KadigaramCore/
│   │   │   ├── Engines/
│   │   │   │   ├── VedicEngine.swift          # [MODIFY] Import SixPartsLib
│   │   │   │   └── AstronomicalCalculator.swift # [DELETE - moved to SixPartsLib]
│   │   │   └── ...
│   │   └── Package.swift        # [MODIFY] Add SixPartsLib dependency
│   │
│   └── SixPartsLib/             # [NEW] Separate Swift package
│       ├── Package.swift        # [NEW] SPM manifest
│       ├── Sources/SixPartsLib/
│       │   ├── Models/
│       │   │   ├── TamilDate.swift           # [NEW] Data structure
│       │   │   ├── SankrantiInfo.swift       # [NEW] Data structure
│       │   │   └── VedicDate.swift           # [MOVE] from KadigaramCore
│       │   ├── Calculators/
│       │   │   ├── AstronomicalCalculator.swift  # [MOVE + EXTEND] from KadigaramCore
│       │   │   ├── TamilCalendarCalculator.swift # [NEW] Sankranti logic
│       │   │   └── VedicCalculator.swift         # [MOVE] from VedicEngine
│       │   └── SixPartsLib.swift          # [NEW] Public API exports
│       │
│       └── Tests/SixPartsLibTests/
│           ├── TamilCalendarTests.swift   # [NEW] Unit tests
│           ├── SankrantiTests.swift       # [NEW] Unit tests
│           └── ReferenceData.swift        # [NEW] Dhrik Panchang test data
│
└── specs/
    └── 005-accurate-tamil-date/
```

**Structure Decision**: Option 3 (Mobile + Library). The iOS app structure remains, with a new sibling directory `SixPartsLib/` at `kadigaram/ios/SixPartsLib/`. This allows SixPartsLib to be a standalone Swift package that can be tested independently and potentially reused across multiple iOS targets.

**Rationale**: 
- Aligns with constitution's testability requirement (separate logic from UI)
- Enables unit testing without UIKit/SwiftUI dependencies
- Follows Swift best practice of extracting calculation logic into frameworks
- Makes future Android/macOS ports easier (logic already separated)

## Complexity Tracking

> **No constitution violations — tracking SixPartsLib creation as new module**

| Decision | Justification | Simpler Alternative |
|----------|---------------|-------------------|
| Create new Swift package (SixPartsLib) | Required for constitution's testing mandate: calculation logic must be testable without UI | Keeping calculations in KadigaramCore would couple logic to SwiftUI, violating testability |
| Lahiri Ayanamsa calculation (complex astronomy) | Tamil calendar requires sidereal longitude per spec; no simpler alternative exists | Using tropical longitude would be incorrect per Panchangam tradition |

**Note**: Neither of these violates the constitution — both are necessary for correctness and testability.

---

## Phase 0: Research

**Output**: `research.md` with astronomy algorithm decisions

### Research Tasks

1. **Lahiri Ayanamsa Formula**
   - Research standard formula for Lahiri Ayanamsa offset
   - Find reference implementation (NASA JPL, IAU standards)
   - Determine precision requirements (decimal places)

2. **Sankranti Inverse Search Algorithm**
   - Research binary search vs. iterative approach for finding sun's Rasi boundary crossing
   - Determine optimal search window size and time resolution
   - Find edge cases (sun near 0°/360° boundary)

3. **Swift Package Structure Best Practices**
   - Research SPM conventions for library organization
   - Determine API surface design (public vs. internal)
   - Find examples of calculation-only Swift packages

**Deliverable**: [research.md](research.md) documenting all decisions

---

## Phase 1: Design & Contracts

**Prerequisites**: `research.md` complete

### Deliverables

1. **[data-model.md](data-model.md)**: Define structures
   - `TamilDate` (month name, day number, Sankranti timestamp, day-1 date)
   - `SankrantiInfo` (Rasi degree, timestamp, sunset time, is-day-one flag)
   - Updated `VedicDate` structure (if needed)

2. **[contracts/](contracts/)**: Swift API signatures
   - `TamilCalendarCalculator.swift` public methods
   - `AstronomicalCalculator.swift` extended methods  
   - `SixPartsLib` module exports

3. **[quickstart.md](quickstart.md)**: Usage examples
   - How to import SixPartsLib in main app
   - Sample code for calculating Tamil date
   - Running unit tests

4. **Agent Context Update**:
   - Run `.specify/scripts/bash/update-agent-context.sh gemini`
   - Add SixPartsLib to technology stack

---

## Next Steps

After this plan is approved:

1. **Phase 0**: Create `research.md` (astronomy formulas, Ayanamsa references)
2. **Phase 1**: Create `data-model.md`, `contracts/`, `quickstart.md`
3. **Phase 1**: Update agent context with new technology
4. **Phase 2**: Run `/speckit.tasks` to generate actionable task list
5. **Implementation**: Follow tasks.md to build SixPartsLib and integrate

**Ready for**: Research phase (Phase 0)

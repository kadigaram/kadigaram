# Implementation Plan: Accurate Vedic Time & Enhanced UI

**Feature**: 002-accurate-vedic-time  
**Status**: Ready for Implementation  
**Created**: 2026-01-14

## Overview

This plan outlines the technical approach for implementing accurate astronomical calculations in Kadigaram, replacing mock sunrise/sunset times with precise location-based calculations, adding real-time position indicators to the UI, and ensuring accurate Vedic calendar components (Samvatsara, Tithi, Nakshatra, Paksham).

## Technology Stack

### Existing Technologies (from spec 001)
- **iOS**: 17.0+ (Swift 6.0)
- **Framework**: SwiftUI for UI
- **Shared Logic**: `KadigaramCore` Swift Package
- **Location**: CoreLocation + manual fallback
- **Testing**: XCTest for unit tests

### New Dependencies
- **Astronomical Library**: **Solar** (Swift micro-library, Naval Observatory algorithm)
  - **Chosen over SwissEph** (complex licensing, C interop overhead, overkill for our needs)
  - **Chosen over SunKit** (less maintained, limited functionality)
  - SPM-compatible, lightweight (~200 lines), mature (7+ years)
  - https://github.com/ceeK/Solar
- **Vedic Calculations**: Custom implementation in `VedicEngine`
  - No existing Swift library found; will implement from first principles
  - Reference: Surya Siddhanta astronomical text

## Technical Approach

### Phase 1: Astronomical Sunrise/Sunset (FR1)

**Goal**: Replace hardcoded 6 AM/6 PM with actual calculated times

#### Solar Library Integration
```
Dependencies:
- Solar ~> 3.0 (Swift Package Manager)

Interface:
let solar = Solar(coordinate: CLLocationCoordinate2D, timeZone: TimeZone)
let sunrise = solar?.sunrise  // Date?
let sunset = solar?.sunset    // Date?
```

#### Implementation Strategy
1. Add Solar to `KadigaramCore/Package.swift` dependencies
2. Create `AstronomicalEngine` wrapper protocol (allows future library swaps)
3. Implement Solar-based concrete class
4. Add fallback mechanism (cache last 24 hours of calculations)
5. Update `VedicEngine.calculateVedicTime` to accept `AstronomicalEngine`

#### Files Modified
- `KadigaramCore/Package.swift`
- **NEW**: `KadigaramCore/Sources/Engines/AstronomicalEngine.swift`
- `KadigaramCore/Sources/Engines/VedicEngine.swift`
- `Kadigaram/UI/Screens/DashboardViewModel.swift`

---

### Phase 2: Vedic Calendar Calculations (FR4)

**Goal**: Calculate accurate Samvatsara, Tithi, Nakshatra, and Paksham

#### Astronomical Formulas (Surya Siddhanta)

**Tithi Calculation**:
```
Tithi = (Moon Longitude - Sun Longitude) / 12°
- 30 Tithis per lunar month
- Each Tithi = 12° separation
- Progress = (current separation mod 12°) / 12°
```

**Nakshatra Calculation**:
```
Nakshatra = (Moon Longitude) / 13.333°
- 27 Nakshatras (lunar mansions)
- Each Nakshatra = 13.333° of ecliptic
- Progress = (current moon long mod 13.333°) / 13.333°
```

**Paksham**:
```
If Tithi 1-15: Shukla Paksha (waxing)
If Tithi 16-30: Krishna Paksha (waning)
Illumination % = |50 - (Tithi * 100/30)| * 2
```

**Samvatsara** ( 60-year cycle):
```swift
Base year: 1987 = Krodhi year 1
Current index = ((current year - 1987) mod 60) + 1
```

#### Lunar/Solar Position Source
**Option A**: Use Solar library's moon phase calculation (basic illumination %)
**Option B**: Integrate lightweight lunar library (e.g., `suncalc-swift` for moon position)
**Decision**: Start with **Option B** - `suncalc-swift` provides both sun and moon positions

#### Implementation Strategy
1. Add `suncalcswift/suncalc` package to dependencies
2. Create `LunarCalculations` struct in `VedicEngine`
3. Implement Tithi/Nakshatra/Paksham algorithms
4. Create lookup table for Samvatsara names (60-year cycle)
5. Update `VedicDate` model with new fields (done in spec)
6. Add unit tests for known Panchang dates

#### Files Modified
- `KadigaramCore/Package.swift` (add suncalc dependency)
- `KadigaramCore/Sources/Engines/VedicEngine.swift`
- **NEW**: `KadigaramCore/Sources/Models/SamvatsaraTable.swift` (60 names + localizations)
- `KadigaramCore/Sources/Models/VedicDate.swift` (already updated)
- **NEW**: `KadigaramTests/VedicCalendarTests.swift`

---

### Phase 3: Real-Time Position Indicator (FR2)

**Goal**: Animated sphere on golden ring showing current Nazhigai position

#### UI Component Design
```
NazhigaiWheel (enhanced):
- Calculate indicator angle: (nazhigai + vinazhigai/60) * 6° 
  (360° / 60 Nazhigai = 6°/Nazhigai)
- Render sphere with:
  - Radial gradient (white → gold)
  - Drop shadow for depth
  - Position using rotationEffect + offset
- Animate with .animation(.linear(duration: 1))
```

#### Implementation Strategy
1. Add `progressIndicatorAngle` computed property to `VedicTime`
2. Update `NazhigaiWheel` to render floating sphere
3. Use `GeometryReader` to calculate absolute position on ring
4. Apply smooth animation (easeInOut for natural motion)
5. Ensure 60fps by minimizing redraws (use `equatable` modifiers)

#### Files Modified
- `KadigaramCore/Sources/Models/VedicTime.swift`
- `KadigaramCore/Sources/UI/Components/NazhigaiWheel.swift`

---

### Phase 4: Paksham Moon Phase Icons (FR3)

**Goal**: Visual moon representation next to Paksham text

#### Icon Design (SVG-based Shapes)
```
8 Moon Phases:
1. New Moon: Circle fill(.black)
2. Waxing Crescent: Arc (right 25%)
3. First Quarter: Half circle (right 50%)
4. Waxing Gibbous: Arc (right 75%)
5. Full Moon: Circle fill(.white)
6  Waning Gibbous: Arc (left 75%)
7. Last Quarter: Half circle (left 50%)
8. Waning Crescent: Arc (left 25%)

Render with SwiftUI Paths
```

#### Implementation Strategy
1. Create `MoonPhaseView` component
2. Use `Path` drawing with arc calculations
3. Accept `illuminationPercentage` (0.0-1.0) and `paksha` as inputs
4. Position next to Paksham text in `DualDateHeader`
5. Add accessibility label (e.g., "Waxing Gibbous Moon")

#### Files Modified
- **NEW**: `Kadigaram/UI/Components/MoonPhaseView.swift`
- `Kadigaram/UI/Components/DualDateHeader.swift`

---

### Phase 5: Widget Timeline Updates (FR2, Widget)

**Goal**: Pre-calculate 24 hours of timeline entries for widget

#### WidgetKit Timeline Strategy
```swift
Timeline entries every 5 minutes:
- Calculate nazhigai for each entry
- Include position indicator angle
- Use placeholder for far future (reduces computation)
```

#### Implementation Strategy
1. Update `NazhigaiProvider` to generate 24-hour timeline
2. Calculate 288 entries (24 hrs * 60 min / 5 min intervals)
3. Use `AstronomicalEngine` to get sunrise/sunset for tomorrow
4. Cache entries to reduce widget refresh overhead

#### Files Modified
- `KadigaramWidget/NazhigaiProvider.swift`

---

## Proposed Changes

### KadigaramCore (Shared Logic)

#### [NEW] AstronomicalEngine.swift
- Protocol: `AstronomicalEngineProvider`
- Concrete: `SolarAstronomicalEngine` (wraps Solar library)
- Methods: `sunrise(for:at:)`, `sunset(for:at:)`
- Caching: Last 3 days of calculations

#### [MODIFY] VedicEngine.swift
- Add dependency on `AstronomicalEngine`
- Implement Tithi calculation (moon-sun longitude difference)
- Implement Nakshatra calculation (moon position in 27 divisions)
- Implement Paksham calculation (from Tithi number)
- Calculate illumination percentage
- Update `calculateVedicDate` to use astronomical data

#### [NEW] SamvatsaraTable.swift
- Static lookup: 60-year cycle names
- Base year: 1987 (Krodhi)
- Methods: `name(for: year)`, `index(for: year)`

#### [MODIFY] VedicTime.swift
- Add computed property: `progressIndicatorAngle: Double`

#### [MODIFY] Package.swift
- Add dependency: `Solar` (~> 3.0)
- Add dependency: `suncalc-swift` (for moon position)

---

### Kadigaram App (iOS UI)

#### [MODIFY] NazhigaiWheel.swift
- Render position indicator sphere
  - Size: 20pt diameter
  - Position: Along ring perimeter at `progressIndicatorAngle`
  - Style: Radial gradient (inner white, outer gold), shadow
- Animate rotation smoothly (1-second linear animation)

#### [NEW] MoonPhaseView.swift
- Input: `illuminationPercentage`, `paksha`
- Output: SwiftUI `View` with Path-based moon drawing
- Size: 24x24 pt
- Accessibility: VoiceOver label

#### [MODIFY] DualDateHeader.swift
- Add `MoonPhaseView` next to Paksham text
- Layout: HStack [Text("Krishna Paksha"), MoonPhaseView]

#### [MODIFY] DashboardViewModel.swift
- Initialize `AstronomicalEngine` on app launch
- Pass to `VedicEngine` on `updateTime()`

---

### KadigaramWidget (Widget Extension)

#### [MODIFY] NazhigaiProvider.swift
- Generate 24-hour timeline (288 entries at 5-min intervals)
- Use `AstronomicalEngine` for tomorrow's sunrise/sunset
- Pre-calculate position indicator angles

---

### Localization (Strings)

#### [NEW] Samvatsara Names
Add 60-year cycle names to `.lproj/Localizable.strings`:
- `samvatsara_prabhava`, `samvatsara_vibhava`, ..., `samvatsara_akshaya`
- Translations: en, sa, ta, te, kn, ml

#### [NEW] Tithi Names
- `tithi_pratipada`, `tithi_dwitiya`, ..., `tithi_chaturdashi`, `tithi_amavasya`, `tithi_purnima`

#### [NEW] Nakshatra Names
- `nakshatra_ashwini`, `nakshatra_bharani`, ..., `nakshatra_revati`

---

### Tests

#### [NEW] VedicCalendarTests.swift
**Test Cases**:
1. **Tithi Calculation**: Given known sun/moon positions, verify Tithi number and progress
2. **Nakshatra Calculation**: Verify correct Nakshatra for known lunar positions
3. **Paksham Detection**: Confirm Krishna/Shukla based on Tithi
4. **Samvatsara Lookup**: Verify 2026 → Krodhi, 2027 → Vishvavasu
5. **Moon Illumination**: Check illumination % matches reference almanac

#### [MODIFY] VedicEngineTests.swift
- Update sunrise/sunset tests to use `AstronomicalEngine` mock
- Verify Nazhigai accuracy with real sunrise times

---

## Verification Plan

### Automated Tests
1. Run unit tests for Vedic calendar calculations
2. Verify astronomical engine returns sunrise within ±2 minutes of NOAA calculator
3. Widget timeline generation completes in <1 second

### Manual Verification
1. **Location Test**: Compare app's sunrise time with timeanddate.com for Chennai, Delhi, Mumbai
2. **Panchang Accuracy**: Cross-reference 5 random dates with drikpanchang.com
   - Samvatsara name
   - Tithi name and progress %
   - Nakshatra name
3. **UI Validation**:
   - Position indicator moves smoothly (60fps recorded video)
   - Moon phase icon matches astronomical reality (use planetarium app)
   - Widget updates every ~5 minutes on lock screen
4. **Edge Cases**:
   - Test app in polar region (Alert, Canada) → graceful fallback message
   - Offline mode → cached sunrise/sunset still works for today

### Acceptance Criteria (from spec)
- ✅ Nazhigai count matches observed sunrise time within ±2 minutes
- ✅ Sphere on golden ring updates every 1 second
- ✅ Moon phase icon correctly represents lunar illumination percentage within ±5%
- ✅ Samvatsara, Tithi, and Nakshatra match reference Panchang for 95% of test dates
- ✅ Calculations complete within 500ms on app launch
- ✅ Widget updates show current Nazhigai position within 10-minute accuracy

---

## Dependencies & Risks

### External Dependencies
- **Solar** library maintenance (last update: 2023, stable)
- **suncalc-swift** availability (alternative: manual lunar calculations)

### Risks & Mitigation
| Risk | Impact | Mitigation |
|------|--------|-----------|
| Solar library breaking change | High | Pin to specific version (~> 3.0), wrapper allows swap |
| Vedic calculation accuracy disputed | Medium | Reference multiple Panchang sources, document assumptions |
| 60fps animation drops on older devices | Low | Optimize with `drawingGroup()`, test on iPhone SE |
| Widget refresh frequency limited by iOS | Low | Accept 5-10 min updates, clearly communicate in Settings |

---

## Out of Scope

The following are explicitly NOT included in this implementation:
- Historical date calculations (pre-1900)
- Eclipse predictions
- Astrology charts (Kundali/Horoscope)
- Multiple timezone support (only current location)
- Custom Panchang rule variations

---

## Implementation Phases (Suggested)

### Phase 1 (P1): Astronomical Calculations
- Setup Solar + suncalc dependencies
- Implement `AstronomicalEngine`
- Update `VedicEngine` with real sunrise/sunset
- **Deliverable**: Nazhigai calculations use actual sunrise times

### Phase 2 (P1): Vedic Calendar
- Implement Tithi/Nakshatra/Paksham algorithms
- Create Samvatsara lookup table
- Add localization strings
- **Deliverable**: Accurate Vedic date components displayed

### Phase 3 (P2): UI Enhancements
- Add position indicator to `NazhigaiWheel`
- Create `MoonPhaseView` component
- Update `DualDateHeader`
- **Deliverable**: Visual indicators working in app

### Phase 4 (P2): Widget Support
- Update `NazhigaiProvider` timeline
- Pre-calculate 24-hour entries
- **Deliverable**: Widget shows accurate position indicator

### Phase 5 (P3): Polish & Testing
- Add unit tests
- Manual verification with reference Panchang
- Performance optimization
- **Deliverable**: 95%+ accuracy confirmed

---

## Success Metrics

Upon completion, the implementation should achieve:
- **Accuracy**: ±2 minutes for sunrise/sunset, ±5% for moon phase, 95%+ for Vedic calendar
- **Performance**: <500ms calculation time, 60fps UI animations
- **Reliability**: Offline mode works with cached data
- **User Satisfaction**: 3+ users confirm accuracy in different time zones

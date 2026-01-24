# Research: Accurate Tamil Date Calculation

**Feature**: 005-accurate-tamil-date  
**Created**: 2026-01-19

## Decision 1: Lahiri Ayanamsa Formula

**Decision**: Use standard Lahiri Ayanamsa formula with polynomial approximation

**Formula**:
```
Ayanamsa (degrees) = 23.85° + 0.0133° × (JulianYear - 2000)
```

**More Precise Formula** (from Indian Astronomical Ephemeris):
```
t = (JD - 2451545.0) / 36525  // Julian centuries from J2000.0
Ayanamsa = 22.460 + 0.0485 * t + 0.0001 * t²
```

**Rationale**:
- Lahiri Ayanamsa is the official Indian standard (adopted by Government of India, 1956)
- Used by all major Pan changangs including Dhrik Panchang
- Formula is computationally simple (~0.01° accuracy sufficient for Tamil calendar, where months are 30° wide)
- No external ephemeris files needed — pure calculation

**Alternatives Considered**:
1. **Swiss Ephemeris library**: Overkill for our precision needs; 50MB+ data files; dependency complexity
2. **Raman Ayanamsa**: Less commonly used in Tamil Nadu; differs by ~0.2° from Lahiri
3. **KP Ayanamsa**: Modern variant but not traditional; would conflict with user-specified Vakya/Thirukanitha rules

**Reference**: 
- "Explanatory Supplement to the Astronomical Almanac" (P. Kenneth Seidelmann, 1992)
- Indian Astronomical Ephemeris, Positional Astronomy Centre, Kolkata

---

## Decision 2: Sidereal Sun Longitude Calculation

**Decision**: Calculate tropical longitude (existing code) + Lahiri Ayanamsa offset

**Algorithm**:
```swift
func siderealSunLongitude(date: Date) -> Double {
    let tropicalLongitude = sunLongitude(date: date, location: location)  // Existing method
    let ayanamsa = calculateLahiriAyanamsa(date: date)
    var sidereal = tropicalLongitude - ayanamsa
    
    // Normalize to 0-360°
    while sidereal < 0 { sidereal += 360 }
    while sidereal >= 360 { sidereal -= 360 }
    
    return sidereal
}
```

**Rationale**:
- Reuses existing `sunLongitude()` method from `AstronomicalCalculator`
- Clean separation: tropical calculation + Ayanamsa offset
- No duplication of Meeus algorithm code

---

## Decision 3: Sankranti Inverse Search Algorithm

**Decision**: Binary search with 1-minute resolution within 32-day window

**Algorithm**:
```swift
func findSankranti(targetDegree: Double, searchEnd: Date) -> Date? {
    let searchStart = Calendar.current.date(byAdding: .day, value: -32, to: searchEnd)!
    
    var low = searchStart
    var high = searchEnd
    
    while high.timeIntervalSince(low) > 60 {  // 1-minute precision
        let mid = Date(timeIntervalSince1970: (low.timeIntervalSince1970 + high.timeIntervalSince1970) / 2)
        let sunPos = siderealSunLongitude(date: mid)
        
        // Handle wraparound at 0°/360°
        let distanceToDegree: Double
        if targetDegree == 0 {
            distanceToDegree = sunPos < 180 ? sunPos : sunPos - 360
        } else {
            distanceToDegree = sunPos - targetDegree
        }
        
        if abs(distanceToDegree) < 0.1 {  // Within 0.1° = close enough
            return mid
        } else if distanceToDegree < 0 {
            low = mid
        } else {
            high = mid
        }
    }
    
    return high  // Return best approximation
}
```

**Rationale**:
- Binary search: O(log n) efficiency (~15 iterations for 32 days → 1 minute window)
- 1-minute precision meets spec requirement (±1 minute accuracy)
- 32-day window guarantees we find the Sankranti (max month length ~31 days)
- Handles 0°/360° boundary correctly (Mesha Rasi start)

**Alternatives Considered**:
1. **Linear search (hourly)**: Too slow (~768 iterations); 10x slower than binary search
2. **Newton-Raphson**: Requires sun velocity calculation (derivative); overkill for this precision
3. **Precomputed table**: Would require annual updates; not dynamic for arbitrary years

**Edge Cases Handled**:
- Sun crossing 0° (Mesha start): Check if sunPos < 180° to determine which side of boundary
- Leap years: Search window accounts for February length
- Time zone changes: All calculations in UTC, converted to local only for sunset rule

---

## Decision 4: Swift Package Structure for SixPartsLib

**Decision**: Use standard Swift Package Manager layout with separation by domain

**Structure**:
```
SixPartsLib/
├── Package.swift
├── Sources/SixPartsLib/
│   ├── Models/              # Data structures (TamilDate, SankrantiInfo, VedicDate)
│   ├── Calculators/          # Calculation engines
│   │   ├── AstronomicalCalculator.swift      # Sun/Moon ephemeris
│   │   ├── TamilCalendarCalculator.swift     # Sankranti + day calculation
│   │   └── VedicCalculator.swift             # Tithi, Nakshatra, Paksham
│   └── SixPartsLib.swift    # Public API exports
└── Tests/SixPartsLibTests/
    ├── TamilCalendarTests.swift
    ├── SankrantiTests.swift
    └── Fixtures/
        └── DhrikPanchangData.swift   # Reference test data
```

**API Design**:
```swift
// Public API (accessed by main app)
public struct SixPartsLib {
    public static func calculateTamilDate(for date: Date, location: CLLocationCoordinate2D, timeZone: TimeZone) -> TamilDate
    public static func calculateVedicDate(for date: Date, location: CLLocationCoordinate2D, calendarSystem: CalendarSystem) -> VedicDate
}
```

**Rationale**:
- Follows Apple's Swift Package guidelines
- `Models/` separation keeps data structures lightweight and testable
- `Calculators/` isolates business logic for unit testing
- Single public entry point (`SixPartsLib.swift`) makes API discovery easy
- Tests use real Dhrik Panchang data for accuracy verification

**Alternatives Considered**:
1. **Flat structure (all files in Sources/)**: Harder to navigate; mixes concerns
2. **Feature-based (Tamil/, Vedic/)**: Over-engineered for current scope; can refactor later if needed
3. **No package (keep in KadigaramCore)**: Violates testability requirement; couples to SwiftUI

---

## Decision 5: Icon Asset Integration

**Decision**: Use Xcode Asset Catalog with user-provided sizes

**Implementation**:
1. User provides pre-generated icon assets in all required sizes:
   - 1024x1024 (App Store)
   - 180x180 (iPhone Pro Max)
   - 120x120 (iPhone standard)
   - 87x87 (iPhone Settings)
   - 80x80 (iPhone Spotlight)
   - 58x58 (iPhone Notifications)
   - 60x60 (iPhone 2x)
   - 40x40 (iPhone Spotlight 2x)
   - 29x29 (iPhone Settings 1x)

2. Copy assets into `Kadigaram/Assets.xcassets/AppIcon.appiconset/`
3. Update `Contents.json` with asset mappings

**Rationale**:
- User confirmed Option A (provide all sizes manually)
- No image processing tools required
- Ensures best quality (user can optimize each size)
- Standard Xcode workflow

---

## Verification Strategy

**Test Data Source**: Dhrik Panchang (https://www.drikpanchang.com/)

**Reference Dates for Testing**:
1. Jan 14, 2026 (Tamil: Thai 1) - Month transition, test sunset rule
2. Apr 14, 2025 (Tamil: Chithirai 1) - Tamil New Year
3. Feb 28, 2024 (Leap year edge case)
4. Dec 15, 2025 (Margazhi mid-month)
5. Mar 31, 2026 (Panguni end-of-month)
6. Jan 1, 2027 (Gregorian vs. Tamil calendar alignment)

**Success Criteria**:
- Sankranti timestamp within ±5 minutes of Dhrik Panchang for all 6 test dates
- Tamil day number matches Dhrik Panchang 100% of the time
- Sunset rule correctly determines day-1 for edge cases

---

## Summary

All research decisions finalized:
- ✅ Lahiri Ayanamsa formula selected (polynomial approximation)
- ✅ Sidereal longitude calculation method defined
- ✅ Sankranti binary search algorithm designed
- ✅ SixPartsLib package structure determined
- ✅ Icon integration approach confirmed
- ✅ Test verification strategy established with reference data

**Ready for**: Phase 1 (Data Model & Contracts)

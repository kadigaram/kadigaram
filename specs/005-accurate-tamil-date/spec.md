# Feature Specification: Accurate Tamil Date Calculation

**Feature ID**: 005  
**Short Name**: accurate-tamil-date  
**Status**: Draft  
**Created**: 2026-01-19

## Overview

This feature implements accurate Tamil calendar date calculation based on astronomical Sankranti (solar month transitions), updates the app icon with a culturally appropriate design, and restructures the codebase to separate Panchangam and Kadigaram logic into a dedicated, testable library called "SixPartsLib".

## User Stories

### US1: Accurate Tamil Date Display
As a user viewing the Tamil date,  
I want to see the correct Tamil month and day number calculated using astronomical Sankranti timings,  
So that the app aligns with traditional Panchangam calculations used in Tamil Nadu.

### US2: Cultural App Identity
As a user opening the app,  
I want to see a culturally relevant icon that represents Tamil time-keeping traditions,  
So that the app feels authentic and connected to Tamil heritage.

### US3: Library Modularity for Testing
As a developer maintaining the codebase,  
I want Panchangam and Kadigaram calculation logic separated into a dedicated library (SixPartsLib),  
So that I can write unit tests and verify calculations independently of the UI.

## User Scenarios & Testing

### Scenario 1: User Views Tamil Date During Month Transition
**Given**: Today is January 14, 2026 (Tamil month: Thai)  
**When**: User opens the app  
**Then**: 
- App calculates that Sun entered Makara Rasi (270°) on January 14, 2026 at a specific time
- App determines if Sankranti occurred before or after sunset for the user's location
- App displays "Thai 1" or "Thai 2" (depending on sunset rule)
- Date updates automatically if viewed across midnight during month transition

**Edge Case**: Sankranti occurs within minutes of sunset — system must accurately determine which side of sunset the transition falls on.

### Scenario 2: User Changes Location
**Given**: User is in Chennai (sunset ~6:00 PM)  
**When**: User manually sets location to London (sunset ~4:30 PM in January)  
**Then**: 
- Tamil day calculation updates based on London's sunset time
- If Sankranti was before Chennai sunset but after London sunset, day number may differ by 1

### Scenario 3: Developer Runs Tests on SixPartsLib
**Given**: Code restructured with SixPartsLib containing all calculation logic  
**When**: Developer runs unit tests  
**Then**: 
- Tests verify Sankranti calculation accuracy
- Tests verify day-1 determination rule (before/after sunset)
- Tests cover edge cases (midnight transitions, leap years, different latitudes)

## Assumptions

- **Ayanamsa System**: Use Lahiri Ayanamsa (Chitra Paksha) for sidereal longitude calculations
- **Current Year**: 2026 Gregorian = Viswavasu year in Tamil calendar (year_viswavasu localization key)
- **Sunset Definition**: Use existing `AstronomicalEngine` sunset calculation for the location
- **Month Start Rule**: Follow Vakya/Thirukanitha rule: If Sankranti occurs before sunset, that day is Day 1; otherwise next day is Day 1
- **Sun Position Precision**: Calculate sun's sidereal longitude to at least 0.01° accuracy
- **Sankranti Search Window**: Search for Sun's entry into target Rasi within 32 days before current date
- **Tamil Month Names**: Use existing localization keys (`month_chithirai`, `month_thai`, etc.)

## Functional Requirements

### FR1: Astronomical Sankranti Calculation
- **FR1.1**: System calculates sun's sidereal longitude (accounting for Lahiri Ayanamsa) for any given date/time
- **FR1.2**: System identifies current Tamil month based on which 30-degree Rasi sector the sun occupies
  - 0-30°: Chithirai (Mesha)
  - 30-60°: Vaigasi (Vrishabha)
  - ...
  - 270-300°: Thai (Makara)
  - 300-330°: Masi (Kumbha)
  - 330-360°: Panguni (Meena)
- **FR1.3**: System finds exact timestamp when sun crossed the Rasi boundary (Sankranti moment) by inverse search within 32-day window
- **FR1.4**: Sankranti timestamp accuracy must be within ±1 minute

### FR2: Tamil Day Number Calculation  
- **FR2.1**: System converts Sankranti timestamp to user's local time zone
- **FR2.2**: System retrieves sunset time for user's location on the Sankranti date
- **FR2.3**: System applies day-1 rule:
  - If Sankranti occurs before sunset: Sankranti date is Day 1
  - If Sankranti occurs after sunset: Day after Sankranti is Day 1
- **FR2.4**: System calculates current Tamil day number as: (days between Day 1 and current date) + 1
- **FR2.5**: Tamil day numbers range from 1 to maximum ~32 (depending on month length)

### FR3: App Icon Update
- **FR3.1**: System uses provided Tamil-themed icon (sun with Tamil letter க, traditional border, blue/gold color scheme) as app icon
- **FR3.2**: Icon displays in iOS home screen, App Store listing, and app switcher

### FR4: SixPartsLib Library Separation
- **FR4.1**: System creates new directory `SixPartsLib/` under project root
- **FR4.2**: System moves all Panchangam calculation logic (Vedic date, time, astronomical calculations) into SixPartsLib
- **FR4.3**: System moves all Kadigaram-specific logic (Nazhigai, wheel rendering logic if decoupled) into SixPartsLib
- **FR4.4**: SixPartsLib exposes public API for:
  - Tamil date calculation (month name, day number)
  - Vedic time calculation (Nazhigai, Vinazhigai)
  - Tithi, Nakshatra calculations
  - Astronomical helpers (sun/moon longitude, Sankranti search)
- **FR4.5**: Main app imports and consumes SixPartsLib as a Swift package or module
- **FR4.6**: SixPartsLib has no UI dependencies (SwiftUI, UIKit) — pure logic only

### FR5: Localization Integration
- **FR5.1**: System uses updated `ta.lproj/Localizable.strings` with all 60 Samvatsara names
- **FR5.2**: For current year (2026), system displays Tamil translation for `year_viswavasu`
- **FR5.3**: Tamil month names use existing `month_*` localization keys

## Success Criteria

1. **Accuracy**: Tamil date calculation matches Dhrik Panchang and other traditional Panchangam sources for at least 95% of test dates across 2025-2027
2. **Sankranti Precision**: For 10 randomly selected month transitions, calculated Sankranti time is within ±5 minutes of reference Panchangam
3. **Sunset Rule Correctness**: For edge cases where Sankranti occurs ±30 minutes of sunset, day-1 determination is correct 100% of the time
4. **Icon Visibility**: Updated app icon displays correctly on iOS devices without distortion or rendering issues
5. **Library Independence**: SixPartsLib compiles and tests successfully without importing any UI frameworks
6. **Test Coverage**: SixPartsLib has unit tests covering:
   - Sankranti calculation for all 12 months
   - Day-1 rule for before/after sunset scenarios
   - Tamil day calculation across month boundaries
   - Sidereal longitude accuracy
7. **Localization**: Tamil year name displays as "விசுவாவசு" (Viswavasu) in Tamil language mode

## Key Entities

### TamilDate (Data Structure)
- **monthName** (String): Tamil month localization key (e.g., "month_thai")
- **dayNumber** (Int): Day of Tamil month (1-32)
- **sankrantiTimestamp** (Date): Exact moment sun entered current Rasi
- **dayOneDate** (Date): Date determined as Day 1 of this Tamil month

### SankrantiInfo (Data Structure)  
- **rasiDegree** (Double): Target boundary degree (0, 30, 60, ..., 330)
- **sankrantiTime** (Date): Timestamp when sun crossed boundary
- **sunsetTime** (Date): Sunset on Sankranti date for given location
- **isDayOne** (Bool): True if Sankranti was before sunset

### SixPartsLib API (Public Interface)
```
calculateTamilDate(for date: Date, location: CLLocationCoordinate2D, timeZone: TimeZone) -> TamilDate
getSiderealSunLongitude(for date: Date) -> Double  
findSankranti(targetDegree: Double, searchRange: DateInterval) -> Date?
applySunsetRule(sankranti: Date, location: CLLocationCoordinate2D) -> Date  // Returns Day 1
```

## Out of Scope

- **Adhik Maasa (intercalary months)**: Not implemented in this phase (defer to future enhancement)
- **Paksha (fortnight) calculations**: Continue using existing Tithi-based logic
- **Nakshatra-based day calculations**: Stick with solar Sankranti only
- **Historical date conversion**: Focus on current and future dates (2020 onwards); historical accuracy not guaranteed
- **iOS widget updates**: App icon only; widget icon remains unchanged for now
- **Android version**: iOS only for this feature

## Dependencies

- **AstronomicalEngine**: Existing library for sunrise/sunset calculations
- **AstronomicalCalculator**: May need to extend to support sidereal longitude (Lahiri Ayanamsa)
- **Localization files**: Updated `ta.lproj/Localizable.strings` must be present with all year names
- **Icon Assets**: User will provide complete asset catalog with all required iOS icon sizes (1024x1024, 180x180, 120x120, etc.) — no automatic generation needed

## Notes

- Tamil date calculation algorithm provided by user is the authoritative reference for implementation
- Current simplified Gregorian→Tamil month mapping must be replaced entirely with Sankranti-based calculation
- SixPartsLib restructuring may require refactoring existing `VedicEngine`, `AstronomicalCalculator` to eliminate UI dependencies
- Icon assets will be provided in all required sizes; implementation will copy them into Xcode asset catalog

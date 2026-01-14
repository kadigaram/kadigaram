# Feature Specification: Accurate Vedic Time & Enhanced UI

**Feature Number**: 002  
**Short Name**: accurate-vedic-time  
**Status**: Draft  
**Created**: 2026-01-14  
**Last Updated**: 2026-01-14

## Overview

### Problem Statement

The current Kadigaram implementation uses mock sunrise and sunset times (hardcoded 6 AM / 6 PM), resulting in inaccurate Nazhigai calculations that don't reflect the actual solar cycle at the user's location. Additionally, the UI lacks visual feedback showing the user's current position in the daily cycle, and the Paksham (lunar phase) is not visually represented. The Vedic calendar components (year, tithi, day) are currently placeholder values and need to display accurate astronomical data.

### Solution Summary

Integrate astronomical calculations for precise sunrise/sunset times based on user location and date, animate a position indicator on the golden ring to show real-time progress through the Nazhigai cycle, add visual moon phase indicators for Paksham, and implement accurate Vedic calendar calculations for Samvatsara (year), Tithi, and day.

### Target Users

- Users who rely on accurate Vedic timekeeping for religious observances
- Astrology practitioners requiring precise planetary positions
- Anyone interested in traditional Indian solar/lunar calendar systems
- Users in different geographic locations with varying sunrise/sunset times

## User Scenarios & Testing

### Primary Scenarios

#### Scenario 1: User in Chennai checks time at sunrise

**Given**: User is in Chennai (13.08° N, 80.27° E) at 6:30 AM on January 15, 2026  
**When**: User opens the app  
**Then**: 
- Nazhigai shows "0:30" (30 minutes after actual Chennai sunrise)
- Golden ring indicator shows sphere positioned at ~3% of the circle
- App displays "Shukla Saptami" with a waxing crescent moon icon
- Samvatsara shows "Krodhi" year

#### Scenario 2: User travels from South India to North India

**Given**: User was in Chennai, now in Delhi (28.70° N, 77.10° E)  
**When**: User opens app at 7:00 AM on the same day  
**Then**:
- App recalculates sunrise for Delhi's latitude/longitude
- Nazhigai count reflects Delhi's later sunrise time
- Position indicator adjusts to show correct progress in Delhi's solar day

#### Scenario 3: User checks app during Purnima (Full Moon)

**Given**: It is Purnima (Full Moon day)  
**When**: User views the dashboard  
**Then**:
- App displays "Shukla Purnima" (Krishna/Shukla Paksha)
- Moon icon shows full moon (100% illuminated white circle)
- Tithi progress shows "100%" indicating Purnima is ending soon

### Edge Cases

- **User location unavailable**: App should use manual coordinates from Settings
- **Polar regions**: Handle extreme latitudes where sun may not rise/set daily (display appropriate warning or use civil twilight)
- **Date rollover at midnight**: Vedic day starts at sunrise; handle transition correctly
- **Paksham transition**: Accurately display Paksham change at Tithi boundary
- **Widget refresh**: Widget should update position indicator every ~5 minutes minimum

## Functional Requirements

### FR1: Astronomical Sunrise/Sunset Calculation

- System shall calculate precise sunrise and sunset times for any given date and geographic coordinates
- Calculations shall account for atmospheric refraction and elevation
- System shall provide fallback to cached values if calculation fails
- Library selection (SwissEph vs SunKit) shall be documented in research artifact

### FR2: Real-Time Nazhigai Progress Indicator

- Golden ring shall display an animated sphere/marker showing current position in the 60-Nazhigai cycle
- Indicator shall move smoothly (interpolated) rather than jumping between positions
- Position shall update every second to maintain real-time accuracy
- Indicator design shall be visually distinct from the ring background (e.g., glowing sphere with shadow)

### FR3: Paksham Visual Representation

- System shall display Krishna Paksha (waning) or Shukla Paksha (waxing) label
- Moon icon shall visually represent current phase:
  - New Moon (Amavasya): Dark circle
  - Waxing Crescent: Thin white crescent on right
  - First Quarter: Half white (right side)
  - Waxing Gibbous: Mostly white, dark left edge
  - Full Moon (Purnima): Fully white circle
  - Waning phases: Mirror of waxing (white on left)
- Icon shall be positioned near the Paksham text label

### FR4: Accurate Vedic Date Calculation

- System shall calculate and display:
  - **Samvatsara** (60-year cycle): Current year name (e.g., "Krodhi", "Pramoda")
  - **Masa**: Current lunar month based on calendar system (Solar/Lunar) setting
  - **Tithi**: Current lunar day (Pratipada to Chaturdashi, Amavasya/Purnima)
  - **Paksha**: Krishna or Shukla
  - **Nakshatra**: Current lunar mansion (1 of 27)
  - **Tithi Progress**: Percentage completion of current Tithi (0-100%)
- Calculations shall use location-aware astronomical ephemeris
- All values shall update at appropriate boundaries (e.g., Tithi changes when progress reaches 100%)

## Success Criteria

- **Accuracy**: Nazhigai count matches observed sunrise time within ±2 minutes for any tested location
- **Position Indicator**: Sphere on golden ring updates every 1 second and visually corresponds to elapsed time since sunrise
- **Paksham Display**: Moon phase icon correctly represents lunar illumination percentage within ±5%
- **Vedic Date**: Samvatsara, Tithi, and Nakshatra match reference Panchang (almanac) for 95% of test dates
- **User Verification**: 3+ users in different time zones confirm accuracy against local Panchang
- **Performance**: Calculations complete within 500ms on app launch
- **Widget**: Updates show current Nazhigai position within 10-minute accuracy

## Key Entities

### VedicTime (enhanced)
- `nazhigai`: Integer (0-59)
- `vinazhigai`: Integer (0-59)
- `percentElapsed`: Double (0.0-1.0)
- `sunrise`: Date (actual calculated time)
- `sunset`: Date (actual calculated time)
- `isDaytime`: Boolean
- **New**: `progressIndicatorAngle`: Double (0-360 degrees for UI positioning)

### VedicDate (enhanced)
- `samvatsara`: String (localization key)
- `samvatsaraIndex`: Integer (1-60 in cycle)
- `maasa`: String (localization key)
- `paksha`: Paksha (.shukla or .krishna)
- `pakshamIllumination`: Double (0.0-1.0, moon illumination percentage)
- `tithi`: String (localization key)
- `tithiProgress`: Double (0.0-1.0)
- `tithiNumber`: Integer (1-15 for each Paksha)
- `nakshatra`: String (localization key)
- `nakshatraProgress`: Double (0.0-1.0)
- `nakshatraNumber`: Integer (1-27)
- `day`: Integer

## Scope

### In Scope

- Integration of astronomical calculation library (SwissEph or SunKit)
- Sunrise/sunset calculation for any Earth location
- Animated position indicator on NazhigaiWheel
- Paksham moon phase visualization
- Accurate Samvatsara, Tithi, Nakshatra calculations
- Widget support for position indicator
- Fallback mechanism for offline/cached astronomical data

### Out of Scope

- Historical date calculations (pre-1900 CE)
- Predictive almanac view (showing future dates)
- Multiple location tracking (only current location)
- Astrology chart generation (Kundali/Horoscope)
- Custom Panchang rule variations (using standard Surya Siddhanta)
- Solar eclipse/lunar eclipse predictions

## Dependencies & Assumptions

### Dependencies

- **Astronomical Library**: SwissEph or SunKit framework (decision pending research)
- **CoreLocation**: For automatic user location detection
- **Manual Location**: Settings-based fallback from spec 001
- **VedicEngine**: Existing calculation framework from spec 001

### Assumptions

- Device has iOS 17+ (for latest astronomical calculations if using native frameworks)
- Calculation library provides Sunrise, Sunset, Moon Phase, and Vedic calendar components
- Users understand that Vedic day begins at sunrise, not midnight
- Panchang calculations follow Surya Siddhanta (standard astronomical text)
- App has persistent storage for caching calculated ephemeris data
- Maximum calculation error acceptable: ±2 minutes for time, ±1% for phases

## Non-Functional Requirements

### Performance
- Astronomical calculations must not block UI thread (use background queue)
- Widget timeline entries pre-calculated for next 24 hours to avoid repeated computation
- Cache ephemeris data for current date to avoid redundant calculations

### Offline Support
- App should cache sunrise/sunset for current location for ±3 days
- Vedic date calculations should cache for current month
- Gracefully degrade if astronomical calculations unavailable

### Accessibility
- Moon phase icon should have accessible label describing phase (e.g., "Waxing Gibbous Moon")
- Position indicator should be supplemented with VoiceOver description ("14 Nazhigai, 21 Vinazhigai elapsed")

### Localization
- All Vedic terms (Samvatsara names, Tithi names, Nakshatra names) must support existing 6 languages
- Moon phase descriptions in all supported languages

## Open Questions

None at this time. Library selection (SwissEph vs SunKit) will be resolved during planning phase research.

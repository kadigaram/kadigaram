# Feature Specification: Ayana Indicator (Uttarayanam/Dakshinayanam)

**Feature Branch**: `009-ayana-indicator`  
**Created**: 2026-01-31  
**Status**: Draft  
**Input**: User description: "Implement Ayanam 'Uttarayanam' and 'Dakshinayanam', Implement the core functional logic in sixpartslib and use the UI only for presentation. The Uttarayanam should be represented as a tiny 'up' arrow above the Sun symbol in the center of the clock dial."

## Overview

This feature adds visual indication of the Sun's annual north-south movement (Ayana) on the clock dial. In Vedic astronomy, Ayana represents the Sun's position relative to the celestial equator:
- **Uttarayanam** (उत्तरायण): The Sun's northward journey (Winter Solstice to Summer Solstice, approximately December 22 - June 21)
- **Dakshinayanam** (दक्षिणायन): The Sun's southward journey (Summer Solstice to Winter Solstice, approximately June 22 - December 21)

This astronomical phenomenon affects day length, seasons, and is culturally significant in Indian traditions.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - View Current Ayana Direction (Priority: P1) 🎯 MVP

Users viewing the clock dial can immediately see whether the Sun is in its northward or southward journey phase.

**Why this priority**: Core visual indicator that provides immediate astronomical context. This is the minimum viable feature that delivers the primary value.

**Independent Test**: Open the app and observe the clock dial center. An arrow indicator should appear above/below the Sun symbol showing current Ayana direction. Test on dates near solstices (June 21, December 22) and equinoxes (March 20, September 22) to verify correct direction.

**Acceptance Scenarios**:

1. **Given** today's date is between December 22 and June 20, **When** user views the clock dial, **Then** a small upward-pointing arrow appears above the Sun symbol indicating Uttarayanam
2. **Given** today's date is between June 22 and December 20, **When** user views the clock dial, **Then** a small downward-pointing arrow appears below the Sun symbol indicating Dakshinayanam
3. **Given** user opens the app on Winter Solstice day (December 21-22), **When** viewing the clock, **Then** the arrow transitions from downward to upward (or shows upward if after the exact solstice moment)
4. **Given** user opens the app on Summer Solstice day (June 21-22), **When** viewing the clock, **Then** the arrow transitions from upward to downward (or shows downward if after the exact solstice moment)

---

### User Story 2 - Understand Ayana Meaning (Priority: P2)

Users can learn what the Ayana arrow represents through accessible information.

**Why this priority**: Enhances user understanding and educational value. Not critical for core functionality but improves user experience.

**Independent Test**: Tap on the Ayana arrow or access app help/info section. User should be presented with a brief explanation of Uttarayanam/Dakshinayanam and their significance.

**Acceptance Scenarios**:

1. **Given** user is viewing the clock dial with Ayana indicator, **When** user taps on the arrow symbol, **Then** a tooltip or info popup explains the current Ayana phase and its meaning
2. **Given** user is viewing help documentation, **When** navigating to Vedic astronomy section, **Then** detailed explanation of Ayana concept is provided with visual examples

---

### User Story 3 - Localized Ayana Names (Priority: P2)

Users see Ayana terms in their preferred language (English, Tamil, Sanskrit).

**Why this priority**: Maintains consistency with app's multilingual support. Important for cultural authenticity but not critical for initial release.

**Independent Test**: Switch app language to Tamil or Sanskrit. Ayana indicator tooltip/description should display localized terms (உத்தராயணம்/தக்ஷிணாயனம் for Tamil, उत्तरायण/दक्षिणायन for Sanskrit).

**Acceptance Scenarios**:

1. **Given** app language is set to English, **When** viewing Ayana information, **Then** terms "Uttarayanam" and "Dakshinayanam" are displayed
2. **Given** app language is set to Tamil, **When** viewing Ayana information, **Then** terms "உத்தராயணம்" and "தக்ஷிணாயனம்" are displayed  
3. **Given** app language is set to Sanskrit, **When** viewing Ayana information, **Then** terms "उत्तरायण" and "दक्षिणायन" are displayed

---

### Edge Cases

- What happens on the exact moment of solstice transition (within the same day)? The indicator should switch directions at the precise astronomical moment if real-time data is available, otherwise default to calendar-based switching at midnight.
- How does the indicator behave in polar regions where traditional seasons don't apply? System should still calculate Ayana based on astronomical position (independent of local seasonal effects).
- What if there's no internet connection for astronomical data? System should use calculated astronomical formulas (precession-adjusted) rather than relying on external data sources.
- How does Uttarayanam/Dakshinayanam display in widget view? Arrow should be consistently visible in all views where the Sun symbol appears (dashboard, widget, full screen).

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST calculate current Ayana (Uttarayanam or Dakshinayanam) based on astronomical date ranges accounting for precession
- **FR-002**: System MUST display a visually distinct arrow indicator above the Sun symbol for Uttarayanam (northward journey)
- **FR-003**: System MUST display a visually distinct arrow indicator below the Sun symbol for Dakshinayanam (southward journey)
- **FR-004**: Ayana calculation logic MUST reside in SixPartsLib (core calculation engine), not in UI layer
- **FR-005**: UI components MUST only render the Ayana direction provided by SixPartsLib without performing calculations
- **FR-006**: System MUST determine Ayana transitions at Winter Solstice (approximately December 21-22) and Summer Solstice (approximately June 21-22)
- **FR-007**: Arrow indicator MUST be proportionally sized relative to the Sun symbol (approximately 20-30% of Sun symbol height)
- **FR-008**: Arrow indicator MUST be clearly visible against all background themes (light mode, dark mode)
- **FR-009**: System MUST support localized Ayana names in English, Tamil, and Sanskrit
- **FR-010**: Ayana indi cator MUST update automatically when crossing so lstice boundaries (if app is running)
- **FR-011**: System MUST persist current Ayana state for use in widgets and background contexts

### Key Entities

- **Ayana**: Represents the Sun's directional phase (Uttarayanam or Dakshinayanam), calculated from current date and astronomical constants, includes direction enum (North/South) and transition dates
- **VedicDate**: Extended to include Ayana property alongside existing Paksha, Nakshatra, and Tithi information

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Users can identify current Ayana direction within 1 second of viewing the clock dial
- **SC-002**: Ayana indicator transitions correctly on solstice dates (Winter Solstice ~Dec 21-22, Summer Solstice ~Jun 21-22) verified through manual testing
- **SC-003**: Arrow indicator is visible and aesthetically integrated with Sun symbol in both light and dark modes
- **SC-004**: Calculation accuracy matches astronomical ephemeris data within ±1 day for solstice transitions
- **SC-005**: Feature adds no noticeable performance impact (< 5ms calculation time, no UI lag)
- **SC-006**: 95% of users can correctly identify Ayana direction without additional explanation based on arrow position
- **SC-007**: Localization strings are provided for all three supported languages (English, Tamil, Sanskrit) with proper Unicode rendering

## Assumptions

- Solstice dates are calculated using standard astronomical formulas accounting for Earth's axial precession
- The feature uses calendar-based date ranges rather than real-time solar declination angle (simplified approach for MVP)
- Arrow indicators use SF Symbols or similar vector icons for scalability and theme adaptation
- The Sun symbol in the clock dial center already exists and serves as the anchor point for arrow placement
- Users familiar with Vedic astronomy concepts will recognize the directional arrows without extensive tooltips
- Ayana calculation does not require GPS location (unlike sunrise/sunset which are location-dependent)

## Dependencies

- **SixPartsLib**: Must be extended with Ayana calculation logic (new AstronomicalCalculator method or extension)
- **ClockDialView**: UI component must be updated to render arrow indicators
- **Localization**: Requires adding Ayana-related strings to `en.lproj`, `ta.lproj`, and Sanskrit localization files (if/when added)
- **VedicDate Model**: May need to include Ayana property for consistent data modeling

## Out of Scope

- Precise solar declination angle calculation (using simplified date-based ranges for MVP)
- Historical Ayana data browsing (showing Ayana for past/future dates beyond current day)
- Notification when Ayana transitions (push notification on solstice days)
- Detailed explanation of astronomical significance beyond basic tooltip
- Animation of arrow transition at exact solstice moment (static indicator is sufficient for MVP)

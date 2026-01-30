# Feature Specification: Moon Phase Arrow and Nakshatra Display

**Feature Branch**: `008-moon-nakshatra-ui`  
**Created**: 2026-01-29  
**Status**: Draft  
**Input**: User description: "Add waxing/waning arrow indicator next to moon phase and Nakshatra label below the current row"

## User Scenarios & Testing *(mandatory)*

### User Story 1 - View Waxing/Waning Moon Phase Indicator (Priority: P1)

As a user viewing the dashboard, I want to see a small arrow indicator next to the moon phase icon that shows whether the moon is waxing (growing/up) or waning (shrinking/down), so I can quickly understand the lunar cycle direction at a glance.

**Why this priority**: The moon phase indicator is a core part of the Vedic calendar display. Knowing whether the moon is waxing or waning is essential for many Hindu rituals and observances.

**Independent Test**: Can be fully tested by viewing the dashboard on different days across a lunar month and verifying the arrow direction matches the actual moon phase (waxing = up arrow during Shukla Paksha, waning = down arrow during Krishna Paksha).

**Acceptance Scenarios**:

1. **Given** the current date is during Shukla Paksha (waxing moon), **When** I view the dashboard header, **Then** I see a small up arrow (▲) next to the moon phase icon
2. **Given** the current date is during Krishna Paksha (waning moon), **When** I view the dashboard header, **Then** I see a small down arrow (▼) next to the moon phase icon
3. **Given** the moon phase is displayed, **When** I view the arrow, **Then** it uses the same styling/color as the moon phase icon for visual consistency

---

### User Story 2 - View Nakshatra Label (Priority: P1)

As a user viewing the dashboard, I want to see the current Nakshatra (lunar mansion) displayed below the existing Vedic date row, so I can know which star/constellation the moon is currently in for astrological purposes.

**Why this priority**: Nakshatra is a fundamental component of Vedic astrology and is essential for determining auspicious times (muhurta). Many users will expect this information alongside Tithi.

**Independent Test**: Can be fully tested by viewing the dashboard and verifying the Nakshatra label appears in the correct language (English or Tamil based on device locale), and matches the calculated Nakshatra for the current date.

**Acceptance Scenarios**:

1. **Given** the app displays Vedic date information, **When** I view the dashboard header, **Then** I see the Nakshatra label below the row containing moon phase, year, month/day, and Tithi
2. **Given** my device language is set to Tamil, **When** I view the Nakshatra label, **Then** it displays in Tamil (e.g., "அசுவினி" for Ashwini)
3. **Given** my device language is set to English, **When** I view the Nakshatra label, **Then** it displays in English (e.g., "Ashwini")

---

### Edge Cases

- What happens on the boundary between Shukla Paksha and Krishna Paksha (full moon/new moon)? The arrow should reflect the transition day appropriately.
- What happens if the Nakshatra calculation returns an invalid value? Display should gracefully handle missing data.
- What happens during Nakshatra transitions (when the moon moves from one Nakshatra to another during the day)? Display the Nakshatra at the current time.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST display an upward arrow indicator (▲ or chevron.up) next to the moon phase icon when the current lunar phase is Shukla Paksha (waxing moon)
- **FR-002**: System MUST display a downward arrow indicator (▼ or chevron.down) next to the moon phase icon when the current lunar phase is Krishna Paksha (waning moon)
- **FR-003**: The arrow indicator MUST use the same color styling as the moon phase icon for visual consistency
- **FR-004**: System MUST display the Nakshatra name as a separate label below the existing date row
- **FR-005**: The Nakshatra label MUST be localized and display in Tamil when the device language is Tamil
- **FR-006**: The Nakshatra label MUST display in English as the default/fallback language
- **FR-007**: The arrow indicator MUST be small/subtle (tiny as specified) so as not to overwhelm the moon phase icon

### Key Entities

- **Paksha**: Represents the lunar phase (Shukla = waxing, Krishna = waning). Already exists in the VedicDate model.
- **Nakshatra**: Represents the lunar mansion (1-27 stars). Already exists in the VedicDate model with localization keys.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Users can identify the moon phase direction (waxing/waning) within 1 second of viewing the dashboard
- **SC-002**: Nakshatra label is visible below the date row at 100% of the time when dashboard loads successfully
- **SC-003**: Localization accuracy: Nakshatra displays correctly in Tamil and English matching the localization strings
- **SC-004**: Arrow indicator correctly reflects Paksha state for 100% of test dates across a full lunar cycle

## Assumptions

- Nakshatra calculation is already implemented and working correctly in VedicEngine
- All 27 Nakshatra names have English and Tamil translations in Localizable.strings files
- The BhashaEngine.localizedString() method can be used to get localized Nakshatra names

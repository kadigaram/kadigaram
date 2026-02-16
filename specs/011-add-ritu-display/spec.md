# Feature Specification: Ritu (Seasons) Display

**Feature Branch**: `011-add-ritu-display`  
**Created**: 2026-02-06  
**Status**: Active  
**Input**: User description: "implement ritu in the clock i have already added traslation for Tamil, Sanskrit, and English. I have also added icons/images for each season. show the label and icon next to Nakshathram , make sure the icon is scaled in a way that its no bigger than the phasing moon."

## User Scenarios & Testing *(mandatory)*

### Edge Cases

- **Date Boundaries (Sankranti)**: Transition between seasons occurs exactly at the solar month change. The system uses the existing `TamilCalendarCalculator` transition logic, so Ritu will change when the Tamil Month changes.
- **Missing Assets**: If an icon file is missing for a season, the UI should display the Ritu name without the icon to prevent layout breakage or blank spaces.
- **extreme Latitudes**: Calendar calculations rely on solar position; extreme latitudes (polar regions) are handled by the underlying astronomical library, but Ritu is defined by Solar Longitude, which is independent of latitude.

### User Story 1 - View Current Season (Ritu) (Priority: P1)

Users want to see the current Vedic season (Ritu) on the clock face to align their activities with the traditional time cycle. Application should display both the name of the season and its corresponding icon.

**Why this priority**: Core requirement requested by the user to enhance the traditional timekeeping aspect of the clock.

**Independent Test**: Can be tested by verifying the UI shows the correct season name and icon for various dates throughout the year.

**Acceptance Scenarios**:

1. **Given** the current date corresponds to Chithirai or Vaigasi month, **When** the user views the clock, **Then** the display shows "Vasanta" (or localized equivalent) and the Spring icon.
2. **Given** the clock UI is active, **When** the Ritu is displayed, **Then** the icon is positioned next to the Nakshatra and is not larger than the Phasing Moon icon.
3. **Given** a language change (e.g., to Tamil), **When** the user views the clock, **Then** the Ritu name updates to the corresponding Tamil translation (e.g., "வசந்த").

---

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST calculate the current Ritu (Season) based on the current Tamil Solar Month.
  - *Assumption*: Mapping follows standard Vedic solar months:
    - Vasanta: Chithirai, Vaigasi
    - Grishma: Aani, Aadi
    - Varsha: Aavani, Purattasi
    - Sharad: Aippasi, Karthigai
    - Hemanta: Margazhi, Thai
    - Shishira: Masi, Panguni
- **FR-002**: System MUST display the localized Ritu name (English, Tamil, Sanskrit) on the clock face.
- **FR-003**: System MUST display a graphical icon representing the current Ritu.
  - Icons are located in `kadigaram/ios/Kadigaram/Resources` with filenames `ritu_<season>.png` (e.g., `ritu_vasanta.png`).
  - System MUST load these images from the bundle resources.
- **FR-004**: The Ritu display (icon + label) MUST be positioned visually adjacent to the Nakshatra display.
- **FR-005**: The Ritu icon's visual dimensions MUST NOT exceed the dimensions of the displayed Moon Phase icon.

### Key Entities

- **Ritu**: Enum or Type representing the 6 seasons.
- **TamilDate**: Existing entity, source for Month data to determine Ritu.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Ritu name and icon appear on the Dashboard for 100% of valid dates.
- **SC-002**: Ritu calculation matches the standard mapping from Tamil Months for all 12 months.
- **SC-003**: UI rendering time does not increase by more than 16ms (1 frame) due to additional asset loading.

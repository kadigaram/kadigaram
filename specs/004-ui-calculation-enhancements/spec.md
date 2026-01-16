# Feature Specification: UI and Calculation Enhancements

**Feature Branch**: `004-ui-calculation-enhancements`  
**Created**: 2026-01-14  
**Status**: Draft  
**Input**: User description: "UI improvements + Functional improvements for accurate Vedic calculations"

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Enhanced Dial Visualization (Priority: P1)

As a user viewing the Nazhigai dial, I want a more premium 3D embossed appearance with better contrast so that I can easily read all time segments and details.

**Why this priority**: Visual clarity is essential for usability. The current UI may have readability issues.

**Independent Test**: View the dial on both light and dark themes and verify all elements are clearly visible with good contrast.

**Acceptance Scenarios**:

1. **Given** the dial is displayed, **When** I look at it, **Then** it should have a 3D embossed visual style that appears raised/tactile.
2. **Given** light or dark theme is active, **When** I view the background, **Then** it should contrast sufficiently with the golden dial to make minutes and marks visible.
3. **Given** the Yamagandam period is displayed, **When** viewing in either theme, **Then** it should appear in grey (not red) with automatic adaptation to theme (light grey for dark mode, dark grey for light mode).

---

### User Story 2 - 24-Hour Time Reference (Priority: P1)

As a user, I want modern 24-hour time labels around the dial starting from sunrise time so that I can correlate traditional Vedic periods (like Yamagandam) with modern clock time.

**Why this priority**: Essential for users to understand when Vedic periods occur in relation to real-world time.

**Independent Test**: Check that 24hr labels start at sunrise position and progress clockwise, matching actual sunrise time for the location.

**Acceptance Scenarios**:

1. **Given** sunrise is at 6:30 AM, **When** viewing the dial, **Then** "06:30" should appear at the top/start position of the dial.
2. **Given** the dial rotates through 24 hours, **When** viewing hour markers, **Then** they should increment correctly (e.g., 06:30, 07:30, 08:30...) around the dial.
3. **Given** Yamagandam period is at hour X, **When** I look at the label, **Then** I can see the corresponding 24hr time for that period.

---

### User Story 3 - Accurate Vedic Calculations (Priority: P1)

As a user, I want accurate Samvatsara, Tithi, Nakshatra, and other Vedic date/time calculations so that I can trust the app for religious and cultural practices.

**Why this priority**: Critical for trust and correctness. Inaccurate calculations make the app useless for its intended purpose.

**Independent Test**: Compare app output with Dhrik Panchang or other authoritative source for same date/location.

**Acceptance Scenarios**:

1. **Given** today's date and my location, **When** I check the Samvatsara year, **Then** it should match the value from Dhrik Panchang.
2. **Given** a specific date/time, **When** I check Tithi, **Then** it should match authoritative almanac sources.
3. **Given** current time and location, **When** I check Nakshatra, **Then** it should be accurate to within acceptable astronomical precision.

## Assumptions

- **Dhrik Panchang** is referenced as the gold standard for accurate Vedic calculations. We will research their methodology or use equivalent astronomical libraries (e.g., Swiss Ephemeris).
- The "golden dial" refers to the current Nazhigai wheel visual design, which users like and want to retain with enhancements.
- 3D embossed style means using shadows, highlights, and gradients to create depth perception (not actual 3D rendering).
- Yamagandam is currently shown in red, causing poor contrast or inappropriate emphasis.

## Requirements *(mandatory)*

### Functional Requirements

#### Visual Design (UI)

- **FR-001**: The Nazhigai dial MUST retain its golden color scheme while adding 3D embossed visual effects (shadows, highlights, depth).
- **FR-002**: The dial background MUST provide sufficient contrast with the golden dial so that minute marks, labels, and periods are clearly visible.
- **FR-003**: System MUST display 24-hour time labels around the dial perimeter, positioned to start at the current sunrise time.
- **FR-004**: 24-hour labels MUST increment clockwise, showing modern time alongside traditional Nazhigai divisions.
- **FR-005**: Yamagandam period MUST be displayed in grey (not red), with automatic color adjustment based on system theme (light/dark mode).
- **FR-006**: All visual elements MUST be readable in both light and dark system themes with appropriate contrast ratios.

#### Calculation Accuracy

- **FR-007**: System MUST calculate Samvatsara (60-year cycle) accurately for any given date.
- **FR-008**: System MUST calculate Tithi accurately based on moon-sun longitudinal difference.
- **FR-009**: System MUST calculate Nakshatra accurately based on moon's ecliptic position.
- **FR-010**: System MUST calculate Maasa (month) correctly according to selected calendar system (solar/lunar).
- **FR-011**: Calculations MUST match authoritative sources (e.g., Dhrik Panchang) within acceptable astronomical precision (< 1 minute for time-based calculations).
- **FR-012**: System MUST use location and timezone data to ensure calculations are geographically accurate.

### Edge Cases

- **Different Sunrise Times**: For locations with extreme sunrise times (e.g., Arctic regions), the 24hr dial should still function correctly even if sunrise is late/early.
- **Theme Switching Mid-Use**: If user switches system theme while app is active, colors should update immediately without restart.
- **Leap Years and Intercalary Months**: Vedic calendar calculations must handle Adhik Maasa (extra month) correctly.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Users report improved readability of dial elements across both light and dark themes (target: 90%+ satisfaction in user testing).
- **SC-002**: 24-hour time labels correctly align with sunrise time for any tested location (target: 100% accuracy across 10 global cities).
- **SC-003**: Vedic calculations match Dhrik Panchang output for same date/location (target: 100% match for Samvatsara, Tithi, Nakshatra on tested dates).
- **SC-004**: Yamagandam period is clearly visible and non-alarming (grey instead of red) in both themes.

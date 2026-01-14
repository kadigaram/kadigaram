# Feature Specification: Visual UX Design and Core Architecture for Kadigaram
**Feature Branch**: `001-kadigaram-core`
**Created**: 2026-01-12
**Status**: Draft
**Input**: User provided visual design, technical specs, and mockup for "Kadigaram" app.

## Clarifications

### Session 2026-01-12
- Q: Tablet Layout Strategy? → A: Scale Up (Simple resize, maintain same layout).
- Q: Smart Watch Scope? → A: Complications Only (No full app, just watch face widgets).
- Q: Watch Platform Parity? → A: Apple Watch Only (Wear OS deferred).
- Q: Handing Location Permission Denial? → A: Allow manual location entry via text box with auto-fill (e.g., "weather network" style).

## User Scenarios & Testing *(mandatory)*

### User Story 1 - View Dual Time Dashboard (Priority: P1)

The user launches the app to view the current time in the traditional Nazhigai format alongside the standard Gregorian date and the corresponding Vedic date details (Samvatsara, Maasa, Tithi). This is the primary view of the application.

**Why this priority**: This is the core value proposition of the app—providing "Solar-Synchronized Time" in a visual, dual-calendar format.

**Independent Test**: Can be fully tested by launching the app and verifying that the header displays both Gregorian and Vedic dates correctly and the central wheel displays the running Nazhigai time.

**Acceptance Scenarios**:

1. **Given** the app is launched, **When** the dashboard loads, **Then** the Top Header displays the current Gregorian Date (e.g., "Wednesday, 14 Jan 2026").
2. **Given** the app is launched, **When** the dashboard loads, **Then** the Bottom Header displays the calculated Vedic Date: [Samvatsara] • [Maasa & Day] • [Tithi] (e.g., "Krodhi • Margazhi 29 • Shukla Ekadashi").
3. **Given** the app is launched, **When** the dashboard loads, **Then** the Central Wheel displays the current Nazhigai:Vinazhigai time (e.g., "14:21") synchronized to the sun.
4. **Given** the app is running on a **Tablet/iPad**, **When** the dashboard loads, **Then** the layout scales up proportionally to fill the screen without rearranging components or adding sidebars.

---

### User Story 2 - Switch Language via Bhasha Engine (Priority: P2)

The user switches the app's interface language instantly using an on-screen toggle, independent of the device's system language.

**Why this priority**: Critical for accessibility and religious context. Users may prefer their phone in English but their spiritual clock in Sanskrit or Tamil.

**Independent Test**: Can be tested by tapping the "A/अ" icon and verifying strings update immediately.

**Acceptance Scenarios**:

1. **Given** the dashboard is active, **When** the user taps the "A/अ" footer icon, **Then** a language selection menu appears (English, Sanskrit, Tamil, Telugu, Kannada, Malayalam).
2. **Given** Tamil is selected, **When** the selection is confirmed, **Then** the dashboard text transforms immediately (e.g., "Wednesday" -> "புதன்").
3. **Given** Sanskrit is selected, **When** the date renders, **Then** the Devanagari font (Eczar/Yantramanav) is used for legibility.

---

### User Story 3 - Configure Calendar System (Priority: P3)

The user configures the month calculation system (Solar vs. Lunar) in settings to match their regional practice (South vs. North Indian).

**Why this priority**: Ensures the app is relevant to broader audiences with different Vedic traditions.

**Independent Test**: Can be tested by toggling the setting and verifying the displayed Month name changes if applicable.

**Acceptance Scenarios**:

1. **Given** the default configuration, **When** checking the Maasa, **Then** the Solar (Vakya/Tamil) month is displayed (e.g., Margazhi).
2. **Given** the user navigates to Settings, **When** "Lunar Month" is enabled, **Then** the dashboard displays the Amanta/Purnimanta month name (e.g., Pausha/Magha).

---

### User Story 4 - View Apple Watch Complications (Priority: P4)

The user views key Vedic time data (Nazhigai, Tithi) directly on their Apple Watch face without opening an app.

**Why this priority**: Provides "glanceable" value for users who want to check the auspicious time quickly. iOS Integration is key.

**Independent Test**: Install the watch complication on Apple Watch and verify data matches the phone app.

**Acceptance Scenarios**:

1. **Given** the Apple Watch face is active, **Then** a "Nazhigai" complication displays the current Nazhigai time.
2. **Given** the Apple Watch face is active, **Then** a "Tithi" complication displays the current Tithi name.
3. **Given** the user taps the complication, **Then** it (optionally) launches the phone app or shows a static detail view.
4. **Note**: Android/Wear OS support is explicitly Out of Scope for this story.

---

### Edge Cases

- **Location Permissions Denied**: Nazhigai calculation requires Sunrise/Sunset times. Upon permission denial (or manual selection), the app must provide a text input box. The user enters a location name, and the system auto-fills/suggests locations (e.g., "Ch...") to resolve coordinates.
- **Midnight Crossover**: Gregorian date changes at 00:00, but Vedic Tithi/Day may change at Sunrise. The UI must handle these asynchronous updates correctly.
- **Dynamic Type**: Ensure the dense info in the header (Samvatsara/Maasa/Tithi) scales or wraps gracefully on small screens with large fonts.
- **Device Scaling**: On Tablets/Large Screens, the UI must strictly scale up (zoom equivalent) rather than reflow into a multi-column layout.
- **Watch Data Freshness**: Complications must update accurately within widget refresh budgets (WidgetKit).

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST display a Dual Calendar Data Header showing Gregorian Date (Top) and Vedic Date (Bottom: Year, Month, Day, Tithi).
- **FR-002**: System MUST render a central "Nazhigai Wheel" showing the current time in Nazhigai:Vinazhigai units.
- **FR-003**: System MUST support localized number systems (e.g., Tamil numerals ௧௨:௪௫) as a toggleable option.
- **FR-004**: System MUST implement an In-App Language Override ("Bhasha Engine") supporting English, Sanskrit, Tamil, Telugu, Kannada, and Malayalam.
- **FR-005**: System MUST use platform-native localization catalogs (String Catalogs for iOS, ContextWrapper for Android) to manage these overrides.
- **FR-006**: System MUST calculate Vedic Year (Samvatsara) based on the 60-year Jovian cycle.
- **FR-007**: System MUST support both Solar (Vakya) and Lunar (Amanta/Purnimanta) month calculation methods, defaulting to Solar.
- **FR-008**: System MUST use specific fonts for legibility: Noto Sans for Dravidian/Latin, and Eczar/Yantramanav for Sanskrit/Devanagari.
- **FR-009**: System MUST support Tablet/iPad devices by scaling the phone interface proportionally (Universal App) without adaptive layout changes.
- **FR-010**: System MUST provide Apple Watch Complications (WidgetKit) for Nazhigai and Tithi (Wear OS is out of scope).
- **FR-011**: System MUST provide a manual location entry fallback (search box with autocomplete) if location permissions are denied.

### Key Entities

- **VedicTime**: Represents the calculated point in time (Nazhigai, Vinazhigai) relative to Sunrise.
- **DualDate**: A composite object containing the Gregorian `Date` and the parsed `VedicDate` (Year, Month, Tithi, Nakshatra).
- **LocalizationContext**: The state manager responsible for forcing the active locale across the app views.
- **LocationContext**: Coordinates and solar events (Sunrise/Sunset) required for calculation.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Language switching happens instantly (< 200ms) without requiring an app restart.
- **SC-002**: UI rendering maintains 60fps+ performance, especially for the central wheel animation (per Constitution).
- **SC-003**: Font rendering of complex ligatures (Tamil/Sanskrit) is glitch-free on all supported device sizes (Phone/Tablet).
- **SC-004**: App bundle size remains optimized despite including multiple custom fonts (target < 50MB).
- **SC-005**: Watch complications update accurately within OS background refresh limits (WidgetKit budget).
- **SC-006**: Manual location search returns valid coordinate results within 2 seconds.

# Feature Specification: Manual Location Entry

**Feature Branch**: `003-manual-location-entry`  
**Created**: 2026-01-14  
**Status**: Draft  
**Input**: User description: "Make sure location logic works correctly. If the user did not permit location to the app let them to set it via search able text in the settings screen."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Manual Location Setup (Priority: P1)

As a user who has denied location permissions (or prefers not to share live location), I want to manually search for and select my city in the settings so that the app can calculate accurate Vedic time for my location.

**Why this priority**: Essential functionality for users who value privacy or have disabled location services. Without this, the app is unusable for them.

**Independent Test**: Can be fully tested by denying location permissions during onboarding, navigating to settings, searching for "New York", selecting it, and verifying the main screen shows data for New York.

**Acceptance Scenarios**:

1. **Given** the user has denied location permissions, **When** they open the app/settings, **Then** they should see an option to "Set Location Manually".
2. **Given** the manual location search screen, **When** the user types a city name (e.g., "Paris"), **Then** a list of matching locations (City, Country) should appear.
3. **Given** a list of search results, **When** the user selects a location, **Then** the app should save this location and update all time calculations immediately.

---

### User Story 2 - Persistent Manual Location (Priority: P1)

As a user, I want my manually selected location to be saved across app restarts so that I don't have to enter it every time I open the app.

**Why this priority**: Core usability requirement.

**Independent Test**: Set manual location, kill app, relaunch. Verify location is still set.

**Acceptance Scenarios**:

1. **Given** a manually set location, **When** the app is force-quit and relaunched, **Then** the app should retain the manual location and function without asking for permissions again.

---

### User Story 3 - Location Status Feedback (Priority: P2)

As a user, I want to clearly see which location is currently being used (GPS or Manual) in the settings so that I am confident the calculations are correct.

**Why this priority**: Reduces user confusion about data accuracy.

**Independent Test**: Toggle between GPS (if allowed) and Manual (or just observe state).

**Acceptance Scenarios**:

1. **Given** a manual location is set, **When** looking at Settings, **Then** valid location name (e.g., "Paris, France") should be displayed.
2. **Given** location permission is denied and no manual location is set, **When** looking at Settings/Home, **Then** a "Location Required" or "Set Location" prompt should be visible.

## Assumptions

- We will use a standard location search provider (like Apple Maps/CoreLocation geocoding) for the "search able text" functionality.
- "Location logic works correctly" implies that if GPS is available and permitted, it takes precedence OR the user has an explicit toggle. For this MVP, we assume: **If GPS Denied/Unavailable -> Use Manual. If GPS Authorized -> Use GPS (unless we add an override toggle, but requirement says "If user did not permit... let them set it", implying fallback).** 
- **Assumption**: We will prioritizing "Fallback" behavior. If GPS is allowed, the manual setting might be hidden or disabled, OR just overridden.
- **Clarification**: To be safe and flexible, we will allow setting manual location *at any time*, but it will definitely be used if GPS is denied.


### Edge Cases

- **No Internet Connectivity**: If the user tries to search for a location without internet, the system should show a friendly error message ("Cannot search location. Please check your connection.") and allow retrying.
- **Location Permission Granted Later**: If the user sets a manual location but later grants "While In Use" location permission, the system should ask the user if they want to switch to GPS or keep the manual location. (For MVP: System will prefer GPS if authorized, OR we maintain the manual override until cleared. *Decision for MVP*: GPS Authorization implies consent to use it. If GPS is authorized, switch to GPS. If user wants manual, they must deny permission or we add a toggle later. For now, Manual is a fallback).
- **Zero Search Results**: If the text entered yields no matches, display "No locations found" and encourage checking spelling.
- **Ambiguous Selection**: If the user selects a city with duplicate names in the dataset without clear distinction, ensure the display (State/Country) helps.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST provide a search interface in the Settings screen that allows users to input text to find geographic locations (Cities).
- **FR-002**: System MUST display search results including City Name, State/Region, and Country to avoid ambiguity (e.g., "Paris, TX" vs "Paris, France").
- **FR-003**: System MUST allow the user to select one location from the search results.
- **FR-004**: System MUST store the selected location (Latitude, Longitude, and Timezone/Name) persistently.
- **FR-005**: System MUST use the stored manual location for all Vedic time calculations if Location Services are disabled or denied by the user.
- **FR-006**: System MUST gracefully handle the state where neither GPS nor Manual Location is available (e.g., show a default empty state or prompt).

### Key Entities

- **UserPreferences**: Stores the manually selected location data.
- **LocationSearchService**: Interface for querying location data from text.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Users can find and select a major city (top 100 global cities) within 5 seconds of typing.
- **SC-002**: App successfully calculates time data 100% of the time when "Location Access" is denied but a manual location is set.
- **SC-003**: No app crashes occur when Location Permissions are "Denied".

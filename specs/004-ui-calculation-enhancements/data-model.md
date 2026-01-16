# Data Model: UI and Calculation Enhancements

## No New Entities

This feature primarily modifies existing visual components and calculation logic. No new data entities are required.

## Modified Components

### NazhigaiWheel (View)
- **New Properties**: Additional visual styling (gradients, shadows)
- **Modified Behavior**: Theme-aware color selection for segments

### VedicEngine (Calculation)
- **Modified Methods**:
  - `calculateVedicDate()`: Will use astronomical library instead of stubs
  - New helper methods for Tithi/Nakshatra calculation
- **Dependencies**: Will add dependency on astronomical calculation library

## Calculation Outputs (Existing, but now accurate)

### Tithi Calculation
- **Input**: Date, Time, Location (lat/long, timezone)
- **Output**: Tithi number (1-30), Tithi name, progress percentage
- **Method**: (Moon longitude - Sun longitude) / 12 degrees

### Nakshatra Calculation
- **Input**: Date, Time, Location
- **Output**: Nakshatra number (1-27), Nakshatra name, progress percentage
- **Method**: Moon ecliptic longitude / 13.333... degrees

### Samvatsara Calculation
- **Input**: Year
- **Output**: Samvatsara name, index in 60-year cycle
- **Method**: Existing SamvatsaraTable lookup (verify accuracy)

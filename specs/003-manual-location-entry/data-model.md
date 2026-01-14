# Data Model: Manual Location Entry

## Entities

### LocationResult
*Used in Search UI to display results*

| Field | Type | Description |
|-------|------|-------------|
| `id` | `UUID` | Unique identifier (internal) |
| `name` | `String` | Display name (e.g. "Chennai, Tamil Nadu") |
| `coordinate` | `CLLocationCoordinate2D` | Lat/Long |
| `timeZone` | `TimeZone` | Timezone of the location |

### AppConfig (Updates)
*Existing entity, new/updated fields*

| Field | Type | Storage Key | Description |
|-------|------|-------------|-------------|
| `isManualLocation` | `Bool` | `is_manual_location` | Toggle for manual mode |
| `manualLatitude` | `Double` | `manual_lat` | Selected latitude |
| `manualLongitude` | `Double` | `manual_long` | Selected longitude |
| `manualLocationName` | `String` | `manual_location_name` | [NEW] Display name of selected location |
| `manualTimeZone` | `String` | `manual_time_zone` | [NEW] Timezone identifier (optional, can derive from coord but better to store if user picked it) |

## API Contracts (Internal)

### LocationSearchService

```swift
protocol LocationSearchServiceProtocol {
    func search(query: String) async throws -> [LocationResult]
}
```

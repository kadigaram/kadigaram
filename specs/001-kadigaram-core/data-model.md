# Data Model: Kadigaram Core

## Entities

### `VedicTime`
Represents the solar-synced time.
- `nazhigai`: Int (0-59)
- `vinazhigai`: Int (0-59)
- `percentElapsed`: Double (0.0-1.0) - For UI Wheel progress
- `sunrise`: Date
- `sunset`: Date
- `isDaytime`: Bool

### `VedicDate`
Represents the Panchangam components.
- `samvatsara`: String (Key for Localization, e.g., "year_krodhi")
- `maasa`: String (Key, e.g., "month_margazhi")
- `paksha`: Enum (.shukla, .krishna)
- `tithi`: String (Key, e.g., "tithi_ekadashi")
- `day`: Int (Day of month)

### `DualDate`
Composite view model.
- `gregorian`: Date
- `vedic`: VedicDate

### `LocationConfig`
- `coordinate`: CLLocationCoordinate2D
- `name`: String
- `source`: Enum (.gps, .manual)
- `timezone`: TimeZone

### `AppConfig`
- `language`: Enum (en, sa, ta, te, kn, ml)
- `calendarSystem`: Enum (.solar, .lunar)

## Storage Schema (UserDefaults)

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| `user_locale` | String | "en" | Selected Bhasha Code |
| `calendar_mode` | String | "solar" | Month calculation mode |
| `manual_location` | JSON | null | Saved manual location struct |

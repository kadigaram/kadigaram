# kadigaram Development Guidelines

Auto-generated from all feature plans. Last updated: 2026-01-12

## Active Technologies
- Swift 6.0 + `MapKit` (for search), `CoreLocation`, `SwiftUI` (003-manual-location-entry)
- `UserDefaults` (via existing `AppConfig` class) (003-manual-location-entry)
- Swift 6.0 + SwiftUI, existing `VedicEngine`, **NEW: Swiss Ephemeris library (or equivalent astronomical calculation library)** (004-ui-calculation-enhancements)
- No new storage requirements (004-ui-calculation-enhancements)
- Swift 6.0 (iOS 17+, backward compatible to iOS 16) (005-accurate-tamil-date)
- N/A (calculations are real-time, no persistence) (005-accurate-tamil-date)
- UserDefaults (existing, for theme preferences if needed) (006-clock-ui-improvements)
- Swift 6.0 + SwiftUI, KadigaramCore, SixPartsLib (008-moon-nakshatra-ui)
- N/A (display only, uses existing VedicDate model) (008-moon-nakshatra-ui)

- Swift 6.0 + SwiftUI, WidgetKit, CoreLocation, Foundation (Date/Calendar) (001-kadigaram-core)

## Project Structure

```text
src/
tests/
```

## Commands

# Add commands for Swift 6.0

## Code Style

Swift 6.0: Follow standard conventions

## Recent Changes
- 008-moon-nakshatra-ui: Added Swift 6.0 + SwiftUI, KadigaramCore, SixPartsLib
- 006-clock-ui-improvements: Added Swift 6.0 (iOS 17+, backward compatible to iOS 16)
- 005-accurate-tamil-date: Added Swift 6.0 (iOS 17+, backward compatible to iOS 16)


<!-- MANUAL ADDITIONS START -->
<!-- MANUAL ADDITIONS END -->

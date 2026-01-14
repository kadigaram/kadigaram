# Research: Kadigaram Core Technologies

## 1. Vedic Calculation Algorithms
**Decision**: Custom Swift Implementation ("Swiss Ephemeris" port or validated Formulae)
**Rationale**:
- Native dependencies are preferred over bridging huge C libraries if possible for simple Panchangam (Tithi/Nakshatra).
- Lightweight formulae (Jean Meeus astronomical algorithms) are often sufficient for Tithi/Nakshatra without full ephemeris bloat if extreme precision (<1 min) isn't critical.
- **Action**: Evaluate `SwiftAstronomy` or port core Meeus algorithms for Sun/Moon position.
- **Fallback**: Use a compiled C-based ephemeris (e.g., SwissEph) if accuracy requires it, wrapped in Swift.

## 2. Bhasha Engine (Localization)
**Decision**: `String(localized:table:bundle:)` with Custom `Verification`
**Rationale**:
- iOS 15+ `String(localized:)` is powerful.
- To force language change *without* rebooting:
    - We cannot rely on system locale.
    - We must explicitly pass the `Bundle` path of the selected language `.lproj` to the string lookup.
    - **Architecture**: A singleton `LocalizationManager` that holds the current `Bundle` reference. All UI components observe this manager.

## 3. Watch Connectivity
**Decision**: `WidgetKit` (Shared Framework)
**Rationale**:
- Watch Complications are now built with WidgetKit (same as Lock Screen widgets).
- **Core Strategy**: Extract `VedicEngine` and `Models` into a shared `KadigaramCore` Swift Package or Framework.
- This allows both the Main App and the Watch Extension to calculate Nazhigai independently without IPC (Inter-Process Communication) latency.

## 4. Manual Location Entry
**Decision**: `MKLocalSearch` (MapKit)
**Rationale**:
- Built-in Apple API for address completion.
- No third-party API keys (Google Places) needed.
- Free and privacy-friendly.

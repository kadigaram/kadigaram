# Data Model: Moon Phase Arrow and Nakshatra Display

**Feature**: 008-moon-nakshatra-ui
**Date**: 2026-01-29

## Summary

This feature uses **existing data models** with no schema changes required.

## Existing Entities Used

### VedicDate (SixPartsLib)

Already contains all required data:

| Field | Type | Usage |
|-------|------|-------|
| `paksha` | `Paksha` enum (`.shukla` / `.krishna`) | Determines arrow direction |
| `nakshatra` | `String` | Localization key (e.g., "nakshatra_ashwini") |
| `nakshatraNumber` | `Int` | 1-27 for the 27 Nakshatras |
| `nakshatraProgress` | `Double` | 0.0-1.0 completion through current Nakshatra |

### Paksha (SixPartsLib)

Existing enum, no changes needed:

```swift
public enum Paksha: String, Codable {
    case shukla  // Waxing (new moon → full moon)
    case krishna // Waning (full moon → new moon)
}
```

## View Model Changes

### MoonPhaseView (KadigaramCore)

**Current**:
```swift
public struct MoonPhaseView: View {
    let paksha: Paksha
    let illumination: Double
}
```

**New Parameter**:
```swift
public struct MoonPhaseView: View {
    let paksha: Paksha
    let illumination: Double
    var showPakshaArrow: Bool = true  // NEW: optional arrow display
}
```

### DualDateHeader (Kadigaram)

**Current State**: Uses `vedicDate.paksha` and other properties

**New Usage**: Also display `vedicDate.nakshatra` via localization

No struct changes needed - just additional display logic.

## Localization Keys

### Nakshatra Names (Already Exist)

Keys in format: `nakshatra_{name}`

| Key | English | Tamil |
|-----|---------|-------|
| nakshatra_ashwini | Ashwini | அசுவினி |
| nakshatra_bharani | Bharani | பரணி |
| nakshatra_krittika | Krittika | கார்த்திகை |
| nakshatra_rohini | Rohini | ரோகிணி |
| ... | ... | ... |
| nakshatra_revati | Revati | ரேவதி |

**Total**: 27 Nakshatras, all already translated

## No Database Changes

This is a display-only feature. No persistence layer modifications required.

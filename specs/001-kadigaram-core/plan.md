# Implementation Plan: Kadigaram Core

**Branch**: `001-kadigaram-core` | **Date**: 2026-01-12 | **Spec**: [spec.md](spec.md)
**Input**: Feature specification from `/specs/001-kadigaram-core/spec.md`

## Summary

Implement the core "Kadigaram" experience on iOS first, featuring a Dual Calendar (Gregorian + Vedic), Nazhigai Wheel, and Bhasha Engine for localization. The implementation prioritizes Native performance (SwiftUI), accurate Vedic calculations, and Apple Watch integration.

## Technical Context

**Language/Version**: Swift 6.0
**Primary Dependencies**: SwiftUI, WidgetKit, CoreLocation, Foundation (Date/Calendar)
**Storage**: UserDefaults (Settings/Preferences)
**Testing**: XCTest (Unit), XCUITest (UI)
**Target Platform**: iOS 17.0+ (Supporting N-1 per Constitution)
**Project Type**: Mobile (iOS Native Monorepo structure)
**Performance Goals**: 60fps+ Animation for Nazhigai Wheel, <200ms Language Switch
**Constraints**: Offline-first calculations, <50MB bundle size, Battery efficient location usage

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- [x] **Mobile-First Native**: Plan explicitly targets Native Swift/SwiftUI.
- [x] **Backward Compatibility**: Targeting iOS 17+ (assuming current is 18) satisfies N-1.
- [x] **Testing**: XCTest ingrained in Phase 1 setup.
- [x] **Design**: "Visual UX" is a primary phase.

## Project Structure

### Documentation (this feature)

```text
specs/001-kadigaram-core/
├── plan.md              # This file
├── research.md          # Phase 0 output
├── data-model.md        # Phase 1 output
├── quickstart.md        # Phase 1 output
├── contracts/           # Phase 1 output
└── tasks.md             # Phase 2 output
```

### Source Code (repository root)

```text
# Option 3: Mobile (iOS First)
kadigaram/
├── ios/
│   ├── Kadigaram/
│   │   ├── App/             # Entry point
│   │   ├── Core/            # VedicEngine, Localization
│   │   ├── Models/          # Data Structures
│   │   ├── UI/              # SwiftUI Views
│   │   ├── Resources/       # Assets, Strings
│   │   └── Widget/          # Watch Complications
│   └── Tests/
└── android/                 # [DEFERRED] Structure placeholder only
```

**Structure Decision**: Monorepo with `ios` and `android` top-level folders. Phase 1-3 focus exclusively on `ios`.

## Phases

### Phase 0: Research & Algorithms
- [ ] Research: Accurate Vedic Calculation Algorithms (Swift implementation)
- [ ] Research: Bhasha Engine Architecture (String Catalogs vs Custom)

### Phase 1: Core Architecture (iOS)
- [ ] **Goal**: Functional "Headless" Engine
- [ ] Implement `VedicTime` engine (Nazhigai calculation)
- [ ] Implement `DualDate` calendar logic (Gregorian <-> Vedic)
- [ ] Implement `LocationManager` with robust fallback (Manual Entry)
- [ ] Unit Tests for all calculations

### Phase 2: Visual Experience (iOS)
- [ ] **Goal**: Beautiful, Localized UI
- [ ] Implement `BhashaEngine` (In-app Language Switching)
- [ ] Build `NazhigaiWheel` (Custom Paint/Canvas or Shape)
- [ ] Build `DualDateHeader` (Dynamic Type supported)
- [ ] Integrate Custom Fonts (Noto Sans, Eczar)

### Phase 3: Integration & Watch (iOS)
- [ ] **Goal**: Device Ecosystem Support
- [ ] Tablet Logic (Scaling ViewModifier)
- [ ] Apple Watch Complications (WidgetKit shared code)
- [ ] End-to-End UI Tests

### Future (Deferred)
- [ ] Android Implementation (Kotlin/Compose)

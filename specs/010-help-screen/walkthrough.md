# Walkthrough: Help Screen

**Feature**: 010-help-screen

## Overview

Added a multilingual Help Screen to the Dashboard, accessible via the "..." menu. The screen renders Markdown content (`Help.md`) tailored to the app's selected language (English or Tamil).

Also resolved a bug in the language switcher interaction within the menu.

## Changes

### UI
- **DashboardView**: Added "Help" button to the menu and sheet presentation logic. Refactored menu into `menuBar` subview.
- **LanguageToggle**: Refactored to use `Picker` instead of `Button`+`Sheet` to resolve interaction issues inside `Menu`.
- **HelpView**: New view in **KadigaramCore** that renders Markdown content.

### Core Logic
- **HelpContentLoader**: New utility in `KadigaramCore` that loads `Help.md` from the module's localized resources using `Bundle.module`.
- **Resources**: Added `Help.md` files for `en` and `ta` localizations inside `KadigaramCore`.

### Configuration
- **Package.swift**: Defined `defaultLocalization: "en"` and enabled resource processing for `KadigaramCore`.

## Verification Results

### Automated Tests
- **Package Tests**: Verified `KadigaramCore` via `xcodebuild` (Exit code 0).
- **Build**: Successfully built `kadigaram` scheme (Exit code 0).

### Manual Verification
- **Help Button**: Verified presence in Dashboard menu.
- **Content Loading**: Verified Markdown rendering (headers, lists).
- **Localization**: Verified switching between English and Tamil updates content.
- **Fallback**: Verified fallback logic handles missing files gracefully (via Loader tests).

## Screenshots
[Add screenshots here if available]

## Modified Files
- `kadigaram/ios/Kadigaram/UI/Screens/DashboardView.swift`
- `kadigaram/ios/KadigaramCore/Sources/KadigaramCore/UI/Screens/HelpView.swift` [NEW]
- `kadigaram/ios/KadigaramCore/Sources/KadigaramCore/Loaders/HelpContentLoader.swift` [NEW]
- `kadigaram/ios/KadigaramCore/Sources/KadigaramCore/Resources/en.lproj/Help.md` [NEW]
- `kadigaram/ios/KadigaramCore/Sources/KadigaramCore/Resources/ta.lproj/Help.md` [NEW]
- `kadigaram/ios/KadigaramCore/Package.swift`

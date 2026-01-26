# Kadigaram

A Vedic Time and Calendar App for iOS.

## Features

- **Vedic Time Calculation**: Calculates Nazhigai regarding real sunrise/sunset.
- **Clock UI**: Interactive clock dial with:
  - 24h intervals from sunrise.
  - "Nazhigai" indicator sphere (Sun/Moon).
  - Modern time since sunrise display.
  - Adaptive layout for Portrait and Landscape.
- **Widget**: Home screen widget showing live time and Vedic details.
- **Languages**: Supports English and Tamil.
- **Theming**: Light and Dark mode with custom palettes.

## Architecture

- **Kadigaram**: Main iOS App (SwiftUI).
- **KadigaramWidget**: Widget Extension.
- **KadigaramCore**: Shared logic and models.
- **SixPartsLib**: Core calculation engine.

## New in Feature 006 (Clock UI Improvements)

- **Adaptive Layout**: Clock dial resizes and positions correctly in Landscape.
- **Theme System**: Consistent colors matching app icon (Maroon, Gold, Bronze).
- **Interactive Dial**:
  - Sun (day) and Moon (night) indicator.
  - 24h ticks aligned to sunrise.
- **Live Widget**: Updates every minute with battery-efficient timeline provider.

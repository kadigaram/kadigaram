# Data Model: Clock UI Improvements

**Feature**: Clock UI Improvements  
**Created**: 2026-01-24  
**Purpose**: Define data structures, configurations, and state models for UI enhancements

---

## Overview

This document defines the data models and configurations needed to implement the four clock UI improvements. These models are primarily concerned with presentation state and visual configuration rather than business logic.

---

## 1. Theme Configuration

### `ThemeConfiguration`

Manages color schemes and appearance settings for light and dark modes.

```swift
struct ThemeConfiguration {
    /// Current color scheme (light or dark)
    var colorScheme: ColorScheme
    
    /// Background colors for different modes
    var backgroundColors: BackgroundColors
    
    /// Text and UI element colors
    var foregroundColors: ForegroundColors
    
    /// Whether to respect system appearance settings
    var usesSystemAppearance: Bool
    
    /// Accessibility settings
    var accessibilitySettings: AccessibilitySettings
}

struct BackgroundColors {
    /// Primary background color for light mode
    let lightModeBackground: Color  // Color(.systemGray6)
    
    /// Primary background color for dark mode
    let darkModeBackground: Color   // Color(.systemBackground)
    
    /// Secondary background (for hierarchical UI)
    let secondaryBackground: Color  // Color(.secondarySystemBackground)
    
    /// Tertiary background (for cards, panels)
    let tertiaryBackground: Color   // Color(.tertiarySystemBackground)
    
    /// Computed property for current background based on color scheme
    func currentBackground(for scheme: ColorScheme) -> Color {
        scheme == .light ? lightModeBackground : darkModeBackground
    }
}

struct ForegroundColors {
    /// Primary text color (automatically adapts)
    let primaryText: Color          // Color(.label)
    
    /// Secondary text color (less prominent)
    let secondaryText: Color        // Color(.secondaryLabel)
    
    /// Accent color for interactive elements
    let accentColor: Color
}

struct AccessibilitySettings {
    /// Whether "Increase Contrast" is enabled
    var increaseContrast: Bool
    
    /// Whether "Reduce Transparency" is enabled
    var reduceTransparency: Bool
    
    /// Current Dynamic Type size category
    var dynamicTypeSize: DynamicTypeSize
    
    /// Whether "Reduce Motion" is enabled
    var reduceMotion: Bool
}
```

### Usage

```swift
// In App or View Model
@Environment(\.colorScheme) var colorScheme
@State private var theme = ThemeConfiguration.default

var body: some View {
    ZStack {
        theme.backgroundColors.currentBackground(for: colorScheme)
            .ignoresSafeArea()
        
        ClockDialView()
    }
}
```

---

## 2. Clock Dial Design

### `ClockDialDesign`

Defines visual properties for the clock dial to match app icon aesthetic.

```swift
struct ClockDialDesign {
    /// Color palette matching app icon
    var colorPalette: DialColorPalette
    
    /// Gradient configuration
    var gradientConfig: RadialGradientConfig
    
    /// Stroke and line styles
    var strokeStyles: DialStrokeStyles
    
    /// Geometric properties
    var geometry: DialGeometry
    
    /// Animation properties
    var animationConfig: DialAnimationConfig
}

struct DialColorPalette {
    /// Primary color (deep burgundy/maroon from icon)
    let primaryColor: Color         // #8B4513 or extracted from icon
    
    /// Secondary color (gold/amber accents from icon)
    let secondaryColor: Color       // #FFD700 or extracted from icon
    
    /// Center color for gradient
    let centerColor: Color
    
    /// Edge color for gradient
    let edgeColor: Color
    
    /// Accent colors for decorative elements
    let accentColors: [Color]
    
    /// Hour marker color
    let markerColor: Color
    
    /// Hand/indicator colors
    let indicatorColor: Color
}

struct RadialGradientConfig {
    /// Gradient colors (from center to edge)
    let colors: [Color]
    
    /// Center point (.center, or custom)
    let center: UnitPoint
    
    /// Start radius (typically 0 for center)
    let startRadius: CGFloat
    
    /// End radius (typically dial radius)
    let endRadius: CGFloat
    
    /// Optional gradient stops for precise control
    let stops: [Gradient.Stop]?
}

struct DialStrokeStyles {
    /// Outer ring stroke width
    let outerRingWidth: CGFloat     // e.g., 2.0
    
    /// Inner ring stroke width
    let innerRingWidth: CGFloat     // e.g., 1.0
    
    /// Hour marker stroke width
    let markerWidth: CGFloat        // e.g., 1.5
    
    /// Decorative element stroke width
    let decorativeWidth: CGFloat    // e.g., 0.5
    
    /// Line cap style
    let lineCap: CGLineCap          // .round, .square, .butt
    
    /// Line join style
    let lineJoin: CGLineJoin        // .round, .miter, .bevel
}

struct DialGeometry {
    /// Number of concentric rings
    let concentricRings: Int        // e.g., 3
    
    /// Spacing between rings (as percentage of radius)
    let ringSpacing: CGFloat        // e.g., 0.15
    
    /// Number of primary divisions (typically 12 for hours)
    let primaryDivisions: Int       // 12
    
    /// Number of secondary divisions (minute markers)
    let secondaryDivisions: Int     // 60
    
    /// Whether to show decorative elements at cardinal points
    let showCardinalDecorations: Bool
    
    /// Aspect ratio (1:1 for circular)
    let aspectRatio: CGFloat        // 1.0
}

struct DialAnimationConfig {
    /// Duration for hand rotation
    let handRotationDuration: Double    // 0.3 seconds
    
    /// Animation curve
    let animationCurve: Animation       // .easeInOut
    
    /// Whether hands animate continuously
    let smoothHandMovement: Bool        // false (discrete minute updates)
    
    /// Scale animation on appear
    let appearAnimation: Animation?     // .spring(response: 0.6)
}
```

### Usage

```swift
struct ClockDialView: View {
    let design: ClockDialDesign
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background gradient
                ClockDialShape()
                    .fill(
                        RadialGradient(
                            gradient: Gradient(colors: design.gradientConfig.colors),
                            center: design.gradientConfig.center,
                            startRadius: design.gradientConfig.startRadius,
                            endRadius: geometry.size.width / 2
                        )
                    )
                
                // Concentric rings
                ForEach(0..<design.geometry.concentricRings, id: \.self) { ringIndex in
                    ClockRingShape(index: ringIndex, design: design)
                        .stroke(
                            design.colorPalette.primaryColor.opacity(0.3),
                            lineWidth: design.strokeStyles.innerRingWidth
                        )
                }
                
                // Hour markers, hands, etc.
            }
        }
        .aspectRatio(design.geometry.aspectRatio, contentMode: .fit)
    }
}
```

---

## 3. Layout Configuration

### `LayoutConfiguration`

Manages adaptive layout for portrait and landscape orientations.

```swift
struct LayoutConfiguration {
    /// Current device orientation
    var orientation: DeviceOrientation
    
    /// Screen size class
    var sizeClass: SizeClassConfiguration
    
    /// Scaling factors for different orientations
    var scalingFactors: ScalingFactors
    
    /// Safe area management
    var safeAreaStrategy: SafeAreaStrategy
    
    /// Maximum dimensions
    var constraints: LayoutConstraints
}

enum DeviceOrientation {
    case portrait
    case landscape
    case portraitUpsideDown
    case unknown
    
    var isLandscape: Bool {
        self == .landscape
    }
}

struct SizeClassConfiguration {
    let horizontal: UserInterfaceSizeClass?
    let vertical: UserInterfaceSizeClass?
    
    var isLandscape: Bool {
        horizontal == .regular && vertical == .compact
    }
    
    var isPortrait: Bool {
        horizontal == .compact && vertical == .regular
    }
    
    var isIPadFullscreen: Bool {
        horizontal == .regular && vertical == .regular
    }
}

struct ScalingFactors {
    /// Percentage of screen height to use in landscape
    let landscapeHeightFactor: CGFloat  // 0.90 (90% of height)
    
    /// Percentage of screen width to use in portrait
    let portraitWidthFactor: CGFloat    // 0.75 (75% of width)
    
    /// Minimum size to maintain readability
    let minimumDialSize: CGFloat        // 200.0 points
    
    /// Maximum size to prevent over-scaling
    let maximumDialSize: CGFloat        // 600.0 points
    
    /// Padding around dial in landscape
    let landscapePadding: CGFloat       // 20.0 points
    
    /// Padding around dial in portrait
    let portraitPadding: CGFloat        // 40.0 points
}

enum SafeAreaStrategy {
    /// Fully respect all safe area insets
    case respectAll
    
    /// Respect only top and bottom (for edge-to-edge width)
    case respectVertical
    
    /// Respect only leading and trailing (for edge-to-edge height)
    case respectHorizontal
    
    /// Ignore safe areas (use with caution)
    case ignore
}

struct LayoutConstraints {
    /// Maximum height in landscape
    let maxLandscapeHeight: CGFloat?
    
    /// Maximum width in portrait
    let maxPortraitWidth: CGFloat?
    
    /// Minimum screen dimension to show full dial
    let minScreenDimension: CGFloat     // 320.0 (iPhone SE size)
    
    /// Aspect ratio to maintain (1:1 for circular dial)
    let targetAspectRatio: CGFloat      // 1.0
}
```

### Computed Values

```swift
extension LayoutConfiguration {
    /// Calculate dial size based on available geometry
    func dialSize(for geometry: GeometryProxy) -> CGSize {
        let availableWidth = geometry.size.width - safeAreaInsets(geometry).horizontal
        let availableHeight = geometry.size.height - safeAreaInsets(geometry).vertical
        
        var targetHeight: CGFloat
        var targetWidth: CGFloat
        
        if sizeClass.isLandscape {
            // Use maximum height in landscape
            targetHeight = availableHeight * scalingFactors.landscapeHeightFactor
            targetWidth = targetHeight // Maintain 1:1 aspect ratio
        } else {
            // Use proportional width in portrait
            targetWidth = availableWidth * scalingFactors.portraitWidthFactor
            targetHeight = targetWidth // Maintain 1:1 aspect ratio
        }
        
        // Apply constraints
        let constrainedHeight = min(
            max(targetHeight, scalingFactors.minimumDialSize),
            scalingFactors.maximumDialSize
        )
        
        return CGSize(width: constrainedHeight, height: constrainedHeight)
    }
    
    /// Calculate safe area insets based on strategy
    func safeAreaInsets(_ geometry: GeometryProxy) -> EdgeInsets {
        switch safeAreaStrategy {
        case .respectAll:
            return geometry.safeAreaInsets
        case .respectVertical:
            return EdgeInsets(
                top: geometry.safeAreaInsets.top,
                leading: 0,
                bottom: geometry.safeAreaInsets.bottom,
                trailing: 0
            )
        case .respectHorizontal:
            return EdgeInsets(
                top: 0,
                leading: geometry.safeAreaInsets.leading,
                bottom: 0,
                trailing: geometry.safeAreaInsets.trailing
            )
        case .ignore:
            return EdgeInsets()
        }
    }
}

extension EdgeInsets {
    var horizontal: CGFloat {
        leading + trailing
    }
    
    var vertical: CGFloat {
        top + bottom
    }
}
```

### Usage

```swift
struct AdaptiveClockDialView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @State private var layout = LayoutConfiguration.default
    
    var body: some View {
        GeometryReader { geometry in
            let dialSize = layout.dialSize(for: geometry)
            
            ClockDialView()
                .frame(width: dialSize.width, height: dialSize.height)
                .position(
                    x: geometry.size.width / 2,
                    y: geometry.size.height / 2
                )
        }
        .onChange(of: horizontalSizeClass) { _ in updateLayout() }
        .onChange(of: verticalSizeClass) { _ in updateLayout() }
    }
    
    func updateLayout() {
        layout.sizeClass = SizeClassConfiguration(
            horizontal: horizontalSizeClass,
            vertical: verticalSizeClass
        )
    }
}
```

---

## 4. Widget Timeline Configuration

### `WidgetTimelineConfiguration`

Manages widget update behavior and timeline entry generation.

```swift
struct WidgetTimelineConfiguration {
    /// Update interval for timeline entries (in minutes)
    let timelineIntervalMinutes: Int    // 15, 30, or 60
    
    /// Number of future entries to generate
    let numberOfEntries: Int            // 24 (one per hour for 24 hours)
    
    /// Timeline refresh policy
    let refreshPolicy: TimelineReloadPolicy
    
    /// Whether to use dynamic date formatting
    let useDynamicTimeDisplay: Bool     // true (always)
    
    /// Data update triggers
    let updateTriggers: [WidgetUpdateTrigger]
}

enum TimelineReloadPolicy {
    /// Reload after last timeline entry  
    case atEnd
    
    /// Reload at specific date
    case after(Date)
    
    /// Never reload automatically (manual only)
    case never
    
    /// Reload when app becomes active
    case onAppActive
}

enum WidgetUpdateTrigger {
    /// User changed location
    case locationChanged
    
    /// User changed language/locale
    case localeChanged
    
    /// significant astronomical event (Sankranti, new moon, etc.)
    case astronomicalEvent(Date)
    
    /// App settings changed
    case settingsChanged
    
    /// System time zone changed
    case timeZoneChanged
}

struct ClockWidgetEntry: TimelineEntry {
    /// Date for this timeline entry (required by TimelineEntry protocol)
    let date: Date
    
    /// Location name to display (changes less frequently than time)
    let locationName: String
    
    /// Current Vedic time information (updates hourly)
    let vedicTime: VedicTime?
    
    /// Current moon phase (updates daily)
    let moonPhase: MoonPhase?
    
    /// Nazhigai value (changes every ~24 minutes)
    let nazhigai: Int
    
    /// Tamil month and day
    let tamilDate: String?
}

struct WidgetDataCache {
    /// Shared UserDefaults container
    private let sharedDefaults: UserDefaults?
    
    /// App Group identifier
    private let appGroupIdentifier = "group.com.kadigaram.app"
    
    init() {
        sharedDefaults = UserDefaults(suiteName: appGroupIdentifier)
    }
    
    /// Save current location for widget access
    func saveLocation(_ location: LocationData) {
        sharedDefaults?.set(location.name, forKey: "widgetLocationName")
        sharedDefaults?.set(location.coordinate.latitude, forKey: "widgetLatitude")
        sharedDefaults?.set(location.coordinate.longitude, forKey: "widgetLongitude")
    }
    
    /// Retrieve location for widget
    func retrieveLocation() -> LocationData? {
        guard let name = sharedDefaults?.string(forKey: "widgetLocationName"),
              let lat = sharedDefaults?.double(forKey: "widgetLatitude"),
              let lon = sharedDefaults?.double(forKey: "widgetLongitude") else {
            return nil
        }
        return LocationData(name: name, latitude: lat, longitude: lon)
    }
    
    /// Notify widget to reload
    func triggerWidgetReload() {
        WidgetCenter.shared.reloadTimelines(ofKind: "KadigaramWidget")
    }
}
```

### Timeline Provider Implementation

```swift
struct ClockWidgetTimelineProvider: TimelineProvider {
    let configuration: WidgetTimelineConfiguration
    let dataCache: WidgetDataCache
    
    func getTimeline(
        in context: Context,
        completion: @escaping (Timeline<ClockWidgetEntry>) -> Void
    ) {
        let currentDate = Date()
        var entries: [ClockWidgetEntry] = []
        
        // Retrieve shared data
        let location = dataCache.retrieveLocation()
        
        // Generate entries at configured interval
        for i in 0..<configuration.numberOfEntries {
            let hours = i * (configuration.timelineIntervalMinutes / 60)
            guard let entryDate = Calendar.current.date(
                byAdding: .hour,
                value: hours,
                to: currentDate
            ) else { continue }
            
            // Calculate Vedic time and other data for this entry
            let vedicTime = VedicEngine.calculateTime(for: entryDate, at: location)
            let moonPhase = AstronomicalCalculator.moonPhase(for: entryDate)
            let nazhigai = vedicTime?.nazhigai ?? 0
            let tamilDate = vedicTime?.tamilDateString
            
            let entry = ClockWidgetEntry(
                date: entryDate,
                locationName: location?.name ?? "Unknown",
                vedicTime: vedicTime,
                moonPhase: moonPhase,
                nazhigai: nazhigai,
                tamilDate: tamilDate
            )
            entries.append(entry)
        }
        
        // Create timeline with configured refresh policy
        let timeline = Timeline(
            entries: entries,
            policy: mapPolicy(configuration.refreshPolicy)
        )
        completion(timeline)
    }
    
    private func mapPolicy(_ policy: TimelineReloadPolicy) -> TimelineReloadPolicy {
        switch policy {
        case .atEnd:
            return .atEnd
        case .after(let date):
            return .after(date)
        case .never:
            return .never
        case .onAppActive:
            return .atEnd // Fallback to atEnd
        }
    }
}
```

### Widget View with Dynamic Time

```swift
struct ClockWidgetEntryView: View {
    var entry: ClockWidgetEntry
    
    var body: some View {
        VStack(spacing: 8) {
            // This updates automatically every minute without new timeline entries!
            Text(entry.date, style: .time)
                .font(.system(size: 32, weight: .medium, design: .rounded))
                .foregroundColor(.primary)
            
            // Static content from timeline entry
            Text(entry.locationName)
                .font(.caption)
                .foregroundColor(.secondary)
            
            if let tamilDate = entry.tamilDate {
                Text(tamilDate)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
    }
}
```

---

## 5. Default Configurations

### Factory Methods

```swift
extension ThemeConfiguration {
    static var `default`: ThemeConfiguration {
        ThemeConfiguration(
            colorScheme: .light,
            backgroundColors: .default,
            foregroundColors: .default,
            usesSystemAppearance: true,
            accessibilitySettings: .default
        )
    }
}

extension ClockDialDesign {
    static var `default`: ClockDialDesign {
        ClockDialDesign(
            colorPalette: .iconMatched,
            gradientConfig: .radialFromCenter,
            strokeStyles: .standard,
            geometry: .traditional12Hour,
            animationConfig: .smooth
        )
    }
}

extension LayoutConfiguration {
    static var `default`: LayoutConfiguration {
        LayoutConfiguration(
            orientation: .portrait,
            sizeClass: SizeClassConfiguration(horizontal: .compact, vertical: .regular),
            scalingFactors: .default,
            safeAreaStrategy: .respectAll,
            constraints: .default
        )
    }
}

extension WidgetTimelineConfiguration {
    static var `default`: WidgetTimelineConfiguration {
        WidgetTimelineConfiguration(
            timelineIntervalMinutes: 60,  // One entry per hour
            numberOfEntries: 24,           // 24 hours ahead
            refreshPolicy: .atEnd,
            useDynamicTimeDisplay: true,
            updateTriggers: [.locationChanged, .settingsChanged, .timeZoneChanged]
        )
    }
}
```

---

## Summary

This data model defines four main configuration areas:

1. **ThemeConfiguration**: Manages colors and appearance settings
2. **ClockDialDesign**: Defines visual properties to match app icon
3. **LayoutConfiguration**: Handles adaptive layout for orientations
4. **WidgetTimelineConfiguration**: Manages widget update behavior

All models are designed to be:
- **Lightweight**: Minimal memory footprint
- **Immutable where possible**: Using `let` for constants
- **Testable**: Clear structure for unit testing
- **SwiftUI-friendly**: Integrates with `@State`, `@Environment`, etc.
- **Performance-conscious**: Avoid unnecessary recalculations

These models support the requirements defined in the specification while following iOS best practices and the project constitution.

//
//  ClockUI-API-Contracts.swift
//  Kadigaram - Clock UI Improvements
//
//  Feature: 006-clock-ui-improvements
//  Purpose: Swift API signatures for all modified and new components
//  Created: 2026-01-24
//

import SwiftUI
import WidgetKit

// MARK: - 1. Theme Management

/// Protocol for theme providers
protocol ThemeProviding {
    var backgroundColor: Color { get }
    var foregroundColor: Color { get }
    var accentColor: Color { get }
    
    func color(for scheme: ColorScheme) -> Color
}

/// Main app theme manager
@MainActor
class AppTheme: ObservableObject, ThemeProviding {
    // MARK: Published Properties
    
    @Published var colorScheme: ColorScheme
    @Published var usesSystemAppearance: Bool
    
    // MARK: Computed Properties
    
    var backgroundColor: Color { get }
    var foregroundColor: Color { get }
    var accentColor: Color { get }
    
    // MARK: Methods
    
    /// Returns appropriate background color for given color scheme
    /// - Parameter scheme: Light or dark color scheme
    /// - Returns: Background color matching the scheme
    func color(for scheme: ColorScheme) -> Color
    
    /// Updates theme when system appearance changes
    /// - Parameter newScheme: New color scheme from environment
    func updateColorScheme(_ newScheme: ColorScheme)
    
    /// Applies increased contrast settings for accessibility
    func applyIncreasedContrast()
    
    /// Resets to default theme settings
    func resetToDefaults()
}

// MARK: - 2. Clock Dial Components

/// Protocol for clock dial design configuration
protocol ClockDialDesignProviding {
    var colorPalette: DialColorPalette { get }
    var strokeStyles: DialStrokeStyles { get }
    var shouldAnimate: Bool { get }
}

/// View model for clock dial
@MainActor
class ClockDialViewModel: ObservableObject, ClockDialDesignProviding {
    // MARK: Published Properties
    
    @Published var currentTime: Date
    @Published var colorPalette: DialColorPalette
    @Published var strokeStyles: DialStrokeStyles
    @Published var shouldAnimate: Bool
    
    // MARK: Initialization
    
    init()
    init(design: ClockDialDesign)
    
    // MARK: Methods
    
    /// Updates clock dial with current time
    func updateTime()
    
    /// Calculates hour hand angle for current time
    /// - Returns: Angle in degrees (0-360)
    func hourHandAngle() -> Double
    
    /// Calculates minute hand angle for current time
    /// - Returns: Angle in degrees (0-360)
    func minuteHandAngle() -> Double
    
    /// Calculates second hand angle for current time
    /// - Returns: Angle in degrees (0-360)
    func secondHandAngle() -> Double
    
    /// Applies icon-matched design to dial
    /// - Parameter iconColors: Colors extracted from app icon
    func applyIconDesign(iconColors: [Color])
}

/// Custom shape for clock dial rendering
struct ClockDialShape: Shape {
    // MARK: Properties
    
    var design: ClockDialDesign
    var animatableData: Double { get set }
    
    // MARK: Shape Protocol
    
    /// Creates path for clock dial shape
    /// - Parameter rect: Rectangle to draw within
    /// - Returns: Path defining clock dial
    func path(in rect: CGRect) -> Path
}

/// Custom shape for individual clock ring (concentric circles)
struct ClockRingShape: Shape {
    // MARK: Properties
    
    var ringIndex: Int
    var design: ClockDialDesign
    
    // MARK: Shape Protocol
    
    func path(in rect: CGRect) -> Path
}

/// View for clock dial with all visual elements
struct ClockDialView: View {
    // MARK: Properties
    
    @ObservedObject var viewModel: ClockDialViewModel
    var design: ClockDialDesign
    
    // MARK: Initialization
    
    init(viewModel: ClockDialViewModel)
    init(design: ClockDialDesign)
    
    // MARK: Body
    
    var body: some View { get }
    
    // MARK: Private Helpers
    
    /// Renders the gradient background
    @ViewBuilder
    private var gradientBackground: some View { get }
    
    /// Renders concentric rings
    @ViewBuilder
    private var concentricRings: some View { get }
    
    /// Renders hour markers
    @ViewBuilder
    private var hourMarkers: some View { get }
    
    /// Renders clock hands
    @ViewBuilder
    private var clockHands: some View { get }
}

// MARK: - 3. Adaptive Layout

/// View modifier for adaptive layout based on orientation
struct AdaptiveLayoutModifier: ViewModifier {
    // MARK: Environment
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    // MARK: State
    
    @State private var configuration: LayoutConfiguration
    
    // MARK: Initialization
    
    init(configuration: LayoutConfiguration = .default)
    
    // MARK: ViewModifier Protocol
    
    func body(content: Content) -> some View
    
    // MARK: Helpers
    
    /// Determines if current layout is landscape
    var isLandscape: Bool { get }
    
    /// Calculates appropriate scaling factor
    /// - Parameter geometry: Geometry proxy with size information
    /// - Returns: Scale factor for current orientation
    func scalingFactor(for geometry: GeometryProxy) -> CGFloat
}

/// Extension to apply adaptive layout modifier easily
extension View {
    /// Applies adaptive layout that scales based on orientation
    /// - Parameter configuration: Layout configuration to use
    /// - Returns: View with adaptive layout applied
    func adaptiveLayout(
        configuration: LayoutConfiguration = .default
    ) -> some View
}

/// Helper view that wraps clock dial with adaptive layout
struct AdaptiveClockDialView: View {
    // MARK: Environment
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    // MARK: State
    
    @State private var layout: LayoutConfiguration
    @StateObject private var viewModel: ClockDialViewModel
    
    // MARK: Initialization
    
    init(layout: LayoutConfiguration = .default)
    init(viewModel: ClockDialViewModel, layout: LayoutConfiguration = .default)
    
    // MARK: Body
    
    var body: some View { get }
    
    // MARK: Helpers
    
    /// Calculates dial size for current geometry and orientation
    /// - Parameter geometry: Geometry proxy
    /// - Returns: Size for clock dial
    func dialSize(for geometry: GeometryProxy) -> CGSize
    
    /// Updates layout configuration when orientation changes
    func updateLayout()
}

// MARK: - 4. Widget Timeline Provider

/// Timeline provider for Kadigaram widget with live updates
struct KadigaramWidgetTimelineProvider: TimelineProvider {
    // MARK: Properties
    
    let configuration: WidgetTimelineConfiguration
    let dataCache: WidgetDataCache
    
    // MARK: Initialization
    
    init(
        configuration: WidgetTimelineConfiguration = .default,
        dataCache: WidgetDataCache = .shared
    )
    
    // MARK: TimelineProvider Protocol
    
    /// Provides placeholder entry for widget
    func placeholder(in context: Context) -> ClockWidgetEntry
    
    /// Provides snapshot entry for widget gallery
    func getSnapshot(
        in context: Context,
        completion: @escaping (ClockWidgetEntry) -> Void
    )
    
    /// Provides timeline with future entries
    func getTimeline(
        in context: Context,
        completion: @escaping (Timeline<ClockWidgetEntry>) -> Void
    )
    
    // MARK: Helper Methods
    
    /// Generates timeline entries for next N hours
    /// - Parameters:
    ///   - startDate: Starting date for timeline
    ///   - count: Number of entries to generate
    /// - Returns: Array of timeline entries
    func generateEntries(from startDate: Date, count: Int) -> [ClockWidgetEntry]
    
    /// Creates single timeline entry for specific date
    /// - Parameter date: Date for entry
    /// - Returns: Timeline entry
    func createEntry(for date: Date) -> ClockWidgetEntry
}

/// Data cache for sharing information between app and widget
@MainActor
class WidgetDataCache: ObservableObject {
    // MARK: Singleton
    
    static let shared: WidgetDataCache
    
    // MARK: Properties
    
    private let appGroupIdentifier: String
    private let sharedDefaults: UserDefaults?
    
    // MARK: Initialization
    
    init(appGroupIdentifier: String = "group.com.kadigaram.app")
    
    // MARK: Public Methods
    
    /// Saves location data for widget access
    /// - Parameter location: Location to save
    func saveLocation(_ location: LocationData)
    
    /// Retrieves location data for widget
    /// - Returns: Location data if available
    func retrieveLocation() -> LocationData?
    
    /// Saves Vedic time data for widget
    /// - Parameter vedicTime: Vedic time to save
    func saveVedicTime(_ vedicTime: VedicTime)
    
    /// Retrieves Vedic time data for widget
    /// - Returns: Vedic time if available
    func retrieveVedicTime() -> VedicTime?
    
    /// Triggers widget timeline reload
    func triggerWidgetReload()
    
    /// Triggers widget reload for specific kind
    /// - Parameter kind: Widget kind identifier
    func triggerWidgetReload(ofKind kind: String)
}

/// Widget entry view with dynamic time display
struct ClockWidgetEntryView: View {
    // MARK: Properties
    
    var entry: ClockWidgetEntry
    @Environment(\.widgetFamily) var widgetFamily
    
    // MARK: Initialization
    
    init(entry: ClockWidgetEntry)
    
    // MARK: Body
    
    @ViewBuilder
    var body: some View { get }
    
    // MARK: Size-Specific Views
    
    /// View for small widget size
    @ViewBuilder
    private var smallWidgetView: some View { get }
    
    /// View for medium widget size
    @ViewBuilder
    private var mediumWidgetView: some View { get }
    
    /// View for large widget size
    @ViewBuilder
    private var largeWidgetView: some View { get }
}

// MARK: - 5. Integration with Existing Components

/// Extension to DashboardView for theme support
extension DashboardView {
    /// Applies new theme to dashboard
    /// - Parameter theme: Theme to apply
    func applyTheme(_ theme: AppTheme)
    
    /// Handles orientation changes
    /// - Parameter orientation: New device orientation
    func handleOrientationChange(_ orientation: DeviceOrientation)
}

/// Extension to DualDateHeader for theme integration
extension DualDateHeader {
    /// Updates colors based on theme
    /// - Parameter theme: Current app theme
    func updateColors(from theme: AppTheme)
}

// MARK: - 6. Helper Extensions

/// Extension for Color extraction from app icon
extension UIImage {
    /// Extracts dominant colors from image
    /// - Parameter count: Number of colors to extract
    /// - Returns: Array of dominant colors
    func extractDominantColors(count: Int) -> [Color]
    
    /// Gets average color from image
    /// - Returns: Average color
    func averageColor() -> Color?
}

/// Extension for safe area calculations
extension GeometryProxy {
    /// Calculates usable size minus safe area insets
    var usableSize: CGSize { get }
    
    /// Calculates usable height minus safe area insets
    var usableHeight: CGFloat { get }
    
    /// Calculates usable width minus safe area insets
    var usableWidth: CGFloat { get }
}

// MARK: - 7. Configuration Defaults

/// Factory methods for default configurations
extension ThemeConfiguration {
    static var `default`: ThemeConfiguration { get }
}

extension ClockDialDesign {
    static var `default`: ClockDialDesign { get }
    static var iconMatched: ClockDialDesign { get }
}

extension LayoutConfiguration {
    static var `default`: LayoutConfiguration { get }
}

extension WidgetTimelineConfiguration {
    static var `default`: WidgetTimelineConfiguration { get }
    static var batteryEfficient: WidgetTimelineConfiguration { get }
}

// MARK: - 8. Testing Protocols

/// Protocol for testable theme providers
protocol TestableThemeProvider {
    func mockLightMode() -> ThemeConfiguration
    func mockDarkMode() -> ThemeConfiguration
    func mockIncreasedContrast() -> ThemeConfiguration
}

/// Protocol for testable layout configurations
protocol TestableLayoutProvider {
    func mockPortrait() -> LayoutConfiguration
    func mockLandscape() -> LayoutConfiguration
    func mockIPadFullScreen() -> LayoutConfiguration
}

// MARK: - End of Contracts

/*
 Usage Example:
 
 // In DashboardView
 @StateObject private var theme = AppTheme()
 @StateObject private var clockViewModel = ClockDialViewModel()
 
 var body: some View {
     ZStack {
         theme.backgroundColor
             .ignoresSafeArea()
         
         AdaptiveClockDialView(viewModel: clockViewModel)
             .adaptiveLayout()
     }
     .environmentObject(theme)
 }
 
 // In Widget
 struct KadigaramWidget: Widget {
     let kind = "KadigaramWidget"
     
     var body: some WidgetConfiguration {
         StaticConfiguration(
             kind: kind,
             provider: KadigaramWidgetTimelineProvider()
         ) { entry in
             ClockWidgetEntryView(entry: entry)
         }
         .configurationDisplayName("Kadigaram Clock")
         .description("Shows current time and Vedic calendar")
         .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
     }
 }
 */

//
//  ThemeConfiguration.swift
//  Kadigaram
//
//  Created for Feature 006: Clock UI Improvements
//  Task: T001 - Theme Configuration Data Structures
//

import SwiftUI

/// Manages color schemes and appearance settings for light and dark modes
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

/// Background color configuration for light and dark modes
struct BackgroundColors {
    /// Primary background color for light mode
    let lightModeBackground: Color
    
    /// Primary background color for dark mode
    let darkModeBackground: Color
    
    /// Secondary background (for hierarchical UI)
    let secondaryBackground: Color
    
    /// Tertiary background (for cards, panels)
    let tertiaryBackground: Color
    
    /// Computed property for current background based on color scheme
    func currentBackground(for scheme: ColorScheme) -> Color {
        scheme == .light ? lightModeBackground : darkModeBackground
    }
}

/// Foreground color configuration for text and UI elements
struct ForegroundColors {
    /// Primary text color (automatically adapts)
    let primaryText: Color
    
    /// Secondary text color (less prominent)
    let secondaryText: Color
    
    /// Accent color for interactive elements
    let accentColor: Color
}

/// Accessibility settings configuration
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

// MARK: - Default Configurations

extension ThemeConfiguration {
    /// Default theme configuration
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

extension BackgroundColors {
    /// Default background colors using iOS system colors
    static var `default`: BackgroundColors {
        BackgroundColors(
            // Light mode: 25% brightness grey (#404040 ≈ RGB 64, 64, 64)
            lightModeBackground: Color(red: 64/255, green: 64/255, blue: 64/255),
            darkModeBackground: Color(.systemBackground),
            secondaryBackground: Color(.secondarySystemBackground),
            tertiaryBackground: Color(.tertiarySystemBackground)
        )
    }
}

extension ForegroundColors {
    /// Default foreground colors with good contrast for dark grey background
    static var `default`: ForegroundColors {
        ForegroundColors(
            // Primary text: Soft off-white (#E8E8E8) - not pure white, easier on eyes
            primaryText: Color(red: 232/255, green: 232/255, blue: 232/255),
            // Secondary text: Medium light grey (#B0B0B0) - softer than primary
            secondaryText: Color(red: 176/255, green: 176/255, blue: 176/255),
            accentColor: .accentColor
        )
    }
}

extension AccessibilitySettings {
    /// Default accessibility settings
    static var `default`: AccessibilitySettings {
        AccessibilitySettings(
            increaseContrast: false,
            reduceTransparency: false,
            dynamicTypeSize: .large,
            reduceMotion: false
        )
    }
}

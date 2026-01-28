//
//  ThemeConfigurationTests.swift
//  KadigaramTests
//
//  Created for Feature 006: Clock UI Improvements
//  Task: T001 - Theme Configuration Data Structures Tests
//

import XCTest
import SwiftUI
@testable import Kadigaram

final class ThemeConfigurationTests: XCTestCase {
    
    // MARK: - ThemeConfiguration Tests
    
    func testThemeConfigurationInitialization() {
        // Given
        let colorScheme: ColorScheme = .light
        let backgroundColors = BackgroundColors.default
        let foregroundColors = ForegroundColors.default
        let accessibilitySettings = AccessibilitySettings.default
        
        // When
        let theme = ThemeConfiguration(
            colorScheme: colorScheme,
            backgroundColors: backgroundColors,
            foregroundColors: foregroundColors,
            usesSystemAppearance: true,
            accessibilitySettings: accessibilitySettings
        )
        
        // Then
        XCTAssertEqual(theme.colorScheme, .light)
        XCTAssertTrue(theme.usesSystemAppearance)
        XCTAssertNotNil(theme.backgroundColors)
        XCTAssertNotNil(theme.foregroundColors)
        XCTAssertNotNil(theme.accessibilitySettings)
    }
    
    func testDefaultThemeConfiguration() {
        // When
        let theme = ThemeConfiguration.default
        
        // Then
        XCTAssertEqual(theme.colorScheme, .light)
        XCTAssertTrue(theme.usesSystemAppearance)
        XCTAssertNotNil(theme.backgroundColors)
        XCTAssertNotNil(theme.foregroundColors)
        XCTAssertNotNil(theme.accessibilitySettings)
    }
    
    // MARK: - BackgroundColors Tests
    
    func testBackgroundColorsInitialization() {
        // Given
        let lightBackground = Color(.systemGray6)
        let darkBackground = Color(.systemBackground)
        let secondary = Color(.secondarySystemBackground)
        let tertiary = Color(.tertiarySystemBackground)
        
        // When
        let colors = BackgroundColors(
            lightModeBackground: lightBackground,
            darkModeBackground: darkBackground,
            secondaryBackground: secondary,
            tertiaryBackground: tertiary
        )
        
        // Then
        XCTAssertNotNil(colors.lightModeBackground)
        XCTAssertNotNil(colors.darkModeBackground)
        XCTAssertNotNil(colors.secondaryBackground)
        XCTAssertNotNil(colors.tertiaryBackground)
    }
    
    func testCurrentBackgroundForLightMode() {
        // Given
        let colors = BackgroundColors.default
        
        // When
        let currentColor = colors.currentBackground(for: .light)
        
        // Then
        XCTAssertEqual(currentColor, colors.lightModeBackground)
    }
    
    func testCurrentBackgroundForDarkMode() {
        // Given
        let colors = BackgroundColors.default
        
        // When
        let currentColor = colors.currentBackground(for: .dark)
        
        // Then
        XCTAssertEqual(currentColor, colors.darkModeBackground)
    }
    
    // MARK: - ForegroundColors Tests
    
    func testForegroundColorsInitialization() {
        // Given
        let primary = Color(.label)
        let secondary = Color(.secondaryLabel)
        let accent = Color.accentColor
        
        // When
        let colors = ForegroundColors(
            primaryText: primary,
            secondaryText: secondary,
            accentColor: accent
        )
        
        // Then
        XCTAssertNotNil(colors.primaryText)
        XCTAssertNotNil(colors.secondaryText)
        XCTAssertNotNil(colors.accentColor)
    }
    
    func testDefaultForegroundColors() {
        // When
        let colors = ForegroundColors.default
        
        // Then
        XCTAssertNotNil(colors.primaryText)
        XCTAssertNotNil(colors.secondaryText)
        XCTAssertNotNil(colors.accentColor)
    }
    
    // MARK: - AccessibilitySettings Tests
    
    func testAccessibilitySettingsInitialization() {
        // When
        let settings = AccessibilitySettings(
            increaseContrast: true,
            reduceTransparency: true,
            dynamicTypeSize: .large,
            reduceMotion: true
        )
        
        // Then
        XCTAssertTrue(settings.increaseContrast)
        XCTAssertTrue(settings.reduceTransparency)
        XCTAssertEqual(settings.dynamicTypeSize, .large)
        XCTAssertTrue(settings.reduceMotion)
    }
    
    func testDefaultAccessibilitySettings() {
        // When
        let settings = AccessibilitySettings.default
        
        // Then
        XCTAssertFalse(settings.increaseContrast)
        XCTAssertFalse(settings.reduceTransparency)
        XCTAssertEqual(settings.dynamicTypeSize, .large)
        XCTAssertFalse(settings.reduceMotion)
    }
    
    func testAccessibilitySettingsMutability() {
        // Given
        var settings = AccessibilitySettings.default
        
        // When
        settings.increaseContrast = true
        settings.reduceMotion = true
        
        // Then
        XCTAssertTrue(settings.increaseContrast)
        XCTAssertTrue(settings.reduceMotion)
    }
}

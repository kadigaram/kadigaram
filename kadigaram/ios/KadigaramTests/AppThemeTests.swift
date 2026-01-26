//
//  AppThemeTests.swift
//  KadigaramTests
//
//  Created for Feature 006: Clock UI Improvements
//  Task: T002 - AppTheme Class Tests
//

import XCTest
import SwiftUI
@testable import Kadigaram

@MainActor
final class AppThemeTests: XCTestCase {
    
    var theme: AppTheme!
    
    override func setUp() async throws {
        theme = AppTheme.default()
    }
    
    override func tearDown() async throws {
        theme = nil
    }
    
    // MARK: - Initialization Tests
    
    func testDefaultInitialization() {
        // When
        let theme = AppTheme.default()
        
        // Then
        XCTAssertEqual(theme.currentColorScheme, .light)
        XCTAssertNotNil(theme.configuration)
        XCTAssertFalse(theme.hasIncreasedContrast)
    }
    
    func testCustomInitialization() {
        // Given
        var config = ThemeConfiguration.default
        config.colorScheme = .dark
        
        // When
        let theme = AppTheme(configuration: config)
        
        // Then
        XCTAssertEqual(theme.currentColorScheme, .dark)
        XCTAssertEqual(theme.configuration.colorScheme, .dark)
    }
    
    func testFactoryMethodWithColorScheme() {
        // When
        let darkTheme = AppTheme.with(colorScheme: .dark)
        
        // Then
        XCTAssertEqual(darkTheme.currentColorScheme, .dark)
        XCTAssertEqual(darkTheme.configuration.colorScheme, .dark)
    }
    
    // MARK: - Color Method Tests
    
    func testColorForLightMode() {
        // When
        let color = theme.color(for: .light)
        
        // Then
        XCTAssertEqual(color, theme.configuration.backgroundColors.lightModeBackground)
    }
    
    func testColorForDarkMode() {
        // When
        let color = theme.color(for: .dark)
        
        // Then
        XCTAssertEqual(color, theme.configuration.backgroundColors.darkModeBackground)
    }
    
    // MARK: - Update Color Scheme Tests
    
    func testUpdateColorScheme() {
        // Given
        XCTAssertEqual(theme.currentColorScheme, .light)
        
        // When
        theme.updateColorScheme(.dark)
        
        // Then
        XCTAssertEqual(theme.currentColorScheme, .dark)
        XCTAssertEqual(theme.configuration.colorScheme, .dark)
    }
    
    func testUpdateColorSchemeMultipleTimes() {
        // When
        theme.updateColorScheme(.dark)
        theme.updateColorScheme(.light)
        theme.updateColorScheme(.dark)
        
        // Then
        XCTAssertEqual(theme.currentColorScheme, .dark)
        XCTAssertEqual(theme.configuration.colorScheme, .dark)
    }
    
    // MARK: - Accessibility Settings Tests
    
    func testUpdateAccessibilitySettings() {
        // When
        theme.updateAccessibilitySettings(
            increaseContrast: true,
            reduceTransparency: true,
            dynamicTypeSize: .xLarge,
            reduceMotion: true
        )
        
        // Then
        XCTAssertTrue(theme.configuration.accessibilitySettings.increaseContrast)
        XCTAssertTrue(theme.configuration.accessibilitySettings.reduceTransparency)
        XCTAssertEqual(theme.configuration.accessibilitySettings.dynamicTypeSize, .xLarge)
        XCTAssertTrue(theme.configuration.accessibilitySettings.reduceMotion)
        XCTAssertTrue(theme.hasIncreasedContrast)
    }
    
    func testShouldReduceMotion() {
        // Given
        XCTAssertFalse(theme.shouldReduceMotion)
        
        // When
        theme.updateAccessibilitySettings(
            increaseContrast: false,
            reduceTransparency: false,
            dynamicTypeSize: .large,
            reduceMotion: true
        )
        
        // Then
        XCTAssertTrue(theme.shouldReduceMotion)
    }
    
    // MARK: - Computed Properties Tests
    
    func testBackgroundColorProperty() {
        // Given
        theme.updateColorScheme(.light)
        
        // When
        let bgColor = theme.backgroundColor
        
        // Then
        XCTAssertEqual(bgColor, theme.configuration.backgroundColors.lightModeBackground)
    }
    
    func testForegroundColorProperty() {
        // When
        let fgColor = theme.foregroundColor
        
        // Then
        XCTAssertEqual(fgColor, theme.configuration.foregroundColors.primaryText)
    }
    
    func testSecondaryForegroundColorProperty() {
        // When
        let secondaryColor = theme.secondaryForegroundColor
        
        // Then
        XCTAssertEqual(secondaryColor, theme.configuration.foregroundColors.secondaryText)
    }
    
    func testAccentColorProperty() {
        // When
        let accentColor = theme.accentColor
        
        // Then
        XCTAssertEqual(accentColor, theme.configuration.foregroundColors.accentColor)
    }
    
    // MARK: - Integration Tests
    
    func testThemeColorChangesWithScheme() {
        // Given
        theme.updateColorScheme(.light)
        let lightBg = theme.backgroundColor
        
        // When
        theme.updateColorScheme(.dark)
        let darkBg = theme.backgroundColor
        
        // Then
        XCTAssertNotEqual(lightBg, darkBg)
    }
}

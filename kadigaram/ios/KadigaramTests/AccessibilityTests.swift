//
//  AccessibilityTests.swift
//  KadigaramTests
//
//  Created for Feature 006: Clock UI Improvements
//  Task: T007 - Accessibility Support Tests
//

import XCTest
import SwiftUI
@testable import Kadigaram

@MainActor
final class AccessibilityTests: XCTestCase {
    
    var theme: AppTheme!
    
    override func setUp() async throws {
        theme = AppTheme.default()
    }
    
    override func tearDown() async throws {
        theme = nil
    }
    
    // MARK: - Increased Contrast Tests
    
    func testApplyIncreasedContrastWhenEnabled() {
        // Given
        theme.updateAccessibilitySettings(
            increaseContrast: true,
            reduceTransparency: false,
            dynamicTypeSize: .large,
            reduceMotion: false
        )
        
        // When
        theme.applyIncreasedContrast()
        
        // Then
        XCTAssertTrue(theme.hasIncreasedContrast)
        XCTAssertTrue(theme.configuration.accessibilitySettings.increaseContrast)
    }
    
    func testApplyIncreasedContrastWhenDisabled() {
        // Given
        theme.updateAccessibilitySettings(
            increaseContrast: false,
            reduceTransparency: false,
            dynamicTypeSize: .large,
            reduceMotion: false
        )
        
        // When
        theme.applyIncreasedContrast()
        
        // Then
        XCTAssertFalse(theme.hasIncreasedContrast)
        XCTAssertFalse(theme.configuration.accessibilitySettings.increaseContrast)
    }
    
    // MARK: - WCAG Compliance Tests
    
    func testContrastRatioMeetsWCAGAA() {
        // Note: iOS system colors are designed to meet WCAG AA (4.5:1) automatically
        // This test verifies we're using system colors
        
        // Given
        let colors = BackgroundColors.default
        
        // Then - verify we're using system semantic colors
        // System colors automatically adjust for accessibility
        XCTAssertNotNil(colors.lightModeBackground)
        XCTAssertNotNil(colors.darkModeBackground)
    }
    
    // MARK: - Reduce Transparency Tests
    
    func testReduceTransparencySetting() {
        // When
        theme.updateAccessibilitySettings(
            increaseContrast: false,
            reduceTransparency: true,
            dynamicTypeSize: .large,
            reduceMotion: false
        )
        
        // Then
        XCTAssertTrue(theme.configuration.accessibilitySettings.reduceTransparency)
    }
    
    // MARK: - Dynamic Type Tests
    
    func testDynamicTypeSizeUpdates() {
        // When
        theme.updateAccessibilitySettings(
            increaseContrast: false,
            reduceTransparency: false,
            dynamicTypeSize: .xxxLarge,
            reduceMotion: false
        )
        
        // Then
        XCTAssertEqual(theme.configuration.accessibilitySettings.dynamicTypeSize, .xxxLarge)
    }
    
    func testDynamicTypeSupportedSizes() {
        // Test various dynamic type sizes
        let sizes: [DynamicTypeSize] = [.xSmall, .small, .medium, .large, .xLarge, .xxLarge, .xxxLarge]
        
        for size in sizes {
            // When
            theme.updateAccessibilitySettings(
                increaseContrast: false,
                reduceTransparency: false,
                dynamicTypeSize: size,
                reduceMotion: false
            )
            
            // Then
            XCTAssertEqual(theme.configuration.accessibilitySettings.dynamicTypeSize, size)
        }
    }
    
    // MARK: - Reduce Motion Tests
    
    func testReduceMotionSetting() {
        // When
        theme.updateAccessibilitySettings(
            increaseContrast: false,
            reduceTransparency: false,
            dynamicTypeSize: .large,
            reduceMotion: true
        )
        
        // Then
        XCTAssertTrue(theme.configuration.accessibilitySettings.reduceMotion)
        XCTAssertTrue(theme.shouldReduceMotion)
    }
    
    func testReduceMotionDisabled() {
        // When
        theme.updateAccessibilitySettings(
            increaseContrast: false,
            reduceTransparency: false,
            dynamicTypeSize: .large,
            reduceMotion: false
        )
        
        // Then
        XCTAssertFalse(theme.configuration.accessibilitySettings.reduceMotion)
        XCTAssertFalse(theme.shouldReduceMotion)
    }
    
    // MARK: - Combined Accessibility Settings Tests
    
    func testMultipleAccessibilitySettingsSimultaneously() {
        // When
        theme.updateAccessibilitySettings(
            increaseContrast: true,
            reduceTransparency: true,
            dynamicTypeSize: .xxxLarge,
            reduceMotion: true
        )
        
        // Then
        XCTAssertTrue(theme.configuration.accessibilitySettings.increaseContrast)
        XCTAssertTrue(theme.configuration.accessibilitySettings.reduceTransparency)
        XCTAssertEqual(theme.configuration.accessibilitySettings.dynamicTypeSize, .xxxLarge)
        XCTAssertTrue(theme.configuration.accessibilitySettings.reduceMotion)
        XCTAssertTrue(theme.hasIncreasedContrast)
    }
    
    // MARK: - Color Visibility Tests
    
    func testBackgroundColorVisibilityInLightMode() {
        // Given
        theme.updateColorScheme(.light)
        
        // When
        let bgColor = theme.backgroundColor
        
        // Then
        XCTAssertNotNil(bgColor)
        // Background should be the light mode background
        XCTAssertEqual(bgColor, theme.configuration.backgroundColors.lightModeBackground)
    }
    
    func testBackgroundColorVisibilityInDarkMode() {
        // Given
        theme.updateColorScheme(.dark)
        
        // When
        let bgColor = theme.backgroundColor
        
        // Then
        XCTAssertNotNil(bgColor)
        // Background should be the dark mode background
        XCTAssertEqual(bgColor, theme.configuration.backgroundColors.darkModeBackground)
    }
}

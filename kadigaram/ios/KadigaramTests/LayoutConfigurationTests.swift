//
//  LayoutConfigurationTests.swift
//  KadigaramTests
//
//  Created for Feature 006: Clock UI Improvements
//  Task: T017 - Layout Configuration Tests
//

import XCTest
import SwiftUI
@testable import Kadigaram

final class LayoutConfigurationTests: XCTestCase {
    
    // MARK: - Dial Size Calculation Tests
    
    func testDialSizeInLandscape() {
        // Given
        let config = LayoutConfiguration(
            scalingFactors: ScalingFactors(
                landscapeHeightFactor: 0.9,
                portraitWidthFactor: 0.8,
                minimumDialSize: 100,
                maximumDialSize: 1000,
                landscapePadding: 10,
                portraitPadding: 20
            )
        )
        
        // Simulating iPhone landscape: Width > Height
        let availableSize = CGSize(width: 800, height: 400)
        
        // When
        let size = config.dialSize(for: availableSize)
        
        // Then
        // Expected: height * factor - padding * 2
        // 400 * 0.9 - 20 = 360 - 20 = 340
        XCTAssertEqual(size, 340.0, accuracy: 0.1)
    }
    
    func testDialSizeInPortrait() {
        // Given
        let config = LayoutConfiguration(
            scalingFactors: ScalingFactors(
                landscapeHeightFactor: 0.9,
                portraitWidthFactor: 0.8,
                minimumDialSize: 100,
                maximumDialSize: 1000,
                landscapePadding: 10,
                portraitPadding: 20
            )
        )
        
        // Simulating iPhone portrait: Width < Height
        let availableSize = CGSize(width: 400, height: 800)
        
        // When
        let size = config.dialSize(for: availableSize)
        
        // Then
        // Expected: width * factor - padding * 2
        // 400 * 0.8 - 40 = 320 - 40 = 280
        XCTAssertEqual(size, 280.0, accuracy: 0.1)
    }
    
    func testMinimumSizeConstraint() {
        // Given
        let config = LayoutConfiguration(
            scalingFactors: ScalingFactors(
                landscapeHeightFactor: 0.5,
                portraitWidthFactor: 0.5,
                minimumDialSize: 300,  // High minimum
                maximumDialSize: 1000,
                landscapePadding: 0,
                portraitPadding: 0
            )
        )
        
        let availableSize = CGSize(width: 400, height: 400)
        
        // When
        let size = config.dialSize(for: availableSize)
        
        // Then
        // Calc: 400 * 0.5 = 200. But min is 300.
        XCTAssertEqual(size, 300.0, accuracy: 0.1)
    }
    
    func testMaximumSizeConstraint() {
        // Given
        let config = LayoutConfiguration(
            scalingFactors: ScalingFactors(
                landscapeHeightFactor: 1.0,
                portraitWidthFactor: 1.0,
                minimumDialSize: 100,
                maximumDialSize: 500,  // Low maximum
                landscapePadding: 0,
                portraitPadding: 0
            )
        )
        
        let availableSize = CGSize(width: 1000, height: 1000)
        
        // When
        let size = config.dialSize(for: availableSize)
        
        // Then
        // Calc: 1000. But max is 500.
        XCTAssertEqual(size, 500.0, accuracy: 0.1)
    }
    
    // MARK: - Size Class Tests
    
    func testSizeClassDetection() {
        // Given
        let portraitPhone = SizeClassConfiguration(horizontal: .compact, vertical: .regular)
        let landscapePhone = SizeClassConfiguration(horizontal: .compact, vertical: .compact)
        let landscapeMaxPhone = SizeClassConfiguration(horizontal: .regular, vertical: .compact)
        let ipad = SizeClassConfiguration(horizontal: .regular, vertical: .regular)
        
        // Then
        XCTAssertTrue(portraitPhone.isPortrait)
        XCTAssertFalse(portraitPhone.isLandscapeCompact)
        
        XCTAssertTrue(landscapePhone.isLandscapeCompact)
        XCTAssertFalse(landscapePhone.isPortrait)
        
        XCTAssertTrue(landscapeMaxPhone.isLandscapeCompact)
        XCTAssertFalse(landscapeMaxPhone.isPortrait)
        
        XCTAssertTrue(ipad.isRegular)
        XCTAssertFalse(ipad.isLandscapeCompact) // iPad layout is different
    }
}

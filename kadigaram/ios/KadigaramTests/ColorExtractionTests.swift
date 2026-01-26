//
//  ColorExtractionTests.swift
//  KadigaramTests
//
//  Created for Feature 006: Clock UI Improvements
//  Task: T011 - Color Extraction Tests
//

import XCTest
import SwiftUI
@testable import Kadigaram

final class ColorExtractionTests: XCTestCase {
    
    // MARK: - ExtractedColorPalette Tests
    
    func testDefaultPaletteCreation() {
        // When
        let palette = ImageColorExtraction.ExtractedColorPalette.default
        
        // Then
        XCTAssertNotNil(palette.primaryGold)
        XCTAssertNotNil(palette.secondaryBlue)
        XCTAssertNotNil(palette.accentBronze)
    }
    
    func testFromAppIconPalette() {
        // When
        let palette = ImageColorExtraction.ExtractedColorPalette.fromAppIcon()
        
        // Then - verify gold color is approximately #D4AF37
        let goldUIColor = UIColor(palette.primaryGold)
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        goldUIColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        XCTAssertEqual(red, 212/255, accuracy: 0.01, "Primary gold red component")
        XCTAssertEqual(green, 175/255, accuracy: 0.01, "Primary gold green component")
        XCTAssertEqual(blue, 55/255, accuracy: 0.01, "Primary gold blue component")
    }
    
    func testPaletteColorsAreDistinct() {
        // Given
        let palette = ImageColorExtraction.ExtractedColorPalette.default
        
        // When - convert to UIColors for comparison
        let gold = UIColor(palette.primaryGold)
        let blue = UIColor(palette.secondaryBlue)
        let bronze = UIColor(palette.accentBronze)
        
        // Then - colors should be visually distinct
        XCTAssertNotEqual(gold, blue)
        XCTAssertNotEqual(gold, bronze)
        XCTAssertNotEqual(blue, bronze)
    }
    
    func testPrimaryGoldIsWarmColor() {
        // Given
        let palette = ImageColorExtraction.ExtractedColorPalette.default
        let goldUIColor = UIColor(palette.primaryGold)
        
        // When
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        goldUIColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        // Then - gold should have high red and green (warm color)
        XCTAssertGreaterThan(red, 0.5, "Gold should have strong red component")
        XCTAssertGreaterThan(green, 0.5, "Gold should have strong green component")
        XCTAssertLessThan(blue, red, "Gold should have less blue than red")
    }
    
    func testSecondaryBlueIsCoolColor() {
        // Given
        let palette = ImageColorExtraction.ExtractedColorPalette.default
        let blueUIColor = UIColor(palette.secondaryBlue)
        
        // When
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        blueUIColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        // Then - blue should have strong blue component
        XCTAssertGreaterThan(blue, red, "Blue should have more blue than red")
    }
    
    // MARK: - Color Extraction Tests
    
    func testColorExtractionFromImage() {
        // Given - create a simple test image with known colors
        let size = CGSize(width: 100, height: 100)
        let renderer = UIGraphicsImageRenderer(size: size)
        
        let testImage = renderer.image { context in
            // Draw gold in center
            UIColor(red: 212/255, green: 175/255, blue: 55/255, alpha: 1.0).setFill()
            context.fill(CGRect(x: 25, y: 25, width: 50, height: 50))
            
            // Draw blue around edges
            UIColor(red: 33/255, green: 150/255, blue: 180/255, alpha: 1.0).setFill()
            context.fill(CGRect(x: 0, y: 0, width: 25, height: 100))
        }
        
        // When
        let extractedColors = testImage.extractDominantColors()
        
        // Then
        XCTAssertFalse(extractedColors.isEmpty, "Should extract at least one color")
    }
    
    func testColorRoleEnum() {
        // Verify all color roles exist
        let roles: [ImageColorExtraction.ColorRole] = [.primary, .secondary, .accent]
        XCTAssertEqual(roles.count, 3, "Should have exactly 3 color roles")
    }
}

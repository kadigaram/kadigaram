//
//  ImageColorExtraction.swift
//  Kadigaram
//
//  Created for Feature 006: Clock UI Improvements
//  Task: T011 - Extract Colors from App Icon
//

import UIKit
import SwiftUI

/// Utility for extracting dominant colors from images
extension UIImage {
    /// Extract dominant colors from the image
    /// - Returns: Dictionary of color roles with their RGB values
    /// Extract dominant colors from the image
    /// - Returns: Dictionary of color roles with their RGB values
    func extractDominantColors() -> [ImageColorExtraction.ColorRole: UIColor] {
        var colors: [ImageColorExtraction.ColorRole: UIColor] = [:]
        
        // Sample colors from strategic points in the icon
        guard let cgImage = self.cgImage else { return colors }
        
        let width = cgImage.width
        let height = cgImage.height
        
        // Create a bitmap context
        let bytesPerPixel = 4
        let bytesPerRow = bytesPerPixel * width
        let bitsPerComponent = 8
        var pixelData = [UInt8](repeating: 0, count: width * height * bytesPerPixel)
        
        guard let context = CGContext(
            data: &pixelData,
            width: width,
            height: height,
            bitsPerComponent: bitsPerComponent,
            bytesPerRow: bytesPerRow,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        ) else { return colors }
        
        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        // Extract colors from specific regions
        // Center region (for primary gold sun color)
        if let centerColor = averageColor(in: CGRect(x: width/2 - 50, y: height/2 - 50, width: 100, height: 100), data: pixelData, width: width, bytesPerPixel: bytesPerPixel) {
            colors[.primary] = centerColor
        }
        
        // Mid-ring region (for blue background)
        if let midColor = averageColor(in: CGRect(x: width/4, y: height/2 - 20, width: 50, height: 40), data: pixelData, width: width, bytesPerPixel: bytesPerPixel) {
            colors[.secondary] = midColor
        }
        
        // Outer ring region (for bronze/copper)
        if let outerColor = averageColor(in: CGRect(x: 20, y: height/2 - 20, width: 40, height: 40), data: pixelData, width: width, bytesPerPixel: bytesPerPixel) {
            colors[.accent] = outerColor
        }
        
        return colors
    }
    
    /// Calculate average color in a specific region
    private func averageColor(in rect: CGRect, data: [UInt8], width: Int, bytesPerPixel: Int) -> UIColor? {
        var totalRed = 0
        var totalGreen = 0
        var totalBlue = 0
        var pixelCount = 0
        
        let minX = Int(rect.minX)
        let maxX = Int(rect.maxX)
        let minY = Int(rect.minY)
        let maxY = Int(rect.maxY)
        
        for y in minY..<maxY {
            for x in minX..<maxX {
                let offset = (y * width + x) * bytesPerPixel
                if offset + 3 < data.count {
                    totalRed += Int(data[offset])
                    totalGreen += Int(data[offset + 1])
                    totalBlue += Int(data[offset + 2])
                    pixelCount += 1
                }
            }
        }
        
        guard pixelCount > 0 else { return nil }
        
        return UIColor(
            red: CGFloat(totalRed) / CGFloat(pixelCount) / 255.0,
            green: CGFloat(totalGreen) / CGFloat(pixelCount) / 255.0,
            blue: CGFloat(totalBlue) / CGFloat(pixelCount) / 255.0,
            alpha: 1.0
        )
    }
}

/// Namespace for image color extraction utilities
enum ImageColorExtraction {
    /// Color roles for the dial design
    enum ColorRole {
        case primary    // Gold/amber for sun and accents
        case secondary  // Blue for background
        case accent     // Bronze/copper for rings
    }
    
    /// Color palette extracted from app icon
    struct ExtractedColorPalette {
        /// Primary gold color for sun and main accents
        let primaryGold: Color
        
        /// Secondary teal/blue color for background
        let secondaryBlue: Color
        
        /// Accent bronze/copper color for rings and details
        let accentBronze: Color
        
        /// Create palette from app icon
        static func fromAppIcon() -> ExtractedColorPalette {
            // Default colors based on visual inspection of the icon
            // These match the Kadigaram app icon colors
            return ExtractedColorPalette(
                primaryGold: Color(red: 212/255, green: 175/255, blue: 55/255),      // #D4AF37
                secondaryBlue: Color(red: 33/255, green: 150/255, blue: 180/255),    // #2196B4
                accentBronze: Color(red: 140/255, green: 110/255, blue: 70/255)      // #8C6E46
            )
        }
        
        /// Create palette from extracted UIColors
        static func fromExtractedColors(_ colors: [ColorRole: UIColor]) -> ExtractedColorPalette {
            let primary = colors[.primary].map { Color($0) } ?? Color(red: 212/255, green: 175/255, blue: 55/255)
            let secondary = colors[.secondary].map { Color($0) } ?? Color(red: 33/255, green: 150/255, blue: 180/255)
            let accent = colors[.accent].map { Color($0) } ?? Color(red: 140/255, green: 110/255, blue: 70/255)
            
            return ExtractedColorPalette(
                primaryGold: primary,
                secondaryBlue: secondary,
                accentBronze: accent
            )
        }
        
        /// Default palette using predefined colors from icon
        static var `default`: ExtractedColorPalette {
            return fromAppIcon()
        }
    }
}

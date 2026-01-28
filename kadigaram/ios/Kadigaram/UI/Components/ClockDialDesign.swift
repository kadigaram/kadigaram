//
//  ClockDialDesign.swift
//  Kadigaram
//
//  Created for Feature 006: Clock UI Improvements
//  Task: T012 - Clock Dial Data Structures
//

import SwiftUI

/// Defines visual properties for the clock dial to match app icon aesthetic
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

/// Color palette for clock dial (now uses extracted colors from app icon)
struct DialColorPalette {
    /// Primary gold color (from sun rays in icon)
    let primaryGold: Color
    
    /// Secondary blue color (from background circle in icon)
    let secondaryBlue: Color
    
    /// Accent bronze color (from outer ring in icon)
    let accentBronze: Color
    
    /// Center color for gradient
    let centerColor: Color
    
    /// Edge color for gradient
    let edgeColor: Color
    
    /// Hour marker color
    let markerColor: Color
    
    /// Hand/indicator colors
    let indicatorColor: Color
    
    /// Initialize from extracted app icon colors
    init(fromExtractedPalette palette: ImageColorExtraction.ExtractedColorPalette) {
        self.primaryGold = palette.primaryGold
        self.secondaryBlue = palette.secondaryBlue
        self.accentBronze = palette.accentBronze
        
        // Derive gradient and marker colors
        self.centerColor = palette.secondaryBlue
        self.edgeColor = palette.secondaryBlue.opacity(0.6)
        self.markerColor = palette.primaryGold
        self.indicatorColor = palette.primaryGold
    }
    
    /// Custom initializer for all colors
    init(
        primaryGold: Color,
        secondaryBlue: Color,
        accentBronze: Color,
        centerColor: Color,
        edgeColor: Color,
        markerColor: Color,
        indicatorColor: Color
    ) {
        self.primaryGold = primaryGold
        self.secondaryBlue = secondaryBlue
        self.accentBronze = accentBronze
        self.centerColor = centerColor
        self.edgeColor = edgeColor
        self.markerColor = markerColor
        self.indicatorColor = indicatorColor
    }
}

/// Radial gradient configuration for clock dial background
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

/// Stroke styles for clock dial elements
struct DialStrokeStyles {
    /// Outer ring stroke width
    let outerRingWidth: CGFloat
    
    /// Inner ring stroke width
    let innerRingWidth: CGFloat
    
    /// Hour marker stroke width
    let markerWidth: CGFloat
    
    /// Decorative element stroke width
    let decorativeWidth: CGFloat
    
    /// Line cap style
    let lineCap: CGLineCap
    
    /// Line join style
    let lineJoin: CGLineJoin
}

/// Geometric properties of the clock dial
struct DialGeometry {
    /// Number of concentric rings
    let concentricRings: Int
    
    /// Spacing between rings (as percentage of radius)
    let ringSpacing: CGFloat
    
    /// Number of primary divisions (typically 12 for hours)
    let primaryDivisions: Int
    
    /// Number of secondary divisions (minute markers)
    let secondaryDivisions: Int
    
    /// Whether to show decorative elements at cardinal points
    let showCardinalDecorations: Bool
    
    /// Aspect ratio (1:1 for circular)
    let aspectRatio: CGFloat
}

/// Animation configuration for clock dial
struct DialAnimationConfig {
    /// Duration for hand rotation
    let handRotationDuration: Double
    
    /// Animation curve
    let animationCurve: Animation
    
    /// Whether hands animate continuously
    let smoothHandMovement: Bool
    
    /// Scale animation on appear
    let appearAnimation: Animation?
}

// MARK: - Default Configurations

extension ClockDialDesign {
    /// Ancient Indian Copper Plate design
    static var copperPlate: ClockDialDesign {
        let palette = DialColorPalette(
            primaryGold: Color(red: 212/255, green: 175/255, blue: 55/255),    // Gold accents
            secondaryBlue: Color(red: 60/255, green: 40/255, blue: 20/255),    // Dark Brown/Copper Patina base
            accentBronze: Color(red: 184/255, green: 115/255, blue: 51/255),   // Copper Ring
            centerColor: Color(red: 75/255, green: 54/255, blue: 33/255),      // Lighter copper center
            edgeColor: Color(red: 45/255, green: 30/255, blue: 15/255),        // Dark edge
            markerColor: Color(red: 212/255, green: 175/255, blue: 55/255),    // Gold markers
            indicatorColor: Color(red: 255/255, green: 215/255, blue: 0/255)   // Bright gold indicator
        )
        
        return ClockDialDesign(
            colorPalette: palette,
            gradientConfig: RadialGradientConfig(
                colors: [
                    Color(red: 184/255, green: 115/255, blue: 51/255).opacity(0.3), // Copper tint
                    Color(red: 45/255, green: 30/255, blue: 15/255)                 // Dark edge
                ],
                center: .center,
                startRadius: 0,
                endRadius: 200,
                stops: nil
            ),
            strokeStyles: .default,
            geometry: DialGeometry(
                concentricRings: 4, // More rings for "plate" look
                ringSpacing: 0.12,
                primaryDivisions: 12,
                secondaryDivisions: 60,
                showCardinalDecorations: true,
                aspectRatio: 1.0
            ),
            animationConfig: .default
        )
    }

    /// Default clock dial design (Updated to Copper Plate)
    static var `default`: ClockDialDesign {
        return copperPlate
    }
}

extension RadialGradientConfig {
    static var `default`: RadialGradientConfig {
        RadialGradientConfig(
            colors: [
                Color(red: 75/255, green: 54/255, blue: 33/255),  // Copper Brown
                Color(red: 30/255, green: 20/255, blue: 10/255)   // Dark Edge
            ],
            center: .center,
            startRadius: 0,
            endRadius: 200,  // Will be overridden by actual size
            stops: nil
        )
    }
}

extension DialStrokeStyles {
    static var `default`: DialStrokeStyles {
        DialStrokeStyles(
            outerRingWidth: 4.0, // Thicker for plate look
            innerRingWidth: 1.5,
            markerWidth: 2.0,
            decorativeWidth: 1.0,
            lineCap: .round,
            lineJoin: .round
        )
    }
}

extension DialGeometry {
    static var `default`: DialGeometry {
        DialGeometry(
            concentricRings: 4,
            ringSpacing: 0.12,
            primaryDivisions: 12,
            secondaryDivisions: 60,
            showCardinalDecorations: true,
            aspectRatio: 1.0
        )
    }
}

extension DialAnimationConfig {
    static var `default`: DialAnimationConfig {
        DialAnimationConfig(
            handRotationDuration: 0.3,
            animationCurve: .easeInOut,
            smoothHandMovement: false,
            appearAnimation: .spring(response: 0.6)
        )
    }
}

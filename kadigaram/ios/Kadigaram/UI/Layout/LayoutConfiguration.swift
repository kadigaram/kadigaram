//
//  LayoutConfiguration.swift
//  Kadigaram
//
//  Created for Feature 006: Clock UI Improvements
//  Task: T017 - Layout Configuration Structures
//

import SwiftUI

/// Manages layout configuration for adaptive clock display
struct LayoutConfiguration {
    /// Screen size class (width x height)
    var sizeClass: SizeClassConfiguration
    
    /// Scaling factors for different contexts
    var scalingFactors: ScalingFactors
    
    /// Safe area management strategy
    var safeAreaStrategy: SafeAreaStrategy
    
    /// Layout constraints
    var constraints: LayoutConstraints
    
    /// Initialize with defaults
    init(
        sizeClass: SizeClassConfiguration = .default,
        scalingFactors: ScalingFactors = .default,
        safeAreaStrategy: SafeAreaStrategy = .respectAll,
        constraints: LayoutConstraints = .default
    ) {
        self.sizeClass = sizeClass
        self.scalingFactors = scalingFactors
        self.safeAreaStrategy = safeAreaStrategy
        self.constraints = constraints
    }
    
    /// Calculate the optimal dial size for a given available space
    /// - Parameter availableSize: The size available in the parent container
    /// - Returns: The calculated square dimension for the dial
    func dialSize(for availableSize: CGSize) -> CGFloat {
        // Determine mode based on available space and size classes
        let isLandscapeShape = availableSize.width > availableSize.height
        
        let targetSize: CGFloat
        
        if isLandscapeShape {
            // In landscape, we want to maximize height usage
            let heightBasedSize = availableSize.height * scalingFactors.landscapeHeightFactor - (scalingFactors.landscapePadding * 2)
            
            // Check if constrained by constraints
            if let maxHeight = constraints.maxLandscapeHeight {
                targetSize = min(heightBasedSize, maxHeight)
            } else {
                targetSize = heightBasedSize
            }
        } else {
            // In portrait, we use width percentage (or available space if small)
            let widthBasedSize = availableSize.width * scalingFactors.portraitWidthFactor - (scalingFactors.portraitPadding * 2)
            
            // Check if constrained
            if let maxWidth = constraints.maxPortraitWidth {
                targetSize = min(widthBasedSize, maxWidth)
            } else {
                targetSize = widthBasedSize
            }
        }
        
        // Clamp between minimum and maximum allowed sizes
        return max(scalingFactors.minimumDialSize, min(targetSize, scalingFactors.maximumDialSize))
    }
}

/// Represents the horizontal and vertical size classes of the environment
struct SizeClassConfiguration {
    let horizontal: UserInterfaceSizeClass?
    let vertical: UserInterfaceSizeClass?
    
    // Default initializer
    init(horizontal: UserInterfaceSizeClass? = .compact, vertical: UserInterfaceSizeClass? = .regular) {
        self.horizontal = horizontal
        self.vertical = vertical
    }
    
    /// Typically iPhone in landscape
    var isLandscapeCompact: Bool {
        horizontal == .compact && vertical == .compact // Older iPhones
        || horizontal == .regular && vertical == .compact // Plus/Max phones
    }
    
    /// iPhone in portrait
    var isPortrait: Bool {
        horizontal == .compact && vertical == .regular
    }
    
    /// iPad full screen or split view
    var isRegular: Bool {
        horizontal == .regular && vertical == .regular
    }
    
    static var `default`: SizeClassConfiguration {
        SizeClassConfiguration()
    }
}

/// Defines scaling factors for calculating dial size
struct ScalingFactors {
    /// Percentage of screen height to use in landscape (0.0 - 1.0)
    let landscapeHeightFactor: CGFloat
    
    /// Percentage of screen width to use in portrait (0.0 - 1.0)
    let portraitWidthFactor: CGFloat
    
    /// Minimum size in points to maintain readability
    let minimumDialSize: CGFloat
    
    /// Maximum size in points to prevent over-scaling on iPad
    let maximumDialSize: CGFloat
    
    /// Padding around dial in landscape (points)
    let landscapePadding: CGFloat
    
    /// Padding around dial in portrait (points)
    let portraitPadding: CGFloat
    
    static var `default`: ScalingFactors {
        ScalingFactors(
            landscapeHeightFactor: 0.90, // 90% of screen height
            portraitWidthFactor: 0.85,   // 85% of screen width (increased from 75% for modern max-width look)
            minimumDialSize: 200.0,
            maximumDialSize: 600.0,
            landscapePadding: 10.0,      // Tight padding in landscape to maximize size
            portraitPadding: 20.0
        )
    }
}

/// Defines safe area handling strategies
enum SafeAreaStrategy {
    /// Fully respect all safe area insets
    case respectAll
    
    /// Respect only top and bottom (optimize for horizontal space)
    case respectVertical
    
    /// Respect only leading and trailing (optimize for vertical space)
    case respectHorizontal
    
    /// Ignore safe areas (use with caution)
    case ignore
}

/// Defines hard constraints for layout
struct LayoutConstraints {
    /// Maximum height in landscape (optional limit)
    let maxLandscapeHeight: CGFloat?
    
    /// Maximum width in portrait (optional limit)
    let maxPortraitWidth: CGFloat?
    
    /// Minimum screen dimension required to show the full dial
    let minScreenDimension: CGFloat
    
    /// Target aspect ratio (typically 1.0 for circular)
    let targetAspectRatio: CGFloat
    
    static var `default`: LayoutConstraints {
        LayoutConstraints(
            maxLandscapeHeight: nil,
            maxPortraitWidth: nil,
            minScreenDimension: 320.0,
            targetAspectRatio: 1.0
        )
    }
}

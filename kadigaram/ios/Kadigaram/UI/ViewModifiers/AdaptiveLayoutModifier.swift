//
//  AdaptiveLayoutModifier.swift
//  Kadigaram
//
//  Created for Feature 006: Clock UI Improvements
//  Task: T018 - AdaptiveLayoutModifier
//

import SwiftUI

/// A view modifier that applies adaptive scaling and positioning to the clock dial
/// based on available space and device orientation layout configuration.
struct AdaptiveLayoutModifier: ViewModifier {
    /// Configuration for layout logic
    var configuration: LayoutConfiguration
    
    /// Environment size classes to detect orientation changes
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    
    func body(content: Content) -> some View {
        GeometryReader { geometry in
            // Create a config with current size classes
            // Note: We use the injected configuration but update its sizeClass property
            // based on the current environment.
            let currentSizeClass = SizeClassConfiguration(
                horizontal: horizontalSizeClass,
                vertical: verticalSizeClass
            )
            
            // Calculate optimal dial size
            // Create a new config with the current size class to calculate size
            let activeConfig = LayoutConfiguration(
                sizeClass: currentSizeClass,
                scalingFactors: configuration.scalingFactors,
                safeAreaStrategy: configuration.safeAreaStrategy,
                constraints: configuration.constraints
            )
            
            let size = activeConfig.dialSize(for: geometry.size)
            
            // Center and frame the content
            content
                .frame(width: size, height: size)
                .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                .animation(.spring(response: 0.5, dampingFraction: 0.8), value: size)
        }
    }
}

extension View {
    /// Applies adaptive layout scaling for the clock dial
    /// - Parameter configuration: The layout configuration to use
    /// - Returns: Modified view with adaptive layout
    func adaptiveClockLayout(configuration: LayoutConfiguration = LayoutConfiguration()) -> some View {
        self.modifier(AdaptiveLayoutModifier(configuration: configuration))
    }
}

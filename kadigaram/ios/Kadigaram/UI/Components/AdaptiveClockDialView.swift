//
//  AdaptiveClockDialView.swift
//  Kadigaram
//
//  Created for Feature 006: Clock UI Improvements
//  Task: T019 - AdaptiveClockDialView
//

import SwiftUI

/// A wrapper view that displays the clock dial with adaptive layout
/// handling different device sizes and orientations.
struct AdaptiveClockDialView: View {
    /// ViewModel for the clock logic
    @ObservedObject var viewModel: ClockDialViewModel
    
    /// Layout configuration
    var layoutConfig: LayoutConfiguration
    
    init(viewModel: ClockDialViewModel, layoutConfig: LayoutConfiguration = LayoutConfiguration()) {
        self.viewModel = viewModel
        self.layoutConfig = layoutConfig
    }
    
    var body: some View {
        ClockDialView(viewModel: viewModel)
            .adaptiveClockLayout(configuration: layoutConfig)
            .modifier(SafeAreaModifier(strategy: layoutConfig.safeAreaStrategy))
    }
}

/// Helper modifier to apply safe area strategy
fileprivate struct SafeAreaModifier: ViewModifier {
    let strategy: SafeAreaStrategy
    
    func body(content: Content) -> some View {
        switch strategy {
        case .respectAll:
            content
        case .respectVertical:
            content.ignoresSafeArea(.container, edges: .horizontal)
        case .respectHorizontal:
            content.ignoresSafeArea(.container, edges: .vertical)
        case .ignore:
            content.ignoresSafeArea()
        }
    }
}

// MARK: - Previews

#Preview("Adaptive Clock - Portrait") {
    AdaptiveClockDialView(
        viewModel: ClockDialViewModel.preview(hour: 10, minute: 10)
    )
    .background(Color.gray.opacity(0.1))
}

#Preview("Adaptive Clock - Landscape", traits: .landscapeLeft) {
    AdaptiveClockDialView(
        viewModel: ClockDialViewModel.preview(hour: 10, minute: 10)
    )
    .background(Color.gray.opacity(0.1))
}

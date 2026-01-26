//
//  ColorExtensions.swift
//  Kadigaram
//
//  Created for Feature 006: Clock UI Improvements
//  Task: T003 - Define Light Mode Color Constants
//

import SwiftUI

// MARK: - Color Extensions

extension Color {
    /// iOS system gray 6 background color (#F2F2F7 approximate)
    /// This is the recommended light mode background color for iOS apps
    static var systemGray6Background: Color {
        Color(.systemGray6)
    }
    
    /// Light mode background color for the app
    /// Uses system gray 6 for consistency with iOS design guidelines
    static var lightModeBackground: Color {
        systemGray6Background
    }
}

// MARK: - SwiftUI Previews

#if DEBUG
struct ColorExtensions_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            // Light mode preview
            VStack {
                Text("Light Mode Background")
                    .font(.headline)
                Rectangle()
                    .fill(Color.lightModeBackground)
                    .frame(height: 100)
                    .overlay(
                        Text("systemGray6\n(#F2F2F7)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    )
            }
            
            // Dark mode preview
            VStack {
                Text("Dark Mode Background")
                    .font(.headline)
                Rectangle()
                    .fill(Color(.systemBackground))
                    .frame(height: 100)
                    .overlay(
                        Text("systemBackground")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    )
            }
            
            // Comparison view
            VStack {
                Text("Side by Side Comparison")
                    .font(.headline)
                HStack(spacing: 0) {
                    Rectangle()
                        .fill(Color.lightModeBackground)
                        .overlay(
                            VStack {
                                Text("Light")
                                    .font(.caption)
                                    .foregroundColor(.primary)
                            }
                        )
                    Rectangle()
                        .fill(Color(.systemBackground))
                        .overlay(
                            VStack {
                                Text("Dark")
                                    .font(.caption)
                                    .foregroundColor(.primary)
                            }
                        )
                }
                .frame(height: 100)
            }
        }
        .padding()
        .previewLayout(.sizeThatFits)
        .previewDisplayName("Color Extensions Preview")
        
        // Test in both light and dark modes
        VStack(spacing: 20) {
            Text("Background Color Test")
                .font(.title2)
            Text("This text should be readable in both modes")
                .foregroundColor(.primary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.lightModeBackground.ignoresSafeArea())
        .preferredColorScheme(.light)
        .previewDisplayName("Light Mode Test")
        
        VStack(spacing: 20) {
            Text("Background Color Test")
                .font(.title2)
            Text("This text should be readable in both modes")
                .foregroundColor(.primary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.lightModeBackground.ignoresSafeArea())
        .preferredColorScheme(.dark)
        .previewDisplayName("Dark Mode Test")
    }
}
#endif

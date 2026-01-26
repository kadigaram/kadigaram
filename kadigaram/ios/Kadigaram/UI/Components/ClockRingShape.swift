//
//  ClockRingShape.swift
//  Kadigaram
//
//  Created for Feature 006: Clock UI Improvements
//  Task: T015 - ClockRingShape for Concentric Circles
//

import SwiftUI

/// Custom Shape for rendering individual concentric rings within the clock dial
struct ClockRingShape: Shape {
    /// The index of the ring (0 is the outermost, increasing integers go inward)
    var ringIndex: Int
    
    /// The design configuration which dictates spacing and geometry
    var design: ClockDialDesign
    
    /// Animatable data (supporting animation of ring indexing if needed, though usually discrete)
    var animatableData: CGFloat {
        get { CGFloat(ringIndex) }
        set { ringIndex = Int(newValue) }
    }
    
    init(ringIndex: Int, design: ClockDialDesign = .default) {
        self.ringIndex = ringIndex
        self.design = design
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let maxRadius = min(rect.width, rect.height) / 2
        
        // Calculate radius for this specific ring
        // Radius decreases as ringIndex increases
        let ringRadius = maxRadius * (1.0 - CGFloat(ringIndex) * design.geometry.ringSpacing)
        
        // Only draw if radius is positive
        if ringRadius > 0 {
            path.addArc(
                center: center,
                radius: ringRadius,
                startAngle: .degrees(0),
                endAngle: .degrees(360),
                clockwise: false
            )
        }
        
        return path
    }
}

// MARK: - Previews

#Preview("Clock Ring Shape - Single") {
    ZStack {
        Color.black.ignoresSafeArea()
        
        ClockRingShape(ringIndex: 0)
            .stroke(Color.gold, lineWidth: 3)
            .frame(width: 300, height: 300)
    }
}

#Preview("Clock Ring Shape - Multiple") {
    ZStack {
        Color.black.ignoresSafeArea()
        
        ForEach(0..<4, id: \.self) { index in
            ClockRingShape(ringIndex: index)
                .stroke(
                    Color.gold.opacity(1.0 - Double(index) * 0.2),
                    lineWidth: index == 0 ? 3 : 1
                )
                .frame(width: 300, height: 300)
        }
    }
}

// Helper for preview
fileprivate extension Color {
    static let gold = Color(red: 212/255, green: 175/255, blue: 55/255)
}

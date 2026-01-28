//
//  ClockDialShape.swift
//  Kadigaram
//
//  Created for Feature 006: Clock UI Improvements
//  Task: T014 - ClockDialShape Custom Shape
//

import SwiftUI

/// Custom SwiftUI Shape for rendering the clock dial with icon-matched design
struct ClockDialShape: Shape {
    var design: ClockDialDesign
    
    init(design: ClockDialDesign = .default) {
        self.design = design
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        
        // 1. Draw outer circle
        path.addArc(
            center: center,
            radius: radius,
            startAngle: .degrees(0),
            endAngle: .degrees(360),
            clockwise: false
        )
        
        // 2. Draw concentric inner rings
        for ringIndex in 1...design.geometry.concentricRings {
            let ringRadius = radius * (1.0 - CGFloat(ringIndex) * design.geometry.ringSpacing)
            if ringRadius > 0 {
                path.move(to: CGPoint(x: center.x + ringRadius, y: center.y))
                path.addArc(
                    center: center,
                    radius: ringRadius,
                    startAngle: .degrees(0),
                    endAngle: .degrees(360),
                    clockwise: false
                )
            }
        }
        
        // 3. Draw hour markers at calculated positions
        let divisions = design.geometry.primaryDivisions
        for tick in 0..<divisions {
            let angle = Double(tick) * (360.0 / Double(divisions)) - 90.0  // -90 to start from top
            let angleRad = angle * .pi / 180.0
            
            // Marker is between outer ring and first inner ring
            let outerPoint = CGPoint(
                x: center.x + radius * 0.95 * CGFloat(cos(angleRad)),
                y: center.y + radius * 0.95 * CGFloat(sin(angleRad))
            )
            let innerPoint = CGPoint(
                x: center.x + radius * 0.85 * CGFloat(cos(angleRad)),
                y: center.y + radius * 0.85 * CGFloat(sin(angleRad))
            )
            
            path.move(to: outerPoint)
            path.addLine(to: innerPoint)
        }
        
        // 4. Draw decorative elements at cardinal points (if enabled)
        if design.geometry.showCardinalDecorations {
            // Draw small decorative diamonds at 12, 3, 6, 9
            let cardinalAngles: [Double] = [0, 90, 180, 270]  // Already adjusted for top start
            let decorationRadius = radius * 0.08
            
            for angle in cardinalAngles {
                let angleRad = (angle - 90) * .pi / 180.0
                let decorationCenter = CGPoint(
                    x: center.x + radius * 0.75 * CGFloat(cos(angleRad)),
                    y: center.y + radius * 0.75 * CGFloat(sin(angleRad))
                )
                
                // Draw diamond shape
                path.move(to: CGPoint(x: decorationCenter.x, y: decorationCenter.y - decorationRadius))
                path.addLine(to: CGPoint(x: decorationCenter.x + decorationRadius, y: decorationCenter.y))
                path.addLine(to: CGPoint(x: decorationCenter.x, y: decorationCenter.y + decorationRadius))
                path.addLine(to: CGPoint(x: decorationCenter.x - decorationRadius, y: decorationCenter.y))
                path.closeSubpath()
            }
        }
        
        return path
    }
}

// MARK: - Preview

#Preview("Clock Dial Shape - Default") {
    ZStack {
        Color.black.ignoresSafeArea()
        
        ClockDialShape()
            .stroke(Color(red: 212/255, green: 175/255, blue: 55/255), lineWidth: 2)
            .frame(width: 300, height: 300)
    }
}

#Preview("Clock Dial Shape - Filled") {
    ZStack {
        Color.black.ignoresSafeArea()
        
        ClockDialShape()
            .fill(
                RadialGradient(
                    colors: [
                        Color(red: 33/255, green: 150/255, blue: 180/255),
                        Color(red: 20/255, green: 100/255, blue: 140/255)
                    ],
                    center: .center,
                    startRadius: 0,
                    endRadius: 150
                )
            )
            .frame(width: 300, height: 300)
            .overlay(
                ClockDialShape()
                    .stroke(Color(red: 212/255, green: 175/255, blue: 55/255), lineWidth: 1.5)
            )
    }
}

#Preview("Clock Dial Shape - Sizes") {
    ZStack {
        Color.black.ignoresSafeArea()
        
        VStack(spacing: 20) {
            ForEach([100, 200, 300], id: \.self) { size in
                ClockDialShape()
                    .stroke(Color(red: 212/255, green: 175/255, blue: 55/255), lineWidth: 1.5)
                    .frame(width: CGFloat(size), height: CGFloat(size))
            }
        }
    }
}

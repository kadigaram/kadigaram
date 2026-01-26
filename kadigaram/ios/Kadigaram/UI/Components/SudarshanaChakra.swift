import SwiftUI

struct SudarshanaChakra: Shape {
    // Inputs requested
    var center: CGPoint? // Optional: If nil, uses the center of the view rect
    var radius: CGFloat? // Optional: If nil, uses half the min dimension of rect
    var innerRadiusRatio: CGFloat = 0.80 // Default ratio of inner hole (increase to fit around dial)
    
    func path(in rect: CGRect) -> Path {
        // Determine actual center and radius based on inputs or available space
        let c = center ?? CGPoint(x: rect.midX, y: rect.midY)
        let r = radius ?? min(rect.width, rect.height) / 2
        
        // Configuration for the Chakra proportions
        let flameCount = 32
        let innerHoleRadius = r * innerRadiusRatio  // The empty center size
        let flameBaseRadius = innerHoleRadius // Flames start directly from the hole
        let flameTipRadius = r * 1.0    // The outer tip of the flames
        
        var path = Path()
        
        // --- Step 1: Draw the Outer Flames ---
        let angleStep = (2 * .pi) / Double(flameCount)
        
        // Move to the start of the first flame
        path.move(to: pointOnCircle(center: c, radius: flameBaseRadius, angle: 0))
        
        for i in 0..<flameCount {
            let startAngle = Double(i) * angleStep
            let endAngle = startAngle + angleStep
            
            // "Wavy Sun Ray" / "Shark Fin" Geometry
            // Peak is shifted slightly to create a swirling motion (Sudarshana Chakra spins)
            let tipAngle = startAngle + (angleStep * 0.65) // Peak biased towards end
            
            let tipPoint = pointOnCircle(center: c, radius: flameTipRadius, angle: tipAngle)
            let endPoint = pointOnCircle(center: c, radius: flameBaseRadius, angle: endAngle)
            
            // CP1: Controls the "Ascent" (Convex edge)
            // Push radius OUT to make it bulge
            let cp1Angle = startAngle + (angleStep * 0.3)
            let cp1 = pointOnCircle(center: c, radius: flameBaseRadius + (flameTipRadius - flameBaseRadius) * 0.5, angle: cp1Angle)
            
            // CP2: Controls the "Descent" (Concave edge / Sharp return)
            // Pull radius IN to make it sharp
            let cp2Angle = tipAngle + (angleStep * 0.2)
            let cp2 = pointOnCircle(center: c, radius: flameBaseRadius + (flameTipRadius - flameBaseRadius) * 0.3, angle: cp2Angle)
            
            // Draw curve to tip
            path.addQuadCurve(to: tipPoint, control: cp1)
            
            // Draw curve back to base (creating the sharp valley between rays)
            path.addQuadCurve(to: endPoint, control: cp2)
        }
        
        path.closeSubpath()
        
        // --- Step 2: Cut out the Hollow Center ---
        // We draw the inner circle in reverse to create a "hole" when filled
        path.move(to: CGPoint(x: c.x + innerHoleRadius, y: c.y))
        path.addArc(center: c,
                    radius: innerHoleRadius,
                    startAngle: .radians(0),
                    endAngle: .radians(2 * .pi),
                    clockwise: true) // Clockwise creates a hole in non-zero winding, but EO fill is safer
        
        path.closeSubpath()
        
        return path
    }
    
    // Helper to calculate X,Y from Angle/Radius
    private func pointOnCircle(center: CGPoint, radius: CGFloat, angle: Double) -> CGPoint {
        return CGPoint(
            x: center.x + radius * CGFloat(cos(angle)),
            y: center.y + radius * CGFloat(sin(angle))
        )
    }
}

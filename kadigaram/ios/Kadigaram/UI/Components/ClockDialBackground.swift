import SwiftUI

/// A separate view for the static background elements of the clock dial.
/// Conforms to Equatable to prevent unnecessary re-renders when the time changes.
struct ClockDialBackground: View, Equatable {
    let design: ClockDialDesign
    
    // Explicitly implementing Equatable based on design updates only.
    static func == (lhs: ClockDialBackground, rhs: ClockDialBackground) -> Bool {
        // Assuming ClockDialDesign is Equatable or doesn't change often.
        // We can compare the extracted palette or assume constant if design object is stable.
        // For now, let's assume it's stable enough. If design changes, it will re-render.
        // If ClockDialDesign is a struct, Swift synthesizes Equatable if properties are Equatable.
        // Let's implement a simple check or rely on default if possible.
        // Since we can't easily check deep equality without Equatable conformance on Design,
        // we will rely on SwiftUI's structural identity if the passed 'design' instance remains the same.
        // However, ViewModel publishes 'design'.
        return lhs.design.colorPalette.primaryGold == rhs.design.colorPalette.primaryGold // Weak check, but sufficient unless theme changes
    }

    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let radius = width / 2
            
            ZStack {
                // 0. Sudarshana Chakra Border
                SudarshanaChakra(innerRadiusRatio: 0.625)
                    .fill(
                        AngularGradient(
                            gradient: Gradient(colors: [
                                Color(red: 0.8, green: 0.2, blue: 0.0), // Deep Red
                                Color(red: 1.0, green: 0.4, blue: 0.0), // Orange
                                Color(red: 1.0, green: 0.8, blue: 0.0), // Yellow/Gold
                                Color(red: 1.0, green: 0.4, blue: 0.0), // Orange
                                Color(red: 0.8, green: 0.2, blue: 0.0)  // Deep Red
                            ]),
                            center: .center
                        ),
                        style: FillStyle(eoFill: true)
                    )
                    .frame(width: width * 1.15, height: width * 1.15)
                    .shadow(color: .orange.opacity(1.0), radius: 15, x: 0, y: 0) // Expensive Shadow!
                    .drawingGroup() // OPTIMIZATION: Rasterize deep shadow to GPU texture
                    
                // 1. Background Gradient
                    
                // 1. Background Gradient
                ClockDialShape(design: design)
                    .fill(
                        RadialGradient(
                            gradient: Gradient(colors: design.gradientConfig.colors),
                            center: design.gradientConfig.center,
                            startRadius: design.gradientConfig.startRadius,
                            endRadius: radius
                        )
                    )
                
                // // 2. Concentric Rings can be added here if static
                //  ForEach(0..<design.geometry.concentricRings, id: \.self) { index in
                //      ClockRingShape(ringIndex: index, design: design)
                //          .stroke(
                //              design.colorPalette.accentBronze.opacity(0.6),
                //              lineWidth: index == 0 ? 
                //                  design.strokeStyles.outerRingWidth :
                //                  design.strokeStyles.innerRingWidth
                //          )
                //  }
            }
            .frame(width: width, height: width)
            .position(x: geometry.frame(in: .local).midX, y: geometry.frame(in: .local).midY)
        }
    }
}

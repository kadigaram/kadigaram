import SwiftUI

public struct NazhigaiWheel: View {
    public let vedicTime: VedicTime
    
    public init(vedicTime: VedicTime) {
        self.vedicTime = vedicTime
    }
    
    // Gradient definitions matching the "Premium Gold" look
    private let goldGradient = LinearGradient(colors: [Color(red: 0.9, green: 0.8, blue: 0.5), Color(red: 0.7, green: 0.6, blue: 0.3)], startPoint: .top, endPoint: .bottom)
    
    private let rahuKalamColor = Color.red
    private let subhaColor = Color.green
    
    public var body: some View {
        GeometryReader { geometry in
            let size = min(geometry.size.width, geometry.size.height)
            let radius = size / 2
            let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
            
            ZStack {
                // 1. Outer Gold Ring
                Circle()
                    .strokeBorder(goldGradient, lineWidth: size * 0.035) // Responsive line width
                    .shadow(color: .black.opacity(0.5), radius: size * 0.03, x: 0, y: size * 0.015)
                    .frame(width: size, height: size)
                
                // 2. Tick Marks
                ForEach(0..<60) { i in
                    Rectangle()
                        .fill(i % 5 == 0 ? Color.white.opacity(0.8) : Color.white.opacity(0.3))
                        .frame(width: i % 5 == 0 ? size * 0.007 : size * 0.0035,
                               height: i % 5 == 0 ? size * 0.035 : size * 0.018)
                        .offset(y: -radius * 0.88)
                        .rotationEffect(.degrees(Double(i) * 6))
                }
                
                // 3. Sectors (Rahu Kalam, etc - simplified placeholders)
                // Red sector
                Circle()
                    .trim(from: 0.0, to: 0.15)
                    .stroke(rahuKalamColor, lineWidth: size * 0.05)
                    .rotationEffect(.degrees(-90))
                    .padding(size * 0.08)
                    .frame(width: size, height: size)
                
                // Green sector
                Circle()
                    .trim(from: 0.25, to: 0.5)
                    .stroke(subhaColor, lineWidth: size * 0.05)
                    .rotationEffect(.degrees(-90))
                    .padding(size * 0.08)
                    .frame(width: size, height: size)
                
                // 4. Position Indicator Sphere (New Feature)
                Circle()
                    .fill(
                        RadialGradient(gradient: Gradient(colors: [.white, Color(red: 0.9, green: 0.8, blue: 0.5)]), center: .topLeading, startRadius: size * 0.01, endRadius: size * 0.05)
                    )
                    .frame(width: size * 0.06, height: size * 0.06)
                    .shadow(color: .black.opacity(0.4), radius: 3, x: 0, y: 3)
                    .offset(y: -radius * 0.98) // Place partially on the ring
                    .rotationEffect(.degrees(vedicTime.progressIndicatorAngle))
                    .animation(.linear(duration: 1.0), value: vedicTime.progressIndicatorAngle) // Smooth movement
                
                // 5. Time Display (Center)
                VStack(spacing: size * 0.015) {
                    // Sun Icon
                    Image(systemName: "sun.max.fill")
                        .foregroundColor(Color(red: 0.9, green: 0.8, blue: 0.5))
                        .font(.system(size: size * 0.08))
                    
                    Text("\(String(format: "%02d", vedicTime.nazhigai)) : \(String(format: "%02d", vedicTime.vinazhigai))")
                        .font(.system(size: size * 0.16, weight: .bold, design: .rounded))
                        .foregroundStyle(goldGradient)
                        .contentTransition(.numericText(countsDown: false)) // Smooth number transition
                    
                    Text("Nazhigai : Vinazhigai") // Should be localized
                        .font(.system(size: size * 0.04))
                        .foregroundStyle(goldGradient.opacity(0.8))
                    
                    // Additional Time (e.g. "1:36 PM" equivalent)
                    Text("-")
                        .font(.system(size: size * 0.04))
                        .foregroundColor(.gray)
                        .padding(.top, size * 0.015)

                }
            }
            .position(x: center.x, y: center.y) // Center the ZStack in GeometryReader
        }
        .aspectRatio(1, contentMode: .fit)
        .padding()
        .drawingGroup() // Optimize rendering for animations
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        NazhigaiWheel(vedicTime: VedicTime(nazhigai: 14, vinazhigai: 21, percentElapsed: 0.25, progressIndicatorAngle: 90.0, sunrise: Date(), sunset: Date(), isDaytime: true))
    }
}

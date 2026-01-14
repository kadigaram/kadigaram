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
        ZStack {
            // 1. Outer Gold Ring (simulated with thick stroke and shadow)
            Circle()
                .strokeBorder(goldGradient, lineWidth: 10)
                .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 5)
            
            // 2. Tick Marks
            ForEach(0..<60) { i in
                Rectangle()
                    .fill(i % 5 == 0 ? Color.white.opacity(0.8) : Color.white.opacity(0.3))
                    .frame(width: i % 5 == 0 ? 2 : 1, height: i % 5 == 0 ? 10 : 5)
                    .offset(y: -130) // Radius offset
                    .rotationEffect(.degrees(Double(i) * 6))
            }
            .padding(20) // Inset ticks from outer ring
            
            // 3. Sectors (Rahu Kalam, etc - simplified placeholders based on image colors)
            // Red sector (approx 10% for demo)
            Circle()
                .trim(from: 0.0, to: 0.15)
                .stroke(rahuKalamColor, lineWidth: 15)
                .rotationEffect(.degrees(-90))
                .padding(25)
            
            // Green sector (approx 25% for demo)
            Circle()
                .trim(from: 0.25, to: 0.5)
                .stroke(subhaColor, lineWidth: 15)
                .rotationEffect(.degrees(-90))
                .padding(25)
            
            // 4. Time Display (Center)
            VStack(spacing: 5) {
                // Sun Icon
                Image(systemName: "sun.max.fill")
                    .foregroundColor(Color(red: 0.9, green: 0.8, blue: 0.5))
                    .font(.title3)
                
                Text("\(String(format: "%02d", vedicTime.nazhigai)) : \(String(format: "%02d", vedicTime.vinazhigai))")
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .foregroundStyle(goldGradient)
                
                Text("Nazhigai : Vinazhigai") // Should be localized
                    .font(.caption)
                    .foregroundStyle(goldGradient.opacity(0.8))
                
                // Additional Time (e.g. "1:36 PM" equivalent)
                Text("-")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.top, 5)

            }
        }
        .aspectRatio(1, contentMode: .fit)
        .padding()
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        NazhigaiWheel(vedicTime: VedicTime(nazhigai: 14, vinazhigai: 21, percentElapsed: 0.25, sunrise: Date(), sunset: Date(), isDaytime: true))
    }
}

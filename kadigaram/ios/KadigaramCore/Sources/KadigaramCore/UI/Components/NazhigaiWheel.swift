import SwiftUI
import SixPartsLib

public struct NazhigaiWheel: View {
    public let vedicTime: VedicTime
    
    public init(vedicTime: VedicTime) {
        self.vedicTime = vedicTime
    }
    
    
    // Enhanced gold gradient with more depth for 3D effect
    private let goldGradient = LinearGradient(
        colors: [
            Color(red: 1.0, green: 0.85, blue: 0.55),  // Highlight
            Color(red: 0.9, green: 0.8, blue: 0.5),     // Mid-tone
            Color(red: 0.7, green: 0.6, blue: 0.3)      // Shadow
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    @Environment(\.colorScheme) private var colorScheme
    
    // Time label color - light text since we have dark background
    private var timeLabelColor: Color {
        // Use light grey for both modes since background is now dark (#404040)
        Color(red: 176/255, green: 176/255, blue: 176/255)
    }
    
    @EnvironmentObject var appConfig: AppConfig
    
    private var localizedNazhigaiLabel: String {
        switch appConfig.language {
        case .english:
            return "Nazhigai : Vinazhigai"
        case .tamil:
            return "நாழிகைNāḻikai : விநாழிகைVināḻikai"
        case .sanskrit:
            return "घटिकाGhaṭikā : विघटिकाVighaṭikā"
        case .telugu:
            return "గడియGadiya : విగడియVigadiya"
        case .kannada:
            return "ಘಳಿಗೆGhalige : ವಿಘಳಿಗೆVighalige"
        case .malayalam:
            return "നാഴികNāḻika : വിനാഴികVināḻika"
        }
    }
    
    public var body: some View {
        GeometryReader { geometry in
            let size = min(geometry.size.width, geometry.size.height)
            let radius = size / 2
            let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
            
            ZStack {
                // 1. Outer Gold Ring with 3D embossed effect
                ZStack {
                    // Base ring with outer shadow
                    Circle()
                        .strokeBorder(goldGradient, lineWidth: size * 0.035)
                        .shadow(color: .black.opacity(0.5), radius: size * 0.03, x: 0, y: size * 0.015)
                    
                    // Inner shadow overlay for embossed effect
                    Circle()
                        .strokeBorder(
                            LinearGradient(
                                colors: [Color.black.opacity(0.3), Color.clear, Color.white.opacity(0.2)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: size * 0.035
                        )
                        .blendMode(.overlay)
                }
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
                
                // 2.5. Standard 24-Hour Time Labels
                ForEach(0..<12) { i in
                    let hour = i * 2 // 0, 2, 4, ... 22
                    
                    // Calculate angle for this standard hour relative to Sunrise
                    // 1. Get Date for today at hour:00
                    let calendar = Calendar.current
                    if let targetDate = calendar.date(bySettingHour: hour, minute: 0, second: 0, of: vedicTime.sunrise) {
                        
                        // 2. Calculate difference from Sunrise
                        var diff = targetDate.timeIntervalSince(vedicTime.sunrise)
                        
                        // Adjust for 24-hour cycle wrap-around
                        let daySeconds: Double = 86400
                        let angleDegrees = (diff / daySeconds) * 360.0
                        
                        Text(String(format: "%02d:00", hour))
                            .font(.system(size: size * 0.035, weight: .medium, design: .rounded))
                            .foregroundColor(timeLabelColor)
                            .offset(y: -radius * 1.08)
                            .rotationEffect(.degrees(angleDegrees))
                    }
                }
                
                // 3. Sectors removed temporarily
                
                // 4. Position Indicator Sphere
                Circle()
                    .fill(
                        RadialGradient(gradient: Gradient(colors: [.white, Color(red: 0.9, green: 0.8, blue: 0.5)]), center: .topLeading, startRadius: size * 0.01, endRadius: size * 0.05)
                    )
                    .frame(width: size * 0.06, height: size * 0.06)
                    .shadow(color: .black.opacity(0.4), radius: 3, x: 0, y: 3)
                    .offset(y: -radius * 0.98)
                    .rotationEffect(.degrees(vedicTime.progressIndicatorAngle))
                    .animation(.linear(duration: 1.0), value: vedicTime.progressIndicatorAngle)
                
                // 5. Time Display (Center)
                VStack(spacing: size * 0.015) {
                    // Sun Icon
                    Image(systemName: "sun.max.fill")
                        .foregroundColor(Color(red: 0.9, green: 0.8, blue: 0.5))
                        .font(.system(size: size * 0.08))
                    
                    Text("\(String(format: "%02d", vedicTime.nazhigai)) : \(String(format: "%02d", vedicTime.vinazhigai))")
                        .font(.system(size: size * 0.16, weight: .bold, design: .rounded))
                        .foregroundStyle(goldGradient)
                        .contentTransition(.numericText(countsDown: false))
                    
                    Text(localizedNazhigaiLabel)
                        .font(.system(size: size * 0.04))
                        .foregroundStyle(goldGradient.opacity(0.8))
                    
                    // Additional Time (e.g. "1:36 PM" equivalent)
                    Text("-")
                        .font(.system(size: size * 0.04))
                        .foregroundColor(.gray)
                        .padding(.top, size * 0.015)

                }
            }
            .position(x: center.x, y: center.y)
        }
        .aspectRatio(1, contentMode: .fit)
        .padding()
        .drawingGroup()
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        NazhigaiWheel(vedicTime: VedicTime(nazhigai: 14, vinazhigai: 21, percentElapsed: 0.25, progressIndicatorAngle: 90.0, sunrise: Date(), sunset: Date(), isDaytime: true))
            .environmentObject(AppConfig())
    }
}

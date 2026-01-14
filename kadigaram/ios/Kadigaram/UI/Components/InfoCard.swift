import SwiftUI

public struct InfoCard: View {
    let titleKey: String
    let valueKey: String
    let progress: Double // 0.0 - 1.0
    let color: Color
    let localizedTitle: String
    let localizedValue: String
    
    // We pass localized strings directly to decouple from BhashaEngine here, 
    // or we could inject BhashaEngine. For core components, simple strings are better.
    
    public init(titleKey: String, valueKey: String, progress: Double, color: Color, localizedTitle: String, localizedValue: String) {
        self.titleKey = titleKey
        self.valueKey = valueKey
        self.progress = progress
        self.color = color
        self.localizedTitle = localizedTitle
        self.localizedValue = localizedValue
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(localizedTitle)
                .font(.caption)
                .foregroundStyle(Color.init(red: 0.8, green: 0.7, blue: 0.5)) // Gold-ish text
            
            Text(localizedValue)
                .font(.headline)
                .bold()
                .foregroundStyle(.white)
            
            // Progress Bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.white.opacity(0.1))
                        .frame(height: 8)
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(color)
                        .frame(width: geometry.size.width * CGFloat(progress), height: 8)
                }
            }
            .frame(height: 8)
            
            HStack {
                Text("\(Int(progress * 100))%")
                    .font(.caption2)
                    .foregroundStyle(color)
                
                Spacer()
                
                // Placeholder for "Ends at" logic
                // Text("Ends 16:30")
                //     .font(.caption2)
                //     .foregroundStyle(.secondary)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(LinearGradient(
                    gradient: Gradient(colors: [Color.white.opacity(0.1), Color.white.opacity(0.05)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
    }
}

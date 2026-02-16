import SwiftUI
import SixPartsLib

public struct RituView: View {
    let ritu: TamilCalendarCalculator.Ritu
    
    public init(ritu: TamilCalendarCalculator.Ritu) {
        self.ritu = ritu
    }
    
    public var body: some View {
        HStack(spacing: 8) {
            // Icon
            // Trying to load from main bundle where assets are located
            Image(ritu.iconName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 24, height: 24) // Constrained size matching requirements
                // Fallback if image not found
                .background(Color.gray.opacity(0.2))
                .clipShape(Circle())
            
            // Localized Name
            Text(ritu.localizedName)
                .font(.subheadline)
        }
        .padding(.horizontal, 4)
    }
}

#Preview {
    VStack {
        RituView(ritu: .vasanta)
        RituView(ritu: .grishma)
        RituView(ritu: .varsha)
        RituView(ritu: .sharad)
        RituView(ritu: .hemanta)
        RituView(ritu: .shishira)
    }
}

import SwiftUI
import SixPartsLib  // Import for Paksha enum


public struct MoonPhaseView: View {
    let paksha: Paksha
    let illumination: Double // 0.0 to 1.0
    var showPakshaArrow: Bool = true  // T002: Show waxing/waning arrow indicator
    
    public init(paksha: Paksha, illumination: Double, showPakshaArrow: Bool = true) {
        self.paksha = paksha
        self.illumination = illumination
        self.showPakshaArrow = showPakshaArrow
    }
    
    public var body: some View {
        // Arrow positioned above (waxing) or below (waning) the moon icon
        VStack(spacing: 0) {
            // Up arrow above moon for waxing (Shukla)
            if showPakshaArrow && paksha == .shukla {
                Image(systemName: Self.arrowSymbolName(for: paksha))
                    .font(.caption2)
                    .fontWeight(.semibold)
                    .foregroundColor(.white) // Always white
            }
            
            Image(systemName: moonSymbolName)
                .renderingMode(.template) // Use template mode instead of original
                .font(.title3)
                .foregroundColor(.white) // Always white moon
            
            // Down arrow below moon for waning (Krishna)
            if showPakshaArrow && paksha == .krishna {
                Image(systemName: Self.arrowSymbolName(for: paksha))
                    .font(.caption2)
                    .fontWeight(.semibold)
                    .foregroundColor(.white) // Always white
            }
        }
        .padding(8) // Add padding around the moon
        .background(
            Circle()
                .fill(Color.black.opacity(0.8)) // Dark background circle
        )
        .accessibilityLabel(accessibilityLabel)
        .accessibilityValue("\(Int(illumination * 100))% illuminated")
    }
    
    // MARK: - Public Static for Testing
    
    /// Returns the SF Symbol name for the Paksha arrow indicator
    /// - Parameter paksha: The lunar phase (shukla = waxing, krishna = waning)
    /// - Returns: SF Symbol name for the arrow direction
    public static func arrowSymbolName(for paksha: Paksha) -> String {
        paksha == .shukla ? "chevron.up" : "chevron.down"
    }
    
    private var moonSymbolName: String {
        // Map illumination + paksha to SF Symbol (iOS 14+)
        // Thresholds are approximate to show distinct phases
        if illumination < 0.05 { return "moonphase.new.moon" }
        if illumination > 0.95 { return "moonphase.full.moon" }
        
        if paksha == .shukla { // Waxing
            if illumination < 0.35 { return "moonphase.waxing.crescent" }
            if illumination < 0.65 { return "moonphase.first.quarter" } // Quarter
            return "moonphase.waxing.gibbous"
        } else { // Waning (Krishna)
            if illumination < 0.35 { return "moonphase.waning.crescent" } // Waning Crescent
            if illumination < 0.65 { return "moonphase.last.quarter" } // Last Quarter
            return "moonphase.waning.gibbous"
        }
    }
    
    // T004: Updated accessibility label includes waxing/waning
    private var accessibilityLabel: String {
        let directionText = paksha == .shukla ? " (waxing)" : " (waning)"
        
        if illumination < 0.05 { return "New Moon" + directionText }
        if illumination > 0.95 { return "Full Moon" + directionText }
        
        let phaseName: String
        if paksha == .shukla {
            if illumination < 0.35 { phaseName = "Waxing Crescent" }
            else if illumination < 0.65 { phaseName = "First Quarter" }
            else { phaseName = "Waxing Gibbous" }
        } else {
            if illumination < 0.35 { phaseName = "Waning Crescent" }
            else if illumination < 0.65 { phaseName = "Last Quarter" }
            else { phaseName = "Waning Gibbous" }
        }
        return phaseName + " Moon" + directionText
    }
}


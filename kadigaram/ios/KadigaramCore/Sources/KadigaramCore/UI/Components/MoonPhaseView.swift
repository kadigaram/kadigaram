import SwiftUI


public struct MoonPhaseView: View {
    let paksha: Paksha
    let illumination: Double // 0.0 to 1.0
    
    public init(paksha: Paksha, illumination: Double) {
        self.paksha = paksha
        self.illumination = illumination
    }
    
    public var body: some View {
        Image(systemName: moonSymbolName)
            .renderingMode(.original) // Use multicolor if available, or simpler
            .font(.title3)
            .foregroundColor(.primary) // Allow parent to tint? Or fixed color?
            .accessibilityLabel(accessibilityLabel)
            .accessibilityValue("\(Int(illumination * 100))% illuminated")
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
    
    private var accessibilityLabel: String {
        if illumination < 0.05 { return "New Moon" }
        if illumination > 0.95 { return "Full Moon" }
        
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
        return phaseName + " Moon"
    }
}


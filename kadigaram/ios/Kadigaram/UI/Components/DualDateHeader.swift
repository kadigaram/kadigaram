import SwiftUI
import KadigaramCore
import SixPartsLib  // Import for TamilDate

struct DualDateHeader: View {
    let gregorianDate: Date
    let vedicDate: VedicDate
    let tamilDate: TamilDate?  // Optional Tamil date
    @ObservedObject var bhashaEngine = BhashaEngine() // Should ideally be EnvironmentObject or passed in
    
    /// Theme object for consistent styling
    @EnvironmentObject var theme: AppTheme
    
    // Formatting Gregorian Date
    private var gregorianString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, d MMM yyyy"
         return formatter.string(from: gregorianDate)
    }
    
    var body: some View {
        VStack(spacing: 8) {
            // Top Line: Gregorian
            Text(gregorianString)
                .font(.title2) // Large enough, but not huge
                .fontWeight(.bold)
                .foregroundColor(theme.foregroundColor)
            
            // Bottom Line: Combined Vedic + Tamil Date
            HStack(spacing: 8) {
                // Moon Phase Icon
                MoonPhaseView(paksha: vedicDate.paksha, illumination: vedicDate.pakshamIllumination)
                    .foregroundStyle(theme.secondaryForegroundColor)
                
                // Use Tamil date if available, otherwise fall back to Vedic month/day
                if let tamil = tamilDate {
                    Text("\(bhashaEngine.localizedString(vedicDate.samvatsara)) • \(bhashaEngine.localizedString(tamil.monthName)) \(tamil.dayNumber) • \(bhashaEngine.localizedString(vedicDate.tithi))")
                        .font(.headline)
                        .foregroundColor(theme.secondaryForegroundColor)
                        .multilineTextAlignment(.center)
                } else {
                    Text("\(bhashaEngine.localizedString(vedicDate.samvatsara)) • \(bhashaEngine.localizedString(vedicDate.maasa)) \(vedicDate.day) • \(bhashaEngine.localizedString(vedicDate.tithi))")
                        .font(.headline)
                        .foregroundColor(theme.secondaryForegroundColor)
                        .multilineTextAlignment(.center)
                }
            }
        }
        .padding()
        .background(Color.secondary.opacity(0.1))
        .cornerRadius(12)
    }
}

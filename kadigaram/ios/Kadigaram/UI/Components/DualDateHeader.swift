import SwiftUI
import KadigaramCore

struct DualDateHeader: View {
    let gregorianDate: Date
    let vedicDate: VedicDate
    @ObservedObject var bhashaEngine = BhashaEngine() // Should ideally be EnvironmentObject or passed in
    
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
                .foregroundColor(.primary)
            
            // Bottom Line: Vedic (Using localized keys checking BhashaEngine)
            // We translate the keys provided by vedicDate
            Text("\(bhashaEngine.localizedString(vedicDate.samvatsara)) • \(bhashaEngine.localizedString(vedicDate.maasa)) \(vedicDate.day) • \(bhashaEngine.localizedString(vedicDate.tithi))")
                .font(.headline)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color.secondary.opacity(0.1))
        .cornerRadius(12)
    }
}

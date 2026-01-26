import Foundation

/// Supported languages for Vara (Day of Week)
public enum VaraLanguage: String, CaseIterable, Sendable {
    case english = "English"
    case sanskrit = "Sanskrit"
    case tamil = "Tamil"
    case telugu = "Telugu"
    case malayalam = "Malayalam"
    case kannada = "Kannada"
}

/// Helper structure for Vara calculations
public struct Vara {
    
    /// Get the localized name of the day of the week
    /// - Parameters:
    ///   - date: The date to check
    ///   - language: The language for the name
    /// - Returns: Localized string (e.g., "Sunday", "ஞாயிறுÑāyiṟu")
    public static func getName(for date: Date, language: VaraLanguage, timeZone: TimeZone = .current) -> String {
        var calendar = Calendar.current
        calendar.timeZone = timeZone
        let weekday = calendar.component(.weekday, from: date) // 1 = Sunday, ... 7 = Saturday
        return getName(forWeekday: weekday, language: language)
    }
    
    /// Get name by weekday integer (1-7)
    public static func getName(forWeekday weekday: Int, language: VaraLanguage) -> String {
        let index = weekday - 1 // 0-based index
        guard index >= 0 && index < 7 else { return "" }
        
        switch language {
        case .english:
            return englishNames[index]
        case .sanskrit:
            return sanskritNames[index]
        case .tamil:
            return tamilNames[index]
        case .telugu:
            return teluguNames[index]
        case .malayalam:
            return malayalamNames[index]
        case .kannada:
            return kannadaNames[index]
        }
    }
    
    // Data Arrays (Sunday to Saturday)
    
    private static let englishNames = [
        "Sunday",
        "Monday",
        "Tuesday",
        "Wednesday",
        "Thursday",
        "Friday",
        "Saturday"
    ]
    
    private static let sanskritNames = [
        "भानुवासरBhānuvāsara",
        "इन्दुवासरInduvāsara",
        "भौमवासरBhaumavāsara",
        "सौम्यवासरSaumyavāsara",
        "गुरुवासरGuruvāsara",
        "भृगुवासरBhṛguvāsara",
        "स्थिरवासरSthiravāsara"
    ]
    
    private static let tamilNames = [
        "ஞாயிறுÑāyiṟu",
        "திங்கள்Tiṅkaḷ",
        "செவ்வாய்Cevvāy",
        "புதன்Putaṉ",
        "வியாழன்Viyāḻaṉ",
        "வெள்ளிVeḷḷi",
        "சனிCaṉi"
    ]
    
    private static let teluguNames = [
        "ఆదివారంAadi Vāram",
        "సోమవారంSoma Vāram",
        "మంగళవారంMangala Vāram",
        "బుధవారంBudha Vāram",
        "గురువారంGuru Vāram",
        "శుక్రవారంSukra Vāram",
        "శనివారంSani Vāram"
    ]
    
    private static let malayalamNames = [
        "ഞായര്Nhāyar",
        "തിങ്കള്Tingal",
        "ചൊവ്വChovva",
        "ബുധന്Budhan",
        "വ്യാഴംVyāzham",
        "വെള്ളിVelli",
        "ശനിShani"
    ]
    
    private static let kannadaNames = [
        "ಭಾನುವಾರBhanu Vaara",
        "ಸೋಮವಾರSoma Vaara",
        "ಮಂಗಳವಾರMangala Vaara",
        "ಬುಧವಾರBudha Vaara",
        "ಗುರುವಾರGuru Vaara",
        "ಶುಕ್ರವಾರShukra Vaara",
        "ಶನಿವಾರShani Vaara"
    ]
}

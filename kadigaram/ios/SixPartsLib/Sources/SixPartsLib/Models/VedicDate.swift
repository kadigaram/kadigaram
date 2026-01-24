import Foundation

public enum Paksha: String, Equatable, Sendable, Codable {
    case shukla
    case krishna
}

/// Calendar system enumeration
public enum CalendarSystem {
    case solar   // Tamil solar calendar (Sankranti-based)
    case lunar   // North Indian lunar calendar
}

/// Represents the Panchangam components
public struct VedicDate: Equatable, Sendable {
    public let samvatsara: String          // Key for Localization, e.g., "year_krodhi"
    public let samvatsaraIndex: Int        // Position in 60-year cycle (1-60)
    public let maasa: String               // Key, e.g., "month_margazhi"
    public let paksha: Paksha              // Fortnight (Shukla/Krishna)
    public let pakshamIllumination: Double // Moon illumination 0.0-1.0
    public let tithi: String               // Key, e.g., "tithi_ekadashi"
    public let tithiProgress: Double       // Tithi completion 0.0-1.0
    public let tithiNumber: Int            // Tithi number 1-30
    public let nakshatra: String           // Key, e.g., "nakshatra_visakam"
    public let nakshatraProgress: Double   // Nakshatra completion 0.0-1.0
    public let nakshatraNumber: Int        // Nakshatra number 1-27
    public let day: Int                    // Day of month
    
    public init(
        samvatsara: String,
        samvatsaraIndex: Int,
        maasa: String,
        paksha: Paksha,
        pakshamIllumination: Double,
        tithi: String,
        tithiProgress: Double,
        tithiNumber: Int,
        nakshatra: String,
        nakshatraProgress: Double,
        nakshatraNumber: Int,
        day: Int
    ) {
        self.samvatsara = samvatsara
        self.samvatsaraIndex = samvatsaraIndex
        self.maasa = maasa
        self.paksha = paksha
        self.pakshamIllumination = pakshamIllumination
        self.tithi = tithi
        self.tithiProgress = tithiProgress
        self.tithiNumber = tithiNumber
        self.nakshatra = nakshatra
        self.nakshatraProgress = nakshatraProgress
        self.nakshatraNumber = nakshatraNumber
        self.day = day
    }
}

/// Tamil calendar date structure
public struct TamilDate {
    /// Tamil month name (localization key: "month_chithirai", "month_thai", etc.)
    public let monthName: String
    
    /// Day of Tamil month (1-32)
    public let dayNumber: Int
    
    /// Exact timestamp when Sun entered current Rasi (Sankranti moment)
    public let sankrantiTimestamp: Date
    
    /// Date determined as Day 1 of this Tamil month
    public let dayOneDate: Date
    
    /// Rasi boundary degree (0, 30, 60, ..., 330)
    public let rasiDegree: Double
    
    public init(
        monthName: String,
        dayNumber: Int,
        sankrantiTimestamp: Date,
        dayOneDate:Date,
        rasiDegree: Double
    ) {
        self.monthName = monthName
        self.dayNumber = dayNumber
        self.sankrantiTimestamp = sankrantiTimestamp
        self.dayOneDate = dayOneDate
        self.rasiDegree = rasiDegree
    }
}

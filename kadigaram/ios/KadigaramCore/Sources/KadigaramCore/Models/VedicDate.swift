import Foundation

public enum Paksha: String, Equatable, Sendable, Codable {
    case shukla
    case krishna
}

/// Represents the Panchangam components.
public struct VedicDate: Equatable, Sendable {
    public let samvatsara: String // Key for Localization, e.g., "year_krodhi"
    public let samvatsaraIndex: Int // Position in 60-year cycle (1-60)
    public let maasa: String // Key, e.g., "month_margazhi"
    public let paksha: Paksha
    public let pakshamIllumination: Double // Moon illumination 0.0-1.0
    public let tithi: String // Key, e.g., "tithi_ekadashi"
    public let tithiProgress: Double // 0.0-1.0
    public let tithiNumber: Int // Tithi number 1-30
    public let nakshatra: String // Key, e.g., "nakshatra_visakam"
    public let nakshatraProgress: Double // 0.0-1.0
    public let nakshatraNumber: Int // Nakshatra number 1-27
    public let day: Int // Day of month
    
    public init(samvatsara: String, samvatsaraIndex: Int, maasa: String, paksha: Paksha, pakshamIllumination: Double, tithi: String, tithiProgress: Double, tithiNumber: Int, nakshatra: String, nakshatraProgress: Double, nakshatraNumber: Int, day: Int) {
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

import Foundation

public enum Paksha: String, Equatable, Sendable, Codable {
    case shukla
    case krishna
}

/// Represents the Panchangam components.
public struct VedicDate: Equatable, Sendable {
    public let samvatsara: String // Key for Localization, e.g., "year_krodhi"
    public let maasa: String // Key, e.g., "month_margazhi"
    public let paksha: Paksha
    public let tithi: String // Key, e.g., "tithi_ekadashi"
    public let tithiProgress: Double // 0.0-1.0
    public let nakshatra: String // Key, e.g., "nakshatra_visakam"
    public let nakshatraProgress: Double // 0.0-1.0
    public let day: Int // Day of month
    
    public init(samvatsara: String, maasa: String, paksha: Paksha, tithi: String, tithiProgress: Double, nakshatra: String, nakshatraProgress: Double, day: Int) {
        self.samvatsara = samvatsara
        self.maasa = maasa
        self.paksha = paksha
        self.tithi = tithi
        self.tithiProgress = tithiProgress
        self.nakshatra = nakshatra
        self.nakshatraProgress = nakshatraProgress
        self.day = day
    }
}

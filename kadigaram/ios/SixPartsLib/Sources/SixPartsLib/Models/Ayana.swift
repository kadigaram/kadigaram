import Foundation

/// Represents the Sun's annual north-south directional movement (Ayana)
///
/// In Vedic astronomy, Ayana represents the Sun's position relative to the celestial equator,
/// affecting day length, seasons, and having cultural significance in Indian traditions.
///
/// - **Uttarayanam** (उत्तरायण): The Sun's northward journey
///   - Period: Winter Solstice to Summer Solstice (approximately December 22 - June 21)
///   - During this period, days gradually lengthen in the Northern Hemisphere
///   - Culturally auspicious period in Hindu tradition
///
/// - **Dakshinayanam** (दक्षिणायन): The Sun's southward journey
///   - Period: Summer Solstice to Winter Solstice (approximately June 22 - December 21)
///   - During this period, days gradually shorten in the Northern Hemisphere
public enum Ayana: String, Equatable, Sendable, Codable {
    /// Uttarayanam: Sun's northward journey (Winter → Summer Solstice)
    /// Approximately December 22 - June 21
    case uttarayanam
    
    /// Dakshinayanam: Sun's southward journey (Summer → Winter Solstice)
    /// Approximately June 22 - December 21
    case dakshinayanam
}

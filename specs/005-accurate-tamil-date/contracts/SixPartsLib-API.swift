// SixPartsLib Public API
// Feature 005: Accurate Tamil Date Calculation
// Created: 2026-01-19

import Foundation
import CoreLocation

// MARK: - Public API Entry Point

/// SixPartsLib - Vedic and Tamil calendar calculations
///
/// This library provides astronomical calculations for Indian calendars:
/// - Tamil solar calendar (Sankranti-based months)
/// - Vedic lunar calendar (Tithi, Nakshatra, Paksha)
/// - Nazhigai time system (60-part day division)
///
/// **Usage**:
/// ```swift
/// import SixPartsLib
///
/// let tamilDate = SixPartsLib.calculateTamilDate(
///     for: Date(),
///     location: CLLocationCoordinate2D(latitude: 13.0, longitude: 80.0),
///     timeZone: TimeZone.current
/// )
/// print("Tamil Date: \(tamilDate.monthName) \(tamilDate.dayNumber)")
/// ```
public struct SixPartsLib {
    
    /// Calculate Tamil calendar date for given date/location
    ///
    /// - Parameters:
    ///   - date: Gregorian date and time
    ///   - location: Geographic coordinates (for sunset calculation)
    ///   - timeZone: Time zone for local time conversion
    /// - Returns: Tamil date with month and day number
    ///
    /// **Algorithm**:
    /// 1. Calculate Sun's sidereal longitude (tropical + Lahiri Ayanamsa)
    /// 2. Determine current Rasi (zodiac sign) → Tamil month
    /// 3. Find exact Sankranti timestamp (Sun entering Rasi)
    /// 4. Apply sunset rule to determine Day 1
    /// 5. Calculate day number as (date - Day1) + 1
    ///
    /// **Performance**: Completes in <50ms on modern iPhones
    ///
    /// **Accuracy**: Sankranti timestamp within ±1 minute of astronomical references
    public static func calculateTamilDate(
        for date: Date,
        location: CLLocationCoordinate2D,
        timeZone: TimeZone
    ) -> TamilDate
    
    /// Calculate Vedic calendar date for given date/location
    ///
    /// - Parameters:
    ///   - date: Gregorian date and time
    ///   - location: Geographic coordinates
    ///   - calendarSystem: Solar or lunar calendar system
    /// - Returns: Vedic date with Tithi, Nakshatra, Samvatsara, etc.
    ///
    /// **Note**: This is the existing Vedic calculation moved from `VedicEngine`
    public static func calculateVedicDate(
        for date: Date,
        location: CLLocationCoordinate2D,
        calendarSystem: CalendarSystem
    ) async -> VedicDate
}

// MARK: - Data Models

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
}

/// Vedic calendar date structure
public struct VedicDate {
    public let samvatsara: String          // Year name (localization key)
    public let samvatsaraIndex: Int        // Position in 60-year cycle (1-60)
    public let maasa: String               // Month name (localization key)
    public let paksha: Paksha              // Fortnight (Shukla/Krishna)
    public let pakshamIllumination: Double // Moon phase (0.0-1.0)
    public let tithi: String               // Lunar day (localization key)
    public let tithiProgress: Double       // Tithi completion (0.0-1.0)
    public let tithiNumber: Int            // Tithi number (1-30)
    public let nakshatra: String           // Lunar mansion (localization key)
    public let nakshatraProgress: Double   // Nakshatra completion (0.0-1.0)
    public let nakshatraNumber: Int        // Nakshatra number (1-27)
    public let day: Int                    // Day of month
}

/// Calendar system enumeration
public enum CalendarSystem {
    case solar   // Tamil solar calendar (Sankranti-based)
    case lunar   // North Indian lunar calendar
}

/// Moon phase (fortnight) enumeration
public enum Paksha {
    case shukla   // Bright fortnight (waxing moon)
    case krishna  // Dark fortnight (waning moon)
}

// MARK: - Advanced Calculators (Optional Direct Access)

/// Advanced astronomy calculations (optional — use SixPartsLib facade instead)
///
/// **Warning**: This API is lower-level and requires understanding of astronomical concepts.
/// Most users should use `SixPartsLib.calculateTamilDate()` instead.
public protocol AstronomicalCalculatorProtocol {
    /// Calculate Sun's tropical ecliptic longitude
    func sunLongitude(date: Date, location: CLLocationCoordinate2D) -> Double
    
    /// Calculate Moon's ecliptic longitude
    func moonLongitude(date: Date, location: CLLocationCoordinate2D) -> Double
    
    /// Calculate Tithi (lunar day) from Moon-Sun difference
    func calculateTithi(date: Date, location: CLLocationCoordinate2D) -> (number: Int, progress: Double)
    
    /// Calculate Nakshatra (lunar mansion) from Moon position
    func calculateNakshatra(date: Date, location: CLLocationCoordinate2D) -> (number: Int, progress: Double)
}

/// Tamil calendar-specific calculations (optional direct access)
public protocol TamilCalendarCalculatorProtocol {
    /// Calculate sidereal Sun longitude (tropical + Lahiri Ayanamsa)
    func siderealSunLongitude(date: Date) -> Double
    
    /// Find Sankranti (Sun entering Rasi) timestamp
    /// - Parameters:
    ///   - targetDegree: Rasi boundary (0, 30, 60, ..., 330)
    ///   - searchEnd: End of search window (typically current date)
    /// - Returns: Sankranti timestamp, or nil if not found in 32-day window
    func findSankranti(targetDegree: Double, searchEnd: Date) -> Date?
    
    /// Apply sunset rule to determine Day 1 date
    /// - Parameters:
    ///   - sankrantiTime: Exact Sankranti timestamp
    ///   - location: Geographic location (for sunset calculation)
    ///   - timeZone: Local time zone
    /// - Returns: Date that is Day 1 of Tamil month
    func applySunsetRule(sankrantiTime: Date, location: CLLocationCoordinate2D, timeZone: TimeZone) -> Date
}

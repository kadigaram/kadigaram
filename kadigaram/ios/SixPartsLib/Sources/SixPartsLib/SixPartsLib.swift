// SixPartsLib - Vedic and Tamil Calendar Calculations
// Public API
//
// This library provides astronomical calculations for Indian calendars:
// - Tamil solar calendar (Sankranti-based months)
// - Vedic lunar calendar (Tithi, Nakshatra, Paksha)
// - Nazhigai time system
//
// Usage:
//   import SixPartsLib
//   let tamilDate = SixPartsLib.calculateTamilDate(for: Date(), location: ..., timeZone: ...)

import Foundation
import CoreLocation

/// SixPartsLib public API
public struct SixPartsLib {
    
    /// Calculate Tamil calendar date for given date/location
    ///
    /// - Parameters:
    ///   - date: Gregorian date and time
    ///   - location: Geographic coordinates
    ///   - timeZone: Local time zone
    /// - Returns: Tamil date with month and day number
    public static func calculateTamilDate(
        for date: Date,
        location: CLLocationCoordinate2D,
        timeZone: TimeZone
    ) -> TamilDate {
        let calculator = TamilCalendarCalculator()
        return calculator.calculateTamilDate(for: date, location: location, timeZone: timeZone)
    }
    
    /// Calculate Vedic calendar date for given date/location
    ///
    /// - Parameters:
    ///   - date: Gregorian date and time
    ///   - location: Geographic coordinates
    ///   - calendarSystem: Solar or lunar calendar system
    /// - Returns: Vedic date with Tithi, Nakshatra, etc.
    public static func calculateVedicDate(
        for date: Date,
        location: CLLocationCoordinate2D,
        calendarSystem: CalendarSystem
    ) async -> VedicDate {
        // TODO: Implement in Phase 5 (US3)
        fatalError("Not yet implemented")
    }
}

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
    
    /// Calculate current Vedic Time (Nazhigai/Vinazhigai)
    ///
    /// - Parameters:
    ///   - date: Current date
    ///   - location: Geographic coordinates
    ///   - timeZone: TimeZone for calculation
    /// - Returns: VedicTime object with calculated Nazhigai
    public static func calculateVedicTime(
        for date: Date,
        location: CLLocationCoordinate2D,
        timeZone: TimeZone
    ) -> VedicTime {
        // Use Solar library for calculation
        // Note: Solar library handles sunrise/sunset based on location/date
        
        let solar = Solar(for: date, coordinate: location)
        
        // Default to 6 AM/6 PM if calculation fails
        let defaultSunrise = Calendar.current.date(bySettingHour: 6, minute: 0, second: 0, of: date) ?? date
        let defaultSunset = Calendar.current.date(bySettingHour: 18, minute: 0, second: 0, of: date) ?? date
        
        let sunrise = solar?.sunrise ?? defaultSunrise
        let sunset = solar?.sunset ?? defaultSunset
        
        // Vedic day starts at sunrise, so we need to find the most recent sunrise
        var referenceSunrise = sunrise
        let elapsed = date.timeIntervalSince(sunrise)
        
        // If before today's sunrise (nighttime of previous day relative to Gregorian date?), 
        // actually if 'date' is before 'sunrise', it means we are in the "previous Vedic day".
        // HOWEVER, Solar(for: date) gives sunrise for THAT Gregorian date.
        // If it's 2 AM, Solar gives 6 AM of that day. 2 AM < 6 AM.
        // So we need YESTERDAY'S sunrise.
        
        if elapsed < 0 {
            let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: date) ?? date
            let yesterSolar = Solar(for: yesterday, coordinate: location)
            referenceSunrise = yesterSolar?.sunrise ?? Calendar.current.date(byAdding: .day, value: -1, to: defaultSunrise) ?? date
        }
        
        // Calculate elapsed time since the reference sunrise
        let effectiveElapsed = date.timeIntervalSince(referenceSunrise)
        
        let totalMinutes = effectiveElapsed / 60.0
        let totalNazhigai = totalMinutes / 24.0 // 1 Nazhigai = 24 mins
        
        let nazhigai = Int(totalNazhigai)
        let fractionalNazhigai = totalNazhigai - Double(nazhigai)
        let vinazhigai = Int(fractionalNazhigai * 60)
        
        // Check if it's daytime (using today's sunrise/sunset)
        // If we are before sunrise (using yesterday's reference), it is technically "daytime" of yesterday? 
        // No, typically isDaytime checks strictly against sun position.
        // But for Vedic Time context, it might imply "Sakalya" vs "Ratri".
        // Let's stick to simple "is sun up" check for now using current day's events.
        // Solar library has isDaytime property on the moment? No.
        
        let isDaytime = date >= sunrise && date < sunset
        
        // Percent for wheel (0-1.0 over 60 Nazhigai cycle = 24 hours)
        // 60 Nazhigai = 1440 minutes = 86400 seconds
        let percent = (effectiveElapsed.truncatingRemainder(dividingBy: 86400)) / 86400.0
        
        // Calculate angle for position indicator (0-360 degrees)
        let progressIndicatorAngle = percent * 360.0
        
        return VedicTime(
            nazhigai: nazhigai % 60,
            vinazhigai: vinazhigai,
            percentElapsed: percent,
            progressIndicatorAngle: progressIndicatorAngle,
            sunrise: referenceSunrise, // Return the reference sunrise used for calculation
            sunset: sunset,
            isDaytime: isDaytime
        )
    }
    
    /// Calculate Vara (Day of the Week) in specified language
    ///
    /// - Parameters:
    ///   - date: The date to check
    ///   - language: The language for the name
    ///   - timeZone: TimeZone for calculation (default current)
    /// - Returns: Localized string
    public static func calculateVara(
        for date: Date,
        language: VaraLanguage,
        timeZone: TimeZone = .current
    ) -> String {
        return Vara.getName(for: date, language: language, timeZone: timeZone)
    }
    
    /// Calculate Gregorian Date for a given Vedic Time (Nazhigai/Vinazhigai) relative to the sunrise of a specific date.
    ///
    /// - Parameters:
    ///   - nazhigai: Target Nazhigai (0-59)
    ///   - vinazhigai: Target Vinazhigai (0-59)
    ///   - date: The calendar date for which to find the sunrise (the "Vedic Day")
    ///   - location: Geographic coordinates
    ///   - timeZone: TimeZone (current)
    /// - Returns: The exact Date when this Vedic Time occurs
    public static func calculateDate(
        nazhigai: Int,
        vinazhigai: Int,
        on date: Date,
        location: CLLocationCoordinate2D,
        timeZone: TimeZone = .current
    ) -> Date? {
        print("📊 SixPartsLib.calculateDate() CALLED:")
        print("   Input: Nazhigai \(nazhigai):\(vinazhigai)")
        print("   Reference Date: \(date)")
        print("   Location: \(location.latitude), \(location.longitude)")
        
        // 1. Get Sunrise for the reference date
        let solar = Solar(for: date, coordinate: location)
        
        // Fail if we can't determine sunrise (e.g., polar regions or error)
        guard let sunrise = solar?.sunrise else {
            print("   ⚠️ RESULT: nil (sunrise could not be calculated)")
            return nil
        }
        
        print("   Sunrise: \(sunrise)")
        
        // 2. Calculate offset in seconds
        // 1 Nazhigai = 24 minutes = 1440 seconds
        // 1 Vinazhigai = 24 seconds
        let secondsOffset = Double(nazhigai) * 1440.0 + Double(vinazhigai) * 24.0
        
        // 3. Add to sunrise
        let result = sunrise.addingTimeInterval(secondsOffset)
        
        let formatter = ISO8601DateFormatter()
        print("   ✅ RESULT: \(formatter.string(from: result)) (\(result))")
        
        return result
    }
}
import Solar // Ensure Solar is imported at file level if not already (it was imported in file view, confirming)

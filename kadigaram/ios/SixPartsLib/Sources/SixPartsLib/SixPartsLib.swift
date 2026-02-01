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

    /// Calculate current Ayana (Sun's directional movement)
    /// - Parameter date: Date for calculation
    /// - Returns: Ayana (Uttarayanam or Dakshinayanam)
    public static func calculateAyana(for date: Date) -> Ayana {
        let calculator = AstronomicalCalculator()
        return calculator.calculateAyana(for: date)
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
        // 1. Get Sunrise for the reference date
        let solar = Solar(for: date, coordinate: location)
        
        // Fail if we can't determine sunrise (e.g., polar regions or error)
        guard let sunrise = solar?.sunrise else {
            print("📊 SixPartsLib.calculateDate() | Nazhigai \(nazhigai):\(vinazhigai) | RefDate: \(date) | Location: (\(location.latitude), \(location.longitude)) | ⚠️ FAILED: sunrise could not be calculated")
            return nil
        }
        
        
        // 2. Calculate offset in seconds
        // 1 Nazhigai = 24 minutes = 1440 seconds
        // 1 Vinazhigai = 24 seconds
        let secondsOffset = Double(nazhigai) * 1440.0 + Double(vinazhigai) * 24.0
        
        // 3. Add to sunrise
        let result = sunrise.addingTimeInterval(secondsOffset)
        
        let formatter = ISO8601DateFormatter()
        print("📊 SixPartsLib.calculateDate() | Nazhigai \(nazhigai):\(vinazhigai) | RefDate: \(date) | Location: (\(location.latitude), \(location.longitude)) | Sunrise: \(sunrise) | ✅ Result: \(formatter.string(from: result))")
        
        return result
    }
    
    /// Calculate the NEXT valid occurrence of a Nazhigai time relative to a reference date (usually 'now').
    ///
    /// This method encapsulates the logic to:
    /// 1. Normalize the calculation date to Local Noon to avoid UTC date boundary issues.
    /// 2. Check if the "current day's" Nazhigai time is still in the future.
    /// 3. If passed, automatically roll over to the next day.
    ///
    /// - Parameters:
    ///   - nazhigai: Target Nazhigai
    ///   - vinazhigai: Target Vinazhigai
    ///   - referenceDate: The starting point for "now" (default: Date())
    ///   - location: User location
    ///   - timeZone: User timezone (default: .current)
    /// - Returns: The verified next occurrence Date
    public static func calculateNextOccurrence(
        nazhigai: Int,
        vinazhigai: Int,
        from referenceDate: Date = Date(),
        location: CLLocationCoordinate2D,
        timeZone: TimeZone = .current
    ) -> Date? {
        var calendar = Calendar.current
        calendar.timeZone = timeZone
        
        // Normalize to Local Noon to avoid UTC date boundary issues
        let todayNoon = calendar.date(bySettingHour: 12, minute: 0, second: 0, of: referenceDate) ?? referenceDate
        
        // 0. CHECK YESTERDAY FIRST (Midnight Edge Case)
        // If we are in the early morning (e.g. 00:05 AM), we might still be in the "previous day's" Vedic cycle.
        // e.g. 55th Nazhigai of Yesterday might be at 04:30 AM Today.
        // If we only check Today, we'd start from Today's Sunrise (06:30 AM) and jump to Tomorrow (04:30 AM).
        if let yesterdayNoon = calendar.date(byAdding: .day, value: -1, to: todayNoon) {
            if let yesterdayTarget = calculateDate(
                nazhigai: nazhigai,
                vinazhigai: vinazhigai,
                on: yesterdayNoon,
                location: location,
                timeZone: timeZone
            ) {
                // If yesterday's cycle yields a time that is still in the future relative to "now", USE IT.
                if yesterdayTarget > referenceDate {
                    return yesterdayTarget
                }
            }
        }
        
        // 1. Try calculating for "Today" (using Noon reference)
        if let todayTarget = calculateDate(
            nazhigai: nazhigai,
            vinazhigai: vinazhigai,
            on: todayNoon,
            location: location,
            timeZone: timeZone
        ) {
            if todayTarget > referenceDate {
                return todayTarget
            }
        }
        
        // 2. If "Today" calculation is in the past, move to "Tomorrow" (using Noon reference)
        guard let tomorrowNoon = calendar.date(byAdding: .day, value: 1, to: todayNoon) else {
            return nil
        }
        
        return calculateDate(
            nazhigai: nazhigai,
            vinazhigai: vinazhigai,
            on: tomorrowNoon,
            location: location,
            timeZone: timeZone
        )
    }
}
import Solar // Ensure Solar is imported at file level if not already (it was imported in file view, confirming)

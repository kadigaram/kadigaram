import Foundation
import CoreLocation

public protocol VedicEngineProvider {
    func calculateVedicTime(date: Date, location: CLLocationCoordinate2D, astronomicalEngine: AstronomicalEngineProvider, timeZone: TimeZone) -> VedicTime
    func calculateVedicDate(date: Date, location: CLLocationCoordinate2D, calendarSystem: CalendarSystem) async -> VedicDate
}

public class VedicEngine: VedicEngineProvider {
    public init() {}
    
    
    public func calculateVedicTime(date: Date, location: CLLocationCoordinate2D, astronomicalEngine: AstronomicalEngineProvider, timeZone: TimeZone) -> VedicTime {
        // Calculate real sunrise and sunset using astronomical engine
        let sunrise = astronomicalEngine.sunrise(for: date, at: location, timeZone: timeZone) ?? defaultSunrise(for: date)
        let sunset = astronomicalEngine.sunset(for: date, at: location, timeZone: timeZone) ?? defaultSunset(for: date)
        
        // Nazhigai Calculation
        // 1 Nazhigai = 24 Minutes
        // 1 Day = 60 Nazhigai
        
        // Calculate elapsed time since sunrise
        let elapsed = date.timeIntervalSince(sunrise)
        
        // Handle pre-sunrise (before sunrise, it's technically previous day's cycle, but for UI we might show negative or handle wrapping)
        // For MVP, let's assume date is after sunrise or handle it simply.
        // If elapsed < 0, it is night time of previous day.
        
        var effectiveElapsed = elapsed
        if effectiveElapsed < 0 {
             // Handle wrap around implies getting previous day's sunrise.
             // For simplicity, let's just use absolute for now or return 0.
             effectiveElapsed = 0
        }
        
        let totalMinutes = effectiveElapsed / 60.0
        let totalNazhigai = totalMinutes / 24.0 // Floating point Nazhigai
        
        let nazhigai = Int(totalNazhigai)
        let fractionalNazhigai = totalNazhigai - Double(nazhigai)
        let vinazhigai = Int(fractionalNazhigai * 60)
        
        // Percent elapsed for day (assuming 12 hour day roughly or calculating actual day length)
        // Day length = Sunset - Sunrise
        let _ = sunset.timeIntervalSince(sunrise)
        let isDaytime = date >= sunrise && date < sunset
        
        // Percent for wheel (0-1.0 over 60 Nazhigai? Or over Day/Night?)
        // The wheel usually shows full 60 Nazhigai cycle (24 hours).
        let percent = (effectiveElapsed.truncatingRemainder(dividingBy: 86400)) / 86400.0
        
        // Calculate angle for position indicator (0-360 degrees)
        let progressIndicatorAngle = percent * 360.0
        
        return VedicTime(
            nazhigai: nazhigai % 60,
            vinazhigai: vinazhigai,
            percentElapsed: percent,
            progressIndicatorAngle: progressIndicatorAngle,
            sunrise: sunrise,
            sunset: sunset,
            isDaytime: isDaytime
        )
    }
    
    // MARK: - Fallback Methods
    
    /// Fallback sunrise if astronomical calculation fails (6 AM)
    private func defaultSunrise(for date: Date) -> Date {
        var components = Calendar.current.dateComponents([.year, .month, .day], from: date)
        components.hour = 6
        components.minute = 0
        return Calendar.current.date(from: components) ?? date
    }
    
    /// Fallback sunset if astronomical calculation fails (6 PM)
    private func defaultSunset(for date: Date) -> Date {
        var components = Calendar.current.dateComponents([.year, .month, .day], from: date)
        components.hour = 18
        components.minute = 0
        return Calendar.current.date(from: components) ?? date
    }
    
    public func calculateVedicDate(date: Date, location: CLLocationCoordinate2D, calendarSystem: CalendarSystem) async -> VedicDate {
        // Simplified Vedic calendar calculation using basic lunar math
        // For accurate results, would need SwissEph or similar ephemeris library
        
        let year = Calendar.current.component(.year, from: date)
        let _ = Calendar.current.component(.month, from: date)
        let day = Calendar.current.component(.day, from: date)
        
        // Get Samvatsara (60-year cycle)
        let samvatsara = SamvatsaraTable.name(for: year)
        let samvatsaraIndex = SamvatsaraTable.indexInCycle(for: year)
        
        // Get month name
        let monthName = (calendarSystem == .solar) ? "month_margazhi" : "month_pausha"
        
        // Simplified Tithi calculation (would need actual moon-sun longitude)
        // Using day of month as approximation
        let tithiNumber = (day % 30) + 1
        let tithiProgress = 0.88
        let tithiName = "tithi_ekadashi"
        
        // Paksham based on Tithi
        let paksha: Paksha = tithiNumber <= 15 ? .shukla : .krishna
        
        // Simplified illumination (would need actual moon phase)
        let pakshamIllumination = tithiNumber <= 15 ? Double(tithiNumber) / 15.0 : Double(30 - tithiNumber) / 15.0
        
        // Simplified Nakshatra (would need moon's ecliptic longitude)
        let nakshatraNumber = (day % 27) + 1
        let nakshatraProgress = 0.05
        let nakshatraName = "nakshatra_visakam"
        
        return VedicDate(
            samvatsara: samvatsara,
            samvatsaraIndex: samvatsaraIndex,
            maasa: monthName,
            paksha: paksha,
            pakshamIllumination: pakshamIllumination,
            tithi: tithiName,
            tithiProgress: tithiProgress,
            tithiNumber: tithiNumber,
            nakshatra: nakshatraName,
            nakshatraProgress: nakshatraProgress,
            nakshatraNumber: nakshatraNumber,
            day: day
        )
    }
}

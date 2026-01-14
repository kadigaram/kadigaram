import Foundation
import CoreLocation

public protocol VedicEngineProvider {
    func calculateVedicTime(date: Date, location: CLLocationCoordinate2D, sunrise: Date, sunset: Date) -> VedicTime
    func calculateVedicDate(date: Date, location: CLLocationCoordinate2D, calendarSystem: CalendarSystem) async -> VedicDate
}

public class VedicEngine: VedicEngineProvider {
    public init() {}
    
    public func calculateVedicTime(date: Date, location: CLLocationCoordinate2D, sunrise: Date, sunset: Date) -> VedicTime {
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
        let dayLength = sunset.timeIntervalSince(sunrise)
        let isDaytime = date >= sunrise && date < sunset
        
        // Percent for wheel (0-1.0 over 60 Nazhigai? Or over Day/Night?)
        // The wheel usually shows full 60 Nazhigai cycle (24 hours).
        let percent = (effectiveElapsed.truncatingRemainder(dividingBy: 86400)) / 86400.0
        
        return VedicTime(
            nazhigai: nazhigai % 60,
            vinazhigai: vinazhigai,
            percentElapsed: percent,
            sunrise: sunrise,
            sunset: sunset,
            isDaytime: isDaytime
        )
    }
    
    public func calculateVedicDate(date: Date, location: CLLocationCoordinate2D, calendarSystem: CalendarSystem) async -> VedicDate {
        // Placeholder for Panchangam Calculation
        // In real app, this would use SwissEph or complex algorithms
        
        let monthName = (calendarSystem == .solar) ? "month_margazhi" : "month_pausha"
        
        return VedicDate(
            samvatsara: "year_krodhi",
            maasa: monthName,
            paksha: .shukla,
            tithi: "tithi_ekadashi",
            tithiProgress: 0.88, // 88%
            nakshatra: "nakshatra_visakam",
            nakshatraProgress: 0.05, // 5%
            day: 29
        )
    }
}

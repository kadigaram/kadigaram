import Foundation
import CoreLocation
import Solar

/// Tamil calendar calculator using Sankranti-based month determination
public class TamilCalendarCalculator {
    
    private let astronomicalCalculator: AstronomicalCalculator
    
    public init() {
        self.astronomicalCalculator = AstronomicalCalculator()
    }
    
    // MARK: - Public API
    
    /// Calculate Tamil calendar date for given date/location
    ///
    /// - Parameters:
    ///   - date: Gregorian date and time
    ///   - location: Geographic coordinates
    ///   - timeZone: Local time zone
    /// - Returns: Tamil date with month and day number
    public func calculateTamilDate(
        for date: Date,
        location: CLLocationCoordinate2D,
        timeZone: TimeZone
    ) -> TamilDate {
        // Step 1: Get Sun's sidereal longitude for current date
        let currentSunPosition = astronomicalCalculator.siderealSunLongitude(date: date)
        
        // Step 2: Identify current Tamil month from Rasi
        let rasiIndex = Int(currentSunPosition / 30.0)
        let monthName = tamilMonthName(for: rasiIndex)
        let rasiDegree = Double(rasiIndex) * 30.0
        
        // Step 3: Find exact Sankranti timestamp
        guard let sankrantiTime = findSankranti(targetDegree: rasiDegree, searchEnd: date) else {
            // Fallback if Sankranti not found (should not happen in normal circumstances)
            return TamilDate(
                monthName: monthName,
                dayNumber: 1,
                sankrantiTimestamp: date,
                dayOneDate: date,
                rasiDegree: rasiDegree
            )
        }
        
        // Step 4: Apply sunset rule to determine Day 1
        let dayOneDate = applySunsetRule(sankrantiTime: sankrantiTime, location: location, timeZone: timeZone)
        
        // DEBUG: Print intermediate values
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        print("🔍 Tamil Date Calculation DEBUG:")
        print("   Sankranti time: \(formatter.string(from: sankrantiTime))")
        print("   Day One date: \(formatter.string(from: dayOneDate))")
        print("   Current date: \(formatter.string(from: date))")
        
        // Step 5: Calculate current Tamil day number
        // Use start of day for both dates to get accurate day count
        let calendar = Calendar.current
        let currentDayStart = calendar.startOfDay(for: date)
        let daysSinceDayOne = calendar.dateComponents([.day], from: dayOneDate, to: currentDayStart).day ?? 0
        let tamilDayNumber = daysSinceDayOne + 1
        
        print("   Days since Day One: \(daysSinceDayOne)")
        print("   Tamil day number: \(tamilDayNumber)")
        
        return TamilDate(
            monthName: monthName,
            dayNumber: max(1, tamilDayNumber),
            sankrantiTimestamp: sankrantiTime,
            dayOneDate: dayOneDate,
            rasiDegree: rasiDegree
        )
    }
    
    // MARK: - Sankranti Search
    
    /// Find Sankranti (Sun entering Rasi) using binary search
    ///
    /// - Parameters:
    ///   - targetDegree: Rasi boundary (0, 30, 60, ..., 330)
    ///   - searchEnd: End of search window (typically current date)
    /// - Returns: Sankranti timestamp, or nil if not found in 32-day window
    public func findSankranti(targetDegree: Double, searchEnd: Date) -> Date? {
        let searchStart = Calendar.current.date(byAdding: .day, value: -32, to: searchEnd)!
        
        var low = searchStart
        var high = searchEnd
        
        // Binary search with 1-minute precision
        while high.timeIntervalSince(low) > 60 {  // 1-minute precision
            let mid = Date(timeIntervalSince1970: (low.timeIntervalSince1970 + high.timeIntervalSince1970) / 2)
            let sunPos = astronomicalCalculator.siderealSunLongitude(date: mid)
            
            // Handle wraparound at 0°/360°
            let distanceToDegree: Double
            if targetDegree == 0 {
                distanceToDegree = sunPos < 180 ? sunPos : sunPos - 360
            } else {
                distanceToDegree = sunPos - targetDegree
            }
            
            if abs(distanceToDegree) < 0.1 {  // Within 0.1° = close enough
                return mid
            } else if distanceToDegree < 0 {
                low = mid
            } else {
                high = mid
            }
        }
        
        return high  // Return best approximation
    }
    
    // MARK: - Sunset Rule
    
    /// Apply sunset rule to determine Day 1 date
    ///
    /// - Parameters:
    ///   - sankrantiTime: Exact Sankranti timestamp
    ///   - location: Geographic location
    ///   - timeZone: Local time zone
    /// - Returns: Date that is Day 1 of Tamil month
    public func applySunsetRule(
        sankrantiTime: Date,
        location: CLLocationCoordinate2D,
        timeZone: TimeZone
    ) -> Date {
        // Get sunset time on Sankranti date
        let calendar = Calendar.current
        let sankrantiDayStart = calendar.startOfDay(for: sankrantiTime)
        
        // Use Solar library to get sunset
        let solar = Solar(for: sankrantiDayStart, coordinate: location)
        let sunsetTime = solar?.sunset ?? sankrantiDayStart.addingTimeInterval(18 * 3600) // Fallback: 6 PM
        
        // Vakya/Thirukanitha rule:
        // If Sankranti occurs before sunset: that day is Day 1
        // If Sankranti occurs after sunset: next day is Day 1
        if sankrantiTime < sunsetTime {
            return sankrantiDayStart
        } else {
            return calendar.date(byAdding: .day, value: 1, to: sankrantiDayStart)!
        }
    }
    
    // MARK: - Helper Methods
    
    /// Map Rasi index to Tamil month name (localization key)
    private func tamilMonthName(for rasiIndex: Int) -> String {
        let monthNames = [
            "month_chithirai",  // 0: Mesha (0-30°)
            "month_vaigasi",    // 1: Vrishabha (30-60°)
            "month_aani",       // 2: Mithuna (60-90°)
            "month_aadi",       // 3: Kataka (90-120°)
            "month_aavani",     // 4: Simha (120-150°)
            "month_purattasi",  // 5: Kanya (150-180°)
            "month_aippasi",    // 6: Tula (180-210°)
            "month_karthigai",  // 7: Vrishchika (210-240°)
            "month_margazhi",   // 8: Dhanus (240-270°)
            "month_thai",       // 9: Makara (270-300°)
            "month_masi",       // 10: Kumbha (300-330°)
            "month_panguni"     // 11: Meena (330-360°)
        ]
        
        let index = rasiIndex % 12
        return monthNames[index]
    }
}

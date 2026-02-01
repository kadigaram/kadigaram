
import Foundation
import CoreLocation

// Mock Solar library since we can't easily compile the dependency in a script
public struct Solar {
    public let sunrise: Date
    public let sunset: Date
    
    public init?(for date: Date, coordinate: CLLocationCoordinate2D) {
        // Mock Sunrise: 06:30 AM local time for the given date
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "Asia/Kolkata")! // Matching test
        
        let sunriseDate = calendar.date(bySettingHour: 6, minute: 30, second: 0, of: date)!
        let sunsetDate = calendar.date(bySettingHour: 18, minute: 30, second: 0, of: date)!
        
        self.sunrise = sunriseDate
        self.sunset = sunsetDate
    }
}

// ... Copy of SixPartsLib.calculateDate & calculateNextOccurrence ... 
// (We will paste the core logic here to test it in isolation)

enum SixPartsLib {
    static func calculateDate(
        nazhigai: Int,
        vinazhigai: Int,
        on date: Date,
        location: CLLocationCoordinate2D,
        timeZone: TimeZone = .current
    ) -> Date? {
        // Mock implementation using our mock Solar
        let solar = Solar(for: date, coordinate: location)
        guard let sunrise = solar?.sunrise else { return nil }
        
        // 1 Nazhigai = 24 mins = 1440 sec
        let secondsOffset = Double(nazhigai) * 1440.0 + Double(vinazhigai) * 24.0
        return sunrise.addingTimeInterval(secondsOffset)
    }
    
    static func calculateNextOccurrence(
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
        if let yesterdayNoon = calendar.date(byAdding: .day, value: -1, to: todayNoon) {
            if let yesterdayTarget = calculateDate(
                nazhigai: nazhigai,
                vinazhigai: vinazhigai,
                on: yesterdayNoon,
                location: location,
                timeZone: timeZone
            ) {
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

// --- TEST CASE ---

func testMidnightEdgeCase() {
    let location = CLLocationCoordinate2D(latitude: 13.0827, longitude: 80.2707)
    let timeZone = TimeZone(identifier: "Asia/Kolkata")!
    
    var calendar = Calendar(identifier: .gregorian)
    calendar.timeZone = timeZone
    
    // Construct "Now": Feb 2nd, 2026, 00:05 AM
    var components = DateComponents()
    components.year = 2026
    components.month = 2
    components.day = 2
    components.hour = 0
    components.minute = 5
    components.second = 0
    
    let now = calendar.date(from: components)!
    
    print("Test: Midnight Edge Case")
    print("Now: \(now)")
    
    // 55 Nazhigai
    // Sunrise Feb 1: ~06:30 Feb 1
    // 55 Na = +22h -> 04:30 Feb 2
    // Expected: 04:30 Feb 2 (which is > 00:05 Feb 2)
    
    let result = SixPartsLib.calculateNextOccurrence(
        nazhigai: 55,
        vinazhigai: 0,
        from: now,
        location: location,
        timeZone: timeZone
    )
    
    if let target = result {
        let components = calendar.dateComponents([.day, .hour, .minute], from: target)
        print("Result: \(target)")
        
        if components.day == 2 && components.hour == 4 {
             print("✅ PASS: Correctly targeted Feb 2nd 04:30 (Yesterday's cycle)")
        } else if components.day == 3 {
             print("❌ FAIL: Targeted Feb 3rd (Tomorrow's cycle). Skipped immediate occurrence!")
        } else {
             print("❌ FAIL: Unexpected result: \(target)")
        }
    } else {
        print("❌ FAIL: Nil Result")
    }
}

testMidnightEdgeCase()

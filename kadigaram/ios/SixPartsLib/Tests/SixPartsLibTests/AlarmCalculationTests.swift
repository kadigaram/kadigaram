import XCTest
import CoreLocation
@testable import SixPartsLib

final class AlarmCalculationTests: XCTestCase {
    
    // Test Location: Chennai
    let location = CLLocationCoordinate2D(latitude: 13.0827, longitude: 80.2707)
    let timeZone = TimeZone(identifier: "Asia/Kolkata")!
    
    func testMidnightEdgeCase() {
        // Scenario:
        // Current Time: Feb 2nd 00:05 AM (Early morning)
        // Alarm: 55 Nazhigai (approx 22 hours after sunrise)
        //
        // Context:
        // Sunrise Feb 1st: ~06:30 AM
        // 55 Nazhigai from Feb 1st Sunrise = Feb 1st 06:30 + 22h = Feb 2nd 04:30 AM.
        //
        // Expected Behavior:
        // Since "Now" (00:05) < Target (04:30), the function should return Feb 2nd 04:30 AM.
        //
        // Potential Current Bug:
        // Logic normalizes to Noon Feb 2nd -> Uses Sunrise Feb 2nd -> Target Feb 3rd 04:30 AM.
        // Result: Skips the immediate valid occurrence.
        
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
        
        // 55 Nazhigai
        let nazhigai = 55
        let vinazhigai = 0
        
        // Calculate
        let result = SixPartsLib.calculateNextOccurrence(
            nazhigai: nazhigai,
            vinazhigai: vinazhigai,
            from: now,
            location: location,
            timeZone: timeZone
        )
        
        XCTAssertNotNil(result, "Result should not be nil")
        
        if let targetDate = result {
            // Check if result is on Feb 2nd (same day as now) or Feb 3rd (next day)
            let targetComponents = calendar.dateComponents([.day, .hour, .minute], from: targetDate)
            
            print("🐞 TEST DEBUG: Now: \(now)")
            print("🐞 TEST DEBUG: Target: \(targetDate)")
            
            // We want it to be Feb 2nd ~04:30 AM
            XCTAssertEqual(targetComponents.day, 2, "Should schedule for the SAME morning (Feb 2), effectively belonging to Yesterday's Vedic day.")
            XCTAssertLessThan(targetDate.timeIntervalSince(now), 12 * 3600, "Target should be within a few hours, not 24+ hours away")
        }
    }
}

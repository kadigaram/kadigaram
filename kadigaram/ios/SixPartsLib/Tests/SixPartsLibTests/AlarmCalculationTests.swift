import XCTest
import CoreLocation
@testable import SixPartsLib

final class AlarmCalculationTests: XCTestCase {
    
    // Test Location: Chennai
    let location = CLLocationCoordinate2D(latitude: 13.0827, longitude: 80.2707)
    let timeZone = TimeZone(identifier: "Asia/Kolkata")!
    
    // Helper to construct dates easily
    func makeDate(day: Int, hour: Int, minute: Int) -> Date {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = timeZone
        var components = DateComponents()
        components.year = 2026
        components.month = 2
        components.day = day
        components.hour = hour
        components.minute = minute
        components.second = 0
        return calendar.date(from: components)!
    }
    
    func testComprehensiveAlarmLogic() {
        print("\n🚀 Running Comprehensive Alarm Logic Tests (XCTest)...\n")
        
        // Scenario 1: At Sunrise (06:30)
        // All targets should be for TODAY (Day 1)
        validateScenario(
            name: "At Sunrise",
            nowDay: 1, nowHour: 6, nowMinute: 30, // Now: Feb 1 06:30
            expectations: [
                15: .today,
                30: .today,
                45: .today,
                59: .today
            ]
        )
        
        // Scenario 2: Daytime (12:00)
        // Before 15th Na (approx 12:30). All should be TODAY (Day 1)
        validateScenario(
            name: "Daytime 12:00",
            nowDay: 1, nowHour: 12, nowMinute: 0,
            expectations: [
                15: .today, // Future -> Today
                30: .today,
                45: .today,
                59: .today
            ]
        )
        
        // Scenario 3: Afternoon (15:00)
        // After 15th Na (12:30). 15 is passed -> Tomorrow. Others -> Today.
        validateScenario(
            name: "Afternoon 15:00",
            nowDay: 1, nowHour: 15, nowMinute: 0,
            expectations: [
                15: .tomorrow, // Passed -> Tomorrow
                30: .today,
                45: .today,
                59: .today
            ]
        )
        
        // Scenario 4: At Sunset (18:35 approx)
        // After 30th Na (18:30 for Mock, similar for Real).
        // 15, 30 passed -> Tomorrow. 45, 59 Future -> Today.
        validateScenario(
            name: "At Sunset 18:35",
            nowDay: 1, nowHour: 18, nowMinute: 35,
            expectations: [
                15: .tomorrow,
                30: .tomorrow,
                45: .today,
                59: .today
            ]
        )
        
        // Scenario 5: Midnight (00:00 Feb 2)
        // Before 45th Na (approx 00:30 Feb 2).
        // 15, 30 passed -> Tomorrow (meaning Feb 2 Cycle).
        // 45, 59 Future -> Today (meanng Feb 1 Cycle which extends to early Feb 2).
        validateScenario(
            name: "Midnight 00:00 Feb 2",
            nowDay: 2, nowHour: 0, nowMinute: 0,
            expectations: [
                15: .today, // Wait: 'Today' for Feb 2 is Feb 2 06:30.
                            // 'Yesterday' is Feb 1 06:30.
                            // 15 Na matches 12:30.
                            // 00:00 Feb 2 is BEFORE 12:30 Feb 2. So if we used Today (Feb 2), it would be future 12:30 Feb 2.
                            // BUT... if we used Yesterday (Feb 1), it would be 12:30 Feb 1 (Passed).
                            // Logic: Prev (Feb 1) passed. Next (Feb 2) future.
                            // Expect: Feb 2 12:30 (Today Cycle of Feb 2).
                            // NOTE: My enum .today means "Using the Noon reference of 'Now'".
                            // Now = Feb 2. Noon = Feb 2 12:00. Today Cycle = Feb 2.
                            // So expect: .today (Feb 2).
                            
                30: .today, // Feb 2 18:30 (Today Cycle of Feb 2)
                
                45: .yesterday, // 45 Na of Yesterday (Feb 1) is 00:30 Feb 2.
                                // 00:30 Feb 2 > 00:00 Feb 2. It is FUTURE.
                                // Expect: Yesterday (Feb 1) Cycle.
                
                59: .yesterday  // 59 Na of Yesterday (Feb 1) is ~06:00 Feb 2. Future. Expect Yesterday.
            ]
        )
        
        // Scenario 6: Pre-Dawn (06:15 Feb 2)
        // 59 Na of Yesterday is ~06:06 Feb 2. Future.
        validateScenario(
            name: "Pre-Dawn 06:15 Feb 2",
            nowDay: 2, nowHour: 6, nowMinute: 15, // Let's try 06:00 (Before 59) vs 06:15 (After 59)
            expectations: [
                // Real sunrise is ~06:36 in Chennai for Feb 2.
                // 59 Na = +23h36m.
                // If Yesterday Sunrise 06:36, +23:36 = 06:12 Next Day.
                // At 06:15, 06:12 is Passed. So expect Today (Feb 2) Cycle.
                 15: .today,
                 30: .today,
                 45: .today, // 00:30 Feb 3
                 59: .today  // 06:12 Feb 3
            ]
        )
        
        // Scenario 7: Early Morning (02:00 Feb 2)
        // 45 Na (00:30 Feb 2) Passed. 59 Na (06:00 Feb 2) Future.
        validateScenario(
            name: "Early Morning 02:00 Feb 2",
            nowDay: 2, nowHour: 2, nowMinute: 0,
            expectations: [
                 15: .today, // Feb 2 12:30
                 30: .today, // Feb 2 18:30
                 45: .today, // Feb 2 18:30 + ... -> Feb 3 00:30 (Since Feb 1 cycle 00:30 passed)
                 59: .yesterday // Feb 1 Cycle -> Feb 2 06:06 (Future)
            ]
        )
    }
    
    enum Cycle {
        case yesterday
        case today
        case tomorrow
    }
    
    func validateScenario(name: String, nowDay: Int, nowHour: Int, nowMinute: Int, expectations: [Int: Cycle]) {
        let now = makeDate(day: nowDay, hour: nowHour, minute: nowMinute)
        let calendar = Calendar.current
        
        print("🔸 Verifying Scenario: \(name) @ \(now)")
        
        let todayNoon = calendar.date(bySettingHour: 12, minute: 0, second: 0, of: now) ?? now
        let yesterdayNoon = calendar.date(byAdding: .day, value: -1, to: todayNoon)!
        let tomorrowNoon = calendar.date(byAdding: .day, value: 1, to: todayNoon)!
        
        for (nazhigai, cycle) in expectations {
            // 1. Calculate Actual Result
            let result = SixPartsLib.calculateNextOccurrence(
                nazhigai: nazhigai,
                vinazhigai: 0,
                from: now,
                location: location,
                timeZone: timeZone
            )
            
            XCTAssertNotNil(result, "Result should not be nil for \(nazhigai) Na")
            guard let result = result else { continue }
            
            // 2. Calculate Expected Result using explicit 'calculateDate' on correct cycle
            var referenceDateForCycle: Date
            switch cycle {
            case .yesterday: referenceDateForCycle = yesterdayNoon
            case .today: referenceDateForCycle = todayNoon
            case .tomorrow: referenceDateForCycle = tomorrowNoon
            }
            
            let expected = SixPartsLib.calculateDate(
                nazhigai: nazhigai,
                vinazhigai: 0,
                on: referenceDateForCycle, // Force specific cycle
                location: location,
                timeZone: timeZone
            )
            
            XCTAssertNotNil(expected, "Expected calculation failed")
            guard let expected = expected else { continue }
            
            // 3. Compare with some tolerance (1 sec)
            let diff = abs(result.timeIntervalSince(expected))
            let isMatch = diff < 2.0
            
            if !isMatch {
                print("❌ FAIL: Nazhigai \(nazhigai). Got \(result), Expected \(expected) (\(cycle))")
            } else {
                print("✅ PASS: Nazhigai \(nazhigai). Matches \(cycle) cycle.")
            }
            
            XCTAssertLessThan(diff, 2.0, "Scenario \(name): Nazhigai \(nazhigai) should match \(cycle) cycle date.")
        }
    }
}

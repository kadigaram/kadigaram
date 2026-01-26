import XCTest
@testable import SixPartsLib

final class SankrantiDebugTests: XCTestCase {
    
    func testSankrantiValues() {
        let calculator = AstronomicalCalculator()
        
        // Target: Jan 14, 2026 at 04:43 AM IST (Drik Panchang Moment)
        // IST is UTC+5:30
        // Jan 14 04:43 IST = Jan 13 23:13 UTC
        
        let components = DateComponents(
            timeZone: TimeZone(identifier: "UTC"),
            year: 2026,
            month: 1,
            day: 13,
            hour: 23,
            minute: 13,
            second: 0
        )
        let targetDate = Calendar.current.date(from: components)!
        
        print("\n-------- DIAGNOSTIC START --------")
        print("Target Date (UTC): \(targetDate)")
        
        // Since julianDay is private, we can't call it easily unless we make it public or duplicate logic here.
        // Let's rely on public methods.
        
        let tropical = calculator.sunLongitude(date: targetDate, location: .init())
        let ayanamsa = calculator.calculateLahiriAyanamsa(date: targetDate)
        let sidereal = calculator.siderealSunLongitude(date: targetDate)
        
        print("Tropical Sun: \(tropical)°")
        print("Ayanamsa: \(ayanamsa)°")
        print("Sidereal Sun: \(sidereal)°")
        print("Target Sidereal: 270.0° (Makara/Capricorn Start)")
        print("Difference: \(sidereal - 270.0)°")
        
        // Also check one day later to see movement
        let nextDay = targetDate.addingTimeInterval(86400)
        let siderealNext = calculator.siderealSunLongitude(date: nextDay)
        print("Next Day Sidereal: \(siderealNext)°")
        
        // Check Jan 15 00:00 Local (ET?) -> Jan 15 05:00 UTC
        let jan15 = Calendar.current.date(from: DateComponents(timeZone: TimeZone(identifier: "UTC"), year: 2026, month: 1, day: 15, hour: 5))!
        let jan15Sidereal = calculator.siderealSunLongitude(date: jan15)
        print("Jan 15 00:00 EST (05:00 UTC) Sidereal: \(jan15Sidereal)°")
        
        print("-------- DIAGNOSTIC END --------\n")
    }
}

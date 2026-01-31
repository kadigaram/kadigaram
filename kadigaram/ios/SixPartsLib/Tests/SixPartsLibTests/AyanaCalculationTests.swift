import XCTest
@testable import SixPartsLib

final class AyanaCalculationTests: XCTestCase {
    
    var calculator: AstronomicalCalculator!
    
    override func setUp() {
        super.setUp()
        calculator = AstronomicalCalculator()
    }
    
    override func tearDown() {
        calculator = nil
        super.tearDown()
    }
    
    // MARK: - Helper
    
    private func date(year: Int, month: Int, day: Int) -> Date {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        components.timeZone = TimeZone(identifier: "UTC")!
        // Use noon to avoid timezone edge cases with midnight
        components.hour = 12
        return Calendar.current.date(from: components)!
    }
    
    // MARK: - Uttarayanam Tests (Dec 22 - Jun 21)
    
    func testUttarayanamMidWinter() {
        // January 15
        let d = date(year: 2026, month: 1, day: 15)
        XCTAssertEqual(calculator.calculateAyana(for: d), .uttarayanam, "Jan 15 should be Uttarayanam")
    }
    
    func testUttarayanamBeforeSolstice() {
        // June 21 (Last day of Uttarayanam)
        let d = date(year: 2026, month: 6, day: 21)
        XCTAssertEqual(calculator.calculateAyana(for: d), .uttarayanam, "Jun 21 should be Uttarayanam")
    }
    
    func testUttarayanamTransition() {
        // December 22 (First day of Uttarayanam)
        let d = date(year: 2026, month: 12, day: 22)
        XCTAssertEqual(calculator.calculateAyana(for: d), .uttarayanam, "Dec 22 should be Uttarayanam")
    }
    
    func testEdgeCaseSpring() {
        // March 20 (Equinox)
        let d = date(year: 2026, month: 3, day: 20)
        XCTAssertEqual(calculator.calculateAyana(for: d), .uttarayanam, "Mar 20 should be Uttarayanam")
    }
    
    // MARK: - Dakshinayanam Tests (Jun 22 - Dec 21)
    
    func testDakshinayanamTransition() {
        // June 22 (First day of Dakshinayanam)
        let d = date(year: 2026, month: 6, day: 22)
        XCTAssertEqual(calculator.calculateAyana(for: d), .dakshinayanam, "Jun 22 should be Dakshinayanam")
    }
    
    func testDakshinayanamMidSummer() {
        // August 31
        let d = date(year: 2026, month: 8, day: 31)
        XCTAssertEqual(calculator.calculateAyana(for: d), .dakshinayanam, "Aug 31 should be Dakshinayanam")
    }
    
    func testDakshinayanamBeforeSolstice() {
        // December 21 (Last day of Dakshinayanam)
        let d = date(year: 2026, month: 12, day: 21)
        XCTAssertEqual(calculator.calculateAyana(for: d), .dakshinayanam, "Dec 21 should be Dakshinayanam")
    }
    
    func testEdgeCaseAutumn() {
        // September 22 (Equinox)
        let d = date(year: 2026, month: 9, day: 22)
        XCTAssertEqual(calculator.calculateAyana(for: d), .dakshinayanam, "Sep 22 should be Dakshinayanam")
    }
    
    // MARK: - Performance Test
    
    func testAyanaCalculationPerformance() {
        let testDate = Date()
        
        measure {
            for _ in 0..<1000 {
                _ = calculator.calculateAyana(for: testDate)
            }
        }
    }
}

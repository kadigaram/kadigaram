import XCTest
import CoreLocation
@testable import KadigaramCore

final class VedicEngineTests: XCTestCase {
    var engine: VedicEngine!
    
    override func setUp() {
        super.setUp()
        engine = VedicEngine()
    }
    
    func testNazhigaiCalculationAtSunrise() {
        // Sunrise at 6:00 AM
        let sunrise = Date(timeIntervalSince1970: 1705212000) // Jan 14 2024, 06:00:00 UTC (Example)
        let sunset = sunrise.addingTimeInterval(43200) // 12 hours later
        let now = sunrise // Exact sunrise
        
        let location = CLLocationCoordinate2D(latitude: 13.0827, longitude: 80.2707) // Chennai
        
        let time = engine.calculateVedicTime(date: now, location: location, sunrise: sunrise, sunset: sunset)
        
        XCTAssertEqual(time.nazhigai, 0)
        XCTAssertEqual(time.vinazhigai, 0)
        XCTAssertEqual(time.percentElapsed, 0.0)
    }
    
    func testNazhigaiCalculationOneHourAfterSunrise() {
        // 1 Hour = 60 Mins = 2.5 Nazhigai
        let sunrise = Date(timeIntervalSince1970: 1705212000)
        let sunset = sunrise.addingTimeInterval(43200)
        let now = sunrise.addingTimeInterval(3600) // +1 Hour
        
        let location = CLLocationCoordinate2D(latitude: 13.0827, longitude: 80.2707)
        
        let time = engine.calculateVedicTime(date: now, location: location, sunrise: sunrise, sunset: sunset)
        
        XCTAssertEqual(time.nazhigai, 2)
        XCTAssertEqual(time.vinazhigai, 30) // 0.5 * 60 = 30
    }
}

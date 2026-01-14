import XCTest
import CoreLocation
@testable import KadigaramCore

final class AstronomicalEngineTests: XCTestCase {
    
    var engine: SolarAstronomicalEngine!
    
    override func setUp() {
        super.setUp()
        engine = SolarAstronomicalEngine()
    }
    
    override func tearDown() {
        engine = nil
        super.tearDown()
    }
    
    // MARK: - Sunrise Tests
    
    func testSunriseChennai() {
        // Chennai coordinates
        let chennai = CLLocationCoordinate2D(latitude: 13.0827, longitude: 80.2707)
        let timeZone = TimeZone(identifier: "Asia/Kolkata")!
        
        // Test date: Jan 15, 2026
        var components = DateComponents()
        components.year = 2026
        components.month = 1
        components.day = 15
        components.timeZone = timeZone
        
        guard let date = Calendar.current.date(from: components) else {
            XCTFail("Failed to create test date")
            return
        }
        
        let sunrise = engine.sunrise(for: date, at: chennai, timeZone: timeZone)
        
        XCTAssertNotNil(sunrise, "Sunrise should not be nil for Chennai")
        
        // Verify sunrise is reasonable (between 5 AM and 7 AM in Chennai)
        if let sunrise = sunrise {
            let hour = Calendar.current.component(.hour, from: sunrise)
            XCTAssertGreaterThanOrEqual(hour, 5, "Sunrise should be after 5 AM")
            XCTAssertLessThanOrEqual(hour, 7, "Sunrise should be before 7 AM")
        }
    }
    
    func testSunsetChennai() {
        // Chennai coordinates
        let chennai = CLLocationCoordinate2D(latitude: 13.0827, longitude: 80.2707)
        let timeZone = TimeZone(identifier: "Asia/Kolkata")!
        
        // Test date: Jan 15, 2026
        var components = DateComponents()
        components.year = 2026
        components.month = 1
        components.day = 15
        components.timeZone = timeZone
        
        guard let date = Calendar.current.date(from: components) else {
            XCTFail("Failed to create test date")
            return
        }
        
        let sunset = engine.sunset(for: date, at: chennai, timeZone: timeZone)
        
        XCTAssertNotNil(sunset, "Sunset should not be nil for Chennai")
        
        // Verify sunset is reasonable (between 5 PM and 7 PM in Chennai)
        if let sunset = sunset {
            let hour = Calendar.current.component(.hour, from: sunset)
            XCTAssertGreaterThanOrEqual(hour, 17, "Sunset should be after 5 PM")
            XCTAssertLessThanOrEqual(hour, 19, "Sunset should be before 7 PM")
        }
    }
    
    // MARK: - Different Location Tests
    
    func testSunriseDelhi() {
        // Delhi coordinates (later sunrise than Chennai due to northern latitude)
        let delhi = CLLocationCoordinate2D(latitude: 28.7041, longitude: 77.1025)
        let timeZone = TimeZone(identifier: "Asia/Kolkata")!
        
        var components = DateComponents()
        components.year = 2026
        components.month = 1
        components.day = 15
        components.timeZone = timeZone
        
        guard let date = Calendar.current.date(from: components) else {
            XCTFail("Failed to create test date")
            return
        }
        
        let sunrise = engine.sunrise(for: date, at: delhi, timeZone: timeZone)
        
        XCTAssertNotNil(sunrise, "Sunrise should not be nil for Delhi")
        
        if let sunrise = sunrise {
            let hour = Calendar.current.component(.hour, from: sunrise)
            // Delhi sunrise in January is later than Chennai (around 7 AM)
            XCTAssertGreaterThanOrEqual(hour, 6, "Delhi sunrise should be after 6 AM")
            XCTAssertLessThanOrEqual(hour, 8, "Delhi sunrise should be before 8 AM")
        }
    }
    
    // MARK: - Caching Tests
    
    func testCaching() {
        let chennai = CLLocationCoordinate2D(latitude: 13.0827, longitude: 80.2707)
        let timeZone = TimeZone(identifier: "Asia/Kolkata")!
        
        var components = DateComponents()
        components.year = 2026
        components.month = 1
        components.day = 15
        components.timeZone = timeZone
        
        guard let date = Calendar.current.date(from: components) else {
            XCTFail("Failed to create test date")
            return
        }
        
        // First call - should calculate
        let startTime = Date()
        let sunrise1 = engine.sunrise(for: date, at: chennai, timeZone: timeZone)
        let firstCallDuration = Date().timeIntervalSince(startTime)
        
        // Second call - should use cache (faster)
        let cachedStartTime = Date()
        let sunrise2 = engine.sunrise(for: date, at: chennai, timeZone: timeZone)
        let cachedCallDuration = Date().timeIntervalSince(cachedStartTime)
        
        XCTAssertEqual(sunrise1, sunrise2, "Cached result should match original")
        XCTAssertLessThan(cachedCallDuration, firstCallDuration * 0.5, "Cached call should be significantly faster")
    }
    
    // MARK: - Edge Cases
    
    func testInvalidCoordinate() {
        // Test with invalid coordinates (latitude > 90)
        let invalid = CLLocationCoordinate2D(latitude: 100, longitude: 80)
        let timeZone = TimeZone.current
        let date = Date()
        
        let sunrise = engine.sunrise(for: date, at: invalid, timeZone: timeZone)
        
        // Solar library should return nil for invalid coordinates
        XCTAssertNil(sunrise, "Sunrise should be nil for invalid coordinates")
    }
}

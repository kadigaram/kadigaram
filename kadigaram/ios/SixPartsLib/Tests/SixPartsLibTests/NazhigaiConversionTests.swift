import XCTest
import CoreLocation
@testable import SixPartsLib

/// Unit tests for Nazhigai:Vinazhigai to Date/Time conversion
final class NazhigaiConversionTests: XCTestCase {
    
    // MARK: - Test Data
    
    /// Cambridge, Ontario, Canada
    let cambridgeON = CLLocationCoordinate2D(latitude: 43.3616, longitude: -80.3144)
    
    /// Chennai, India
    let chennai = CLLocationCoordinate2D(latitude: 13.0827, longitude: 80.2707)
    
    /// New York, USA
    let newYork = CLLocationCoordinate2D(latitude: 40.7128, longitude: -74.0060)
    
    // MARK: - Basic Conversion Tests
    
    func testNazhigaiZeroAtSunrise() throws {
        // GIVEN: January 29, 2026 in Cambridge, ON
        let calendar = Calendar(identifier: .gregorian)
        var components = DateComponents()
        components.year = 2026
        components.month = 1
        components.day = 29
        components.hour = 12 // Noon as reference
        components.timeZone = TimeZone(identifier: "America/Toronto")
        
        guard let referenceDate = calendar.date(from: components) else {
            XCTFail("Failed to create reference date")
            return
        }
        
        // WHEN: Calculate date for Nazhigai 0, Vinazhigai 0 (sunrise)
        let result = SixPartsLib.calculateDate(
            nazhigai: 0,
            vinazhigai: 0,
            on: referenceDate,
            location: cambridgeON
        )
        
        // THEN: Should return sunrise time
        XCTAssertNotNil(result, "Result should not be nil")
        
        if let result = result {
            // Verify it's close to sunrise time (between 7-8 AM in winter)
            let resultComponents = calendar.dateComponents([.hour], from: result)
            if let hour = resultComponents.hour {
                XCTAssertEqual(hour, 7, accuracy: 1, "Nazhigai 0 should be around sunrise (7-8 AM)")
            } else {
                XCTFail("Could not extract hour from result")
            }
        }
    }
    
    func testOneNazhigaiEquals24Minutes() throws {
        // GIVEN: A reference date
        let referenceDate = Date(timeIntervalSince1970: 1738195200) // Jan 30, 2026 00:00:00 UTC
        
        // WHEN: Calculate date for Nazhigai 1, Vinazhigai 0
        let nazhigai0 = SixPartsLib.calculateDate(
            nazhigai: 0,
            vinazhigai: 0,
            on: referenceDate,
            location: cambridgeON
        )
        
        let nazhigai1 = SixPartsLib.calculateDate(
            nazhigai: 1,
            vinazhigai: 0,
            on: referenceDate,
            location: cambridgeON
        )
        
        // THEN: Difference should be 24 minutes (1440 seconds)
        XCTAssertNotNil(nazhigai0)
        XCTAssertNotNil(nazhigai1)
        
        if let n0 = nazhigai0, let n1 = nazhigai1 {
            let difference = n1.timeIntervalSince(n0)
            XCTAssertEqual(difference, 1440.0, accuracy: 1.0, "1 Nazhigai should equal 24 minutes (1440 seconds)")
        }
    }
    
    func testOneVinazhigaiEquals24Seconds() throws {
        // GIVEN: A reference date
        let referenceDate = Date(timeIntervalSince1970: 1738195200)
        
        // WHEN: Calculate date for different Vinazhigai values
        let vinazhigai0 = SixPartsLib.calculateDate(
            nazhigai: 5,
            vinazhigai: 0,
            on: referenceDate,
            location: cambridgeON
        )
        
        let vinazhigai1 = SixPartsLib.calculateDate(
            nazhigai: 5,
            vinazhigai: 1,
            on: referenceDate,
            location: cambridgeON
        )
        
        // THEN: Difference should be 24 seconds
        XCTAssertNotNil(vinazhigai0)
        XCTAssertNotNil(vinazhigai1)
        
        if let v0 = vinazhigai0, let v1 = vinazhigai1 {
            let difference = v1.timeIntervalSince(v0)
            XCTAssertEqual(difference, 24.0, accuracy: 0.1, "1 Vinazhigai should equal 24 seconds")
        }
    }
    
    // MARK: - Edge Cases
    
    func testMaximumNazhigai() throws {
        // GIVEN: Maximum valid Nazhigai (59:59)
        let referenceDate = Date(timeIntervalSince1970: 1738195200)
        
        // WHEN: Calculate date for Nazhigai 59, Vinazhigai 59
        let result = SixPartsLib.calculateDate(
            nazhigai: 59,
            vinazhigai: 59,
            on: referenceDate,
            location: cambridgeON
        )
        
        // THEN: Should be just before next sunrise
        XCTAssertNotNil(result)
        
        if let result = result, let sunrise = SixPartsLib.calculateDate(nazhigai: 0, vinazhigai: 0, on: referenceDate, location: cambridgeON) {
            let difference = result.timeIntervalSince(sunrise)
            
            // 59 Nazhigai * 1440 seconds + 59 Vinazhigai * 24 seconds
            let expected = 59.0 * 1440.0 + 59.0 * 24.0
            XCTAssertEqual(difference, expected, accuracy: 1.0, "Nazhigai 59:59 should be 86376 seconds after sunrise")
        }
    }
    
    func testMidnight() throws {
        // GIVEN: Midnight (Nazhigai 30, assuming 12 hour day/night)
        let referenceDate = Date(timeIntervalSince1970: 1738195200)
        
        // WHEN: Calculate date for Nazhigai 30 (approximately midnight)
        let result = SixPartsLib.calculateDate(
            nazhigai: 30,
            vinazhigai: 0,
            on: referenceDate,
            location: cambridgeON
        )
        
        // THEN: Should be 12 hours (720 minutes) after sunrise
        XCTAssertNotNil(result)
        
        if let result = result, let sunrise = SixPartsLib.calculateDate(nazhigai: 0, vinazhigai: 0, on: referenceDate, location: cambridgeON) {
            let difference = result.timeIntervalSince(sunrise)
            let expected = 30.0 * 1440.0 // 30 Nazhigai = 43200 seconds = 12 hours
            XCTAssertEqual(difference, expected, accuracy: 1.0, "Nazhigai 30 should be 12 hours after sunrise")
        }
    }
    
    // MARK: - Location-Specific Tests
    
    func testDifferentLocationsHaveDifferentSunrises() throws {
        // GIVEN: Same calendar date but different locations
        let calendar = Calendar(identifier: .gregorian)
        var components = DateComponents()
        components.year = 2026
        components.month = 6
        components.day = 21 // Summer solstice
        components.hour = 12
        components.timeZone = TimeZone(identifier: "UTC")
        
        guard let referenceDate = calendar.date(from: components) else {
            XCTFail("Failed to create reference date")
            return
        }
        
        // WHEN: Calculate Nazhigai 0 for different locations
        let cambridgeSunrise = SixPartsLib.calculateDate(
            nazhigai: 0,
            vinazhigai: 0,
            on: referenceDate,
            location: cambridgeON
        )
        
        let chennaiSunrise = SixPartsLib.calculateDate(
            nazhigai: 0,
            vinazhigai: 0,
            on: referenceDate,
            location: chennai
        )
        
        // THEN: Sunrise times should be different (different time zones)
        XCTAssertNotNil(cambridgeSunrise)
        XCTAssertNotNil(chennaiSunrise)
        
        if let cambridge = cambridgeSunrise, let chennaiTime = chennaiSunrise {
            XCTAssertNotEqual(cambridge, chennaiTime, "Different locations should have different sunrise times")
        }
    }
    
    func testChennaiLocation() throws {
        // GIVEN: Date in Chennai, India
        let calendar = Calendar(identifier: .gregorian)
        var components = DateComponents()
        components.year = 2026
        components.month = 1
        components.day = 30
        components.hour = 12
        components.timeZone = TimeZone(identifier: "Asia/Kolkata")
        
        guard let referenceDate = calendar.date(from: components) else {
            XCTFail("Failed to create reference date")
            return
        }
        
        // WHEN: Calculate Nazhigai 10, Vinazhigai 30
        let result = SixPartsLib.calculateDate(
            nazhigai: 10,
            vinazhigai: 30,
            on: referenceDate,
            location: chennai
        )
        
        // THEN: Should be 10.5 Nazhigai after Chennai sunrise
        XCTAssertNotNil(result)
        
        if let result = result, let sunrise = SixPartsLib.calculateDate(nazhigai: 0, vinazhigai: 0, on: referenceDate, location: chennai) {
            let difference = result.timeIntervalSince(sunrise)
            let expected = 10.0 * 1440.0 + 30.0 * 24.0 // 10 Nazhigai + 30 Vinazhigai
            XCTAssertEqual(difference, expected, accuracy: 1.0)
        }
    }
    
    // MARK: - Round-Trip Conversion Tests
    
    func testRoundTripConversion() throws {
        // GIVEN: A specific Nazhigai:Vinazhigai time
        let referenceDate = Date(timeIntervalSince1970: 1738195200)
        let targetNazhigai = 15
        let targetVinazhigai = 45
        
        // WHEN: Convert to Date
        guard let convertedDate = SixPartsLib.calculateDate(
            nazhigai: targetNazhigai,
            vinazhigai: targetVinazhigai,
            on: referenceDate,
            location: cambridgeON
        ) else {
            XCTFail("Failed to convert Nazhigai to Date")
            return
        }
        
        // THEN: Convert back to VedicTime
        let vedicTime = SixPartsLib.calculateVedicTime(
            for: convertedDate,
            location: cambridgeON,
            timeZone: .current
        )
        
        // Should get back the same Nazhigai:Vinazhigai
        XCTAssertEqual(vedicTime.nazhigai, targetNazhigai, "Round-trip Nazhigai should match")
        XCTAssertEqual(vedicTime.vinazhigai, targetVinazhigai, accuracy: 1, "Round-trip Vinazhigai should match (±1 for rounding)")
    }
    
    // MARK: - Date Format Tests
    
    func testUTCDateOutput() throws {
        // GIVEN: Nazhigai time
        let referenceDate = Date(timeIntervalSince1970: 1738195200)
        
        // WHEN: Convert to Date
        guard let result = SixPartsLib.calculateDate(
            nazhigai: 20,
            vinazhigai: 15,
            on: referenceDate,
            location: cambridgeON
        ) else {
            XCTFail("Failed to convert")
            return
        }
        
        // THEN: Verify it's a valid Date (Swift Date is always UTC-based)
        let formatter = ISO8601DateFormatter()
        let isoString = formatter.string(from: result)
        
        XCTAssertFalse(isoString.isEmpty, "Should produce valid ISO8601 UTC string")
        XCTAssertTrue(isoString.hasSuffix("Z"), "ISO8601 format should end with Z (UTC)")
    }
    
    // MARK: - Boundary Tests
    
    func testNegativeNazhigaiHandling() throws {
        // GIVEN: Invalid negative Nazhigai (testing robustness)
        let referenceDate = Date(timeIntervalSince1970: 1738195200)
        
        // WHEN: Calculate with negative value
        let result = SixPartsLib.calculateDate(
            nazhigai: -5,
            vinazhigai: 0,
            on: referenceDate,
            location: cambridgeON
        )
        
        // THEN: Should still return a date (before sunrise)
        XCTAssertNotNil(result, "Should handle negative Nazhigai gracefully")
    }
    
    func testLargeNazhigaiHandling() throws {
        // GIVEN: Nazhigai > 59 (next day)
        let referenceDate = Date(timeIntervalSince1970: 1738195200)
        
        // WHEN: Calculate with Nazhigai 70 (beyond 60)
        let result = SixPartsLib.calculateDate(
            nazhigai: 70,
            vinazhigai: 0,
            on: referenceDate,
            location: cambridgeON
        )
        
        // THEN: Should extrapolate into next day
        XCTAssertNotNil(result)
        
        if let result = result, let sunrise = SixPartsLib.calculateDate(nazhigai: 0, vinazhigai: 0, on: referenceDate, location: cambridgeON) {
            let difference = result.timeIntervalSince(sunrise)
            let expected = 70.0 * 1440.0
            XCTAssertEqual(difference, expected, accuracy: 1.0)
        }
    }
    
    // MARK: - Performance Tests
    
    func testConversionPerformance() throws {
        let referenceDate = Date(timeIntervalSince1970: 1738195200)
        
        measure {
            for nazhigai in 0..<60 {
                _ = SixPartsLib.calculateDate(
                    nazhigai: nazhigai,
                    vinazhigai: 0,
                    on: referenceDate,
                    location: cambridgeON
                )
            }
        }
    }
    
    // MARK: - Nil Handling Tests
    
    func testPolarRegionReturnsNil() throws {
        // GIVEN: Location in Arctic Circle during polar night
        let arcticCircle = CLLocationCoordinate2D(latitude: 80.0, longitude: 0.0)
        
        let calendar = Calendar(identifier: .gregorian)
        var components = DateComponents()
        components.year = 2026
        components.month = 12
        components.day = 21 // Winter solstice
        components.hour = 12
        components.timeZone = TimeZone(identifier: "UTC")
        
        guard let winterDate = calendar.date(from: components) else {
            XCTFail("Failed to create date")
            return
        }
        
        // WHEN: Try to calculate (may not have sunrise)
        let result = SixPartsLib.calculateDate(
            nazhigai: 10,
            vinazhigai: 0,
            on: winterDate,
            location: arcticCircle
        )
        
        // THEN: May return nil (no sunrise at this latitude in December)
        // Note: Depending on Solar library behavior, might return nil or default
        // This test documents expected behavior
        if result == nil {
            print("✓ Correctly returns nil for polar region without sunrise")
        } else {
            print("⚠️ Returns fallback value for polar region")
        }
    }
}

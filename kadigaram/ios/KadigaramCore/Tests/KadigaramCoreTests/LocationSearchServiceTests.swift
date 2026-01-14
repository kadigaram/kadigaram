import XCTest
import CoreLocation
@testable import KadigaramCore

final class LocationSearchServiceTests: XCTestCase {
    
    var service: LocationSearchService!
    
    override func setUp() {
        super.setUp()
        service = LocationSearchService()
    }
    
    override func tearDown() {
        service = nil
        super.tearDown()
    }
    
    func testLocationResultInit() {
        // Given
        let name = "Test City"
        let lat = 12.34
        let lon = 56.78
        let timeZone = TimeZone(identifier: "Asia/Kolkata")
        
        // When
        let result = LocationResult(name: name, latitude: lat, longitude: lon, timeZone: timeZone)
        
        // Then
        XCTAssertEqual(result.name, name)
        XCTAssertEqual(result.latitude, lat)
        XCTAssertEqual(result.longitude, lon)
        XCTAssertEqual(result.timeZoneIdentifier, timeZone?.identifier)
        XCTAssertEqual(result.coordinate.latitude, lat)
        XCTAssertEqual(result.coordinate.longitude, lon)
        XCTAssertNotNil(result.id)
    }
    
    func testEmptyQueryReturnsEmpty() async throws {
        // Given
        let query = ""
        
        // When
        let results = try await service.search(query: query)
        
        // Then
        XCTAssertTrue(results.isEmpty, "Search should return empty list for empty query")
    }
    
    func testShortQueryReturnsEmpty() async throws {
        // Given
        let query = "A" // Too short based on implementation (> 1 char)
        
        // When
        let results = try await service.search(query: query)
        
        // Then
        XCTAssertTrue(results.isEmpty, "Search should return empty list for query with 1 character")
    }
    
    // Note: Testing actual search using MKLocalSearch requires network and entitlement,
    // which makes it an integration test rather than a unit test.
    // For unit tests, we primarily test the guard clauses and data model logic.
}

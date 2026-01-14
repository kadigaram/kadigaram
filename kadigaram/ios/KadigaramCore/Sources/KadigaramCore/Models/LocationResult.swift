import Foundation
import CoreLocation

/// Represents a location result from a search.
/// simplified for storage and UI display.
public struct LocationResult: Identifiable, Hashable, Codable {
    public let id: UUID
    public let name: String
    public let latitude: Double
    public let longitude: Double
    // TimeZone is not Codable by default, so we store identifier
    public let timeZoneIdentifier: String?
    
    public var timeZone: TimeZone? {
        guard let id = timeZoneIdentifier else { return nil }
        return TimeZone(identifier: id)
    }
    
    public var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    public init(id: UUID = UUID(), name: String, latitude: Double, longitude: Double, timeZoneIdentifier: String? = nil) {
        self.id = id
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.timeZoneIdentifier = timeZoneIdentifier
    }
    
    public init(id: UUID = UUID(), name: String, latitude: Double, longitude: Double, timeZone: TimeZone? = nil) {
        self.id = id
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.timeZoneIdentifier = timeZone?.identifier
    }
}

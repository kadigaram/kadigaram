import Foundation
import MapKit
import CoreLocation

public class LocationSearchService {
    public init() {}
    
    /// Searches for locations matching the query string.
    /// - Parameter query: The search text (e.g. "Chennai").
    /// - Returns: An array of LocationResult objects.
    public func search(query: String) async throws -> [LocationResult] {
        guard query.trimmingCharacters(in: .whitespacesAndNewlines).count > 1 else {
            return []
        }
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        request.resultTypes = .address
        
        let search = MKLocalSearch(request: request)
        let response = try await search.start()
        
        return response.mapItems.compactMap { item in
            guard let location = item.placemark.location else { return nil }
            
            // Format name nicely: "City, State, Country"
            let name = formatPlacemark(item.placemark)
            
            return LocationResult(
                name: name,
                latitude: location.coordinate.latitude,
                longitude: location.coordinate.longitude,
                timeZone: item.timeZone
            )
        }
    }
    
    private func formatPlacemark(_ placemark: MKPlacemark) -> String {
        var components: [String] = []
        
        if let locality = placemark.locality {
            components.append(locality)
        } else if let name = placemark.name {
            components.append(name)
        }
        
        if let adminArea = placemark.administrativeArea {
            components.append(adminArea)
        }
        
        if let country = placemark.country {
            components.append(country)
        }
        
        if components.isEmpty {
            return placemark.title ?? "Unknown Location"
        }
        
        return components.joined(separator: ", ")
    }
}

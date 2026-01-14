import Foundation
import CoreLocation
import Solar

/// Protocol for astronomical calculations (sunrise, sunset, etc.)
/// Allows swapping implementations (e.g., Solar, SwissEph) without changing client code
public protocol AstronomicalEngineProvider {
    /// Calculate sunrise for a given date and location
    func sunrise(for date: Date, at coordinate: CLLocationCoordinate2D, timeZone: TimeZone) -> Date?
    
    /// Calculate sunset for a given date and location
    func sunset(for date: Date, at coordinate: CLLocationCoordinate2D, timeZone: TimeZone) -> Date?
}

/// Concrete implementation using Solar library (Naval Observatory algorithm)
/// Includes 3-day caching to avoid redundant calculations
public class SolarAstronomicalEngine: AstronomicalEngineProvider {
    
    // MARK: - Cache
    
    private struct CacheKey: Hashable {
        let date: String // YYYY-MM-DD format
        let latitude: Double
        let longitude: Double
        
        init(date: Date, coordinate: CLLocationCoordinate2D) {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            self.date = formatter.string(from: date)
            self.latitude = coordinate.latitude
            self.longitude = coordinate.longitude
        }
    }
    
    private struct CachedResult {
        let sunrise: Date?
        let sunset: Date?
        let timestamp: Date
    }
    
    private var cache: [CacheKey: CachedResult] = [:]
    private let cacheExpiration: TimeInterval = 3 * 24 * 60 * 60 // 3 days in seconds
    
    public init() {}
    
    // MARK: - Public API
    
    public func sunrise(for date: Date, at coordinate: CLLocationCoordinate2D, timeZone: TimeZone) -> Date? {
        let key = CacheKey(date: date, coordinate: coordinate)
        
        // Check cache first
        if let cached = cache[key], Date().timeIntervalSince(cached.timestamp) < cacheExpiration {
            return cached.sunrise
        }
        
        // Calculate fresh value
        guard let solar = Solar(for: date, coordinate: coordinate) else {
            return nil
        }
        
        let sunrise = solar.sunrise
        let sunset = solar.sunset
        
        // Update cache
        cache[key] = CachedResult(sunrise: sunrise, sunset: sunset, timestamp: Date())
        
        // Clean old cache entries (keep only last 10 locations)
        if cache.count > 10 {
            let sortedKeys = cache.keys.sorted { cache[$0]!.timestamp > cache[$1]!.timestamp }
            for oldKey in sortedKeys.dropFirst(10) {
                cache.removeValue(forKey: oldKey)
            }
        }
        
        return sunrise
    }
    
    public func sunset(for date: Date, at coordinate: CLLocationCoordinate2D, timeZone: TimeZone) -> Date? {
        let key = CacheKey(date: date, coordinate: coordinate)
        
        // Check cache first
        if let cached = cache[key], Date().timeIntervalSince(cached.timestamp) < cacheExpiration {
            return cached.sunset
        }
        
        // Calculate fresh value
        guard let solar = Solar(for: date, coordinate: coordinate) else {
            return nil
        }
        
        let sunrise = solar.sunrise
        let sunset = solar.sunset
        
        // Update cache
        cache[key] = CachedResult(sunrise: sunrise, sunset: sunset, timestamp: Date())
        
        // Clean old cache entries (keep only last 10 locations)
        if cache.count > 10 {
            let sortedKeys = cache.keys.sorted { cache[$0]!.timestamp > cache[$1]!.timestamp }
            for oldKey in sortedKeys.dropFirst(10) {
                cache.removeValue(forKey: oldKey)
            }
        }
        
        return sunset
    }
}

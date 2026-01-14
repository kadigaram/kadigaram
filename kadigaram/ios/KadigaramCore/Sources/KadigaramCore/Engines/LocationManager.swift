import Foundation
import CoreLocation

public class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    @Published public var location: CLLocationCoordinate2D?
    @Published public var locationName: String = "Unknown"
    @Published public var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published public var isManual: Bool = false
    
    public override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyKilometer
    }
    
    public func requestPermission() {
        manager.requestWhenInUseAuthorization()
    }
    
    public func startLocation() {
        self.isManual = false
        manager.startUpdatingLocation()
    }
    
    public func stopLocation() {
        manager.stopUpdatingLocation()
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard !isManual else { return }
        guard let loc = locations.last else { return }
        self.location = loc.coordinate
        // Reverse geocode could go here
    }
    
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        self.authorizationStatus = manager.authorizationStatus
    }
    
    public func setManualLocation(latitude: Double, longitude: Double, name: String) {
        self.isManual = true
        self.stopLocation()
        self.location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        self.locationName = name
    }
}

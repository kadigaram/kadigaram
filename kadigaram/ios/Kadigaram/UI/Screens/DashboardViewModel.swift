import SwiftUI
import Combine
import CoreLocation
import KadigaramCore

@MainActor
class DashboardViewModel: ObservableObject {
    @Published var vedicTime: VedicTime
    @Published var vedicDate: VedicDate
    @Published var currentDate: Date = Date()
    
    private let engine: VedicEngineProvider
    private let locationManager: LocationManager
    private let appConfig: AppConfig // Needed for calendar system
    private var timer: AnyCancellable?
    
    // Default Chennai coordinates if location missing (Verification fallback)
    private let defaultLocation = CLLocationCoordinate2D(latitude: 13.0827, longitude: 80.2707)
    
    init(engine: VedicEngineProvider = VedicEngine(), locationManager: LocationManager = LocationManager(), appConfig: AppConfig = AppConfig()) {
        self.engine = engine
        self.locationManager = locationManager
        self.appConfig = appConfig
        
        // Initial Dummy Data
        self.vedicTime = VedicTime(nazhigai: 0, vinazhigai: 0, percentElapsed: 0, sunrise: Date(), sunset: Date(), isDaytime: true)
        self.vedicDate = VedicDate(samvatsara: "year_krodhi", maasa: "month_margazhi", paksha: .shukla, tithi: "tithi_ekadashi", tithiProgress: 0.0, nakshatra: "nakshatra_visakam", nakshatraProgress: 0.0, day: 1)
        
        setupTimer()
        locationManager.startLocation()
    }
    
    func setupTimer() {
        // 60 FPS Timer
        timer = Timer.publish(every: 0.016, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.updateTime()
            }
    }
    
    func updateTime() {
        currentDate = Date()
        let loc = locationManager.location ?? defaultLocation
        
        // Mock Sunrise/Sunset for MVP loop (Real app would calc from engine or api)
        let sunrise = Calendar.current.startOfDay(for: currentDate).addingTimeInterval(6 * 3600) // 6 AM
        let sunset = sunrise.addingTimeInterval(12 * 3600) // 6 PM
        
        self.vedicTime = engine.calculateVedicTime(date: currentDate, location: loc, sunrise: sunrise, sunset: sunset)
        
        Task {
            self.vedicDate = await engine.calculateVedicDate(date: currentDate, location: loc, calendarSystem: appConfig.calendarSystem)
        }
    }
}

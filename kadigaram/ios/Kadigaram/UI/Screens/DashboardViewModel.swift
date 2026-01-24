import SwiftUI
import Combine
import CoreLocation
import KadigaramCore
import SixPartsLib  // Import for TamilDate

@MainActor
class DashboardViewModel: ObservableObject {
    @Published var vedicTime: VedicTime
    @Published var vedicDate: VedicDate
    @Published var tamilDate: TamilDate?  // Tamil calendar date
    @Published var currentDate: Date = Date()
    
    private let engine: VedicEngineProvider
    private let locationManager: LocationManager
    private let appConfig: AppConfig // Needed for calendar system
    private let astronomicalEngine: AstronomicalEngineProvider
    private var timer: AnyCancellable?
    
    // Default Chennai coordinates if location missing (Verification fallback)
    private let defaultLocation = CLLocationCoordinate2D(latitude: 13.0827, longitude: 80.2707)
    
    init(engine: VedicEngineProvider = VedicEngine(), locationManager: LocationManager = LocationManager(), appConfig: AppConfig = AppConfig(), astronomicalEngine: AstronomicalEngineProvider = SolarAstronomicalEngine()) {
        self.engine = engine
        self.locationManager = locationManager
        self.appConfig = appConfig
        self.astronomicalEngine = astronomicalEngine
        
        // Initial Dummy Data
        self.vedicTime = VedicTime(nazhigai: 0, vinazhigai: 0, percentElapsed: 0, progressIndicatorAngle: 0.0, sunrise: Date(), sunset: Date(), isDaytime: true)
        self.vedicDate = VedicDate(samvatsara: "year_krodhi", samvatsaraIndex: 38, maasa: "month_margazhi", paksha: .shukla, pakshamIllumination: 0.5, tithi: "tithi_ekadashi", tithiProgress: 0.0, tithiNumber: 11, nakshatra: "nakshatra_visakam", nakshatraProgress: 0.0, nakshatraNumber: 16, day: 1)
        
        setupTimer()
        locationManager.requestPermission()
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
        
        let loc: CLLocationCoordinate2D
        let timeZone: TimeZone
        
        if appConfig.isManualLocation {
            loc = CLLocationCoordinate2D(latitude: appConfig.manualLatitude, longitude: appConfig.manualLongitude)
            if let tzId = appConfig.manualTimeZone, let tz = TimeZone(identifier: tzId) {
                timeZone = tz
            } else {
                timeZone = TimeZone.current
            }
            
            // Sync LocationManager state if needed (optional, purely for UI consistency if UI reads LocationManager)
            if !locationManager.isManual {
                locationManager.setManualLocation(latitude: loc.latitude, longitude: loc.longitude, name: appConfig.manualLocationName)
            }
        } else {
            if locationManager.isManual {
                locationManager.startLocation() // Resume GPS if we were manual
            }
            loc = locationManager.location ?? defaultLocation
            timeZone = TimeZone.current
        }
        
        // Use astronomical engine for real sunrise/sunset calculations
        self.vedicTime = engine.calculateVedicTime(date: currentDate, location: loc, astronomicalEngine: astronomicalEngine, timeZone: timeZone)
        
        // Calculate Tamil date using SixPartsLib
        self.tamilDate = SixPartsLib.calculateTamilDate(for: currentDate, location: loc, timeZone: timeZone)
        
        Task {
            self.vedicDate = await engine.calculateVedicDate(date: currentDate, location: loc, calendarSystem: appConfig.calendarSystem)
        }
    }
}

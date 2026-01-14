import Foundation

public enum AppLanguage: String, CaseIterable, Codable {
    case english = "en"
    case sanskrit = "sa"
    case tamil = "ta"
    case telugu = "te"
    case kannada = "kn"
    case malayalam = "ml"
}

public enum CalendarSystem: String, CaseIterable, Codable {
    case solar
    case lunar
}

public class AppConfig: ObservableObject {
    @Published public var language: AppLanguage {
        didSet {
            UserDefaults.standard.set(language.rawValue, forKey: "user_locale")
        }
    }
    
    @Published public var calendarSystem: CalendarSystem {
        didSet {
            UserDefaults.standard.set(calendarSystem.rawValue, forKey: "calendar_mode")
        }
    }
    
    @Published public var isManualLocation: Bool {
        didSet {
            UserDefaults.standard.set(isManualLocation, forKey: "is_manual_location")
        }
    }
    
    @Published public var manualLatitude: Double {
        didSet {
            UserDefaults.standard.set(manualLatitude, forKey: "manual_lat")
        }
    }
    
    @Published public var manualLongitude: Double {
        didSet {
            UserDefaults.standard.set(manualLongitude, forKey: "manual_long")
        }
    }
    
    public init() {
        self.language = AppLanguage(rawValue: UserDefaults.standard.string(forKey: "user_locale") ?? "en") ?? .english
        self.calendarSystem = CalendarSystem(rawValue: UserDefaults.standard.string(forKey: "calendar_mode") ?? "solar") ?? .solar
        self.isManualLocation = UserDefaults.standard.bool(forKey: "is_manual_location")
        self.manualLatitude = UserDefaults.standard.double(forKey: "manual_lat") // Default 0.0
        self.manualLongitude = UserDefaults.standard.double(forKey: "manual_long")
        
        // Default to Chennai if 0.0 (fresh install)
        if self.manualLatitude == 0.0 && self.manualLongitude == 0.0 {
            self.manualLatitude = 13.0827
            self.manualLongitude = 80.2707
        }
    }
}

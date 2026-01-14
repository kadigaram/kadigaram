import Foundation
import Combine

public protocol BhashaEngineProvider: ObservableObject {
    var currentLanguage: AppLanguage { get }
    func setLanguage(_ language: AppLanguage)
    func localizedString(_ key: String) -> String
}

public class BhashaEngine: BhashaEngineProvider {
    @Published public var currentLanguage: AppLanguage
    
    // In-memory cache for loaded bundles if we were using .lproj directly
    // iOS 15+ String Catalogs handles much of this, but for *forcing* language
    // strictly inside the app independent of system, we might need manual Bundle lookup.
    
    public init(initialLanguage: AppLanguage = .english) {
        // Load from persisted choice or default
        let savedLang = UserDefaults.standard.string(forKey: "user_locale") ?? initialLanguage.rawValue
        self.currentLanguage = AppLanguage(rawValue: savedLang) ?? initialLanguage
    }
    
    public func setLanguage(_ language: AppLanguage) {
        self.currentLanguage = language
        UserDefaults.standard.set(language.rawValue, forKey: "user_locale")
        // Trigger UI updates via Published property
    }
    
    public func localizedString(_ key: String) -> String {
        // 1. Find the path for the current language
        // Note: String Catalogs (.xcstrings) compile into .loctable or .strings files in .lproj folders derived from the catalog.
        // We look for the bundle associated with the selected language code.
        
        print("[BhashaEngine] Requesting key: '\(key)' for language: '\(currentLanguage.rawValue)'")
        
        // Log Bundle.main path to verify identifying the correct bundle
        print("[BhashaEngine] Main Bundle Path: \(Bundle.main.bundlePath)")

        guard let path = Bundle.main.path(forResource: currentLanguage.rawValue, ofType: "lproj") else {
            print("[BhashaEngine] FAILED: Could not find path for resource '\(currentLanguage.rawValue)' of type 'lproj' in Bundle.main")
            return NSLocalizedString(key, comment: "")
        }
        
        print("[BhashaEngine] SUCCESS: Found lproj path: \(path)")
        
        guard let bundle = Bundle(path: path) else {
             print("[BhashaEngine] FAILED: Could not create Bundle from path: \(path)")
             return NSLocalizedString(key, comment: "")
        }
        
        let result = NSLocalizedString(key, tableName: nil, bundle: bundle, value: "", comment: "")
        print("[BhashaEngine] Translated '\(key)' -> '\(result)'")
        
        return result
    }
}

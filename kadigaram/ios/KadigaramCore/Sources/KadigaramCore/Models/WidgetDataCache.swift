//
//  WidgetDataCache.swift
//  KadigaramCore
//
//  Created for Feature 006: Clock UI Improvements
//

import Foundation
import WidgetKit
import SixPartsLib

/// Data cache for sharing information between app and widget via App Groups
/// Must be public to be accessible from App and Widget targets
@MainActor
public class WidgetDataCache: ObservableObject {
    // MARK: Singleton
    
    public static let shared = WidgetDataCache()
    
    // MARK: Properties
    
    private let appGroupIdentifier = "group.com.kadigaram.app"
    private let sharedDefaults: UserDefaults?
    
    // MARK: Keys
    
    private enum Keys {
        static let locationName = "widgetLocationName"
        static let latitude = "widgetLatitude"
        static let longitude = "widgetLongitude"
        static let timeZone = "widgetTimeZone"
    }
    
    // MARK: Initialization
    
    public init() {
        sharedDefaults = UserDefaults(suiteName: appGroupIdentifier)
        if sharedDefaults == nil {
            print("⚠️ [WidgetDataCache] Failed to initialize UserDefaults with suite \(appGroupIdentifier)")
        }
    }
    
    // MARK: Public Methods
    
    /// Saves location data for widget access
    /// - Parameter location: Location to save
    public func saveLocation(_ location: LocationResult) {
        sharedDefaults?.set(location.name, forKey: Keys.locationName)
        sharedDefaults?.set(location.latitude, forKey: Keys.latitude)
        sharedDefaults?.set(location.longitude, forKey: Keys.longitude)
        sharedDefaults?.set(location.timeZoneIdentifier, forKey: Keys.timeZone)
        
        // Trigger reload when location changes
        triggerWidgetReload()
    }
    
    /// Retrieves location data for widget
    /// - Returns: Location data if available
    public func retrieveLocation() -> LocationResult? {
        guard let name = sharedDefaults?.string(forKey: Keys.locationName),
              let lat = sharedDefaults?.double(forKey: Keys.latitude),
              let lon = sharedDefaults?.double(forKey: Keys.longitude) else {
            return nil
        }
        
        let tzId = sharedDefaults?.string(forKey: Keys.timeZone)
        
        return LocationResult(
            name: name,
            latitude: lat,
            longitude: lon,
            timeZoneIdentifier: tzId
        )
    }
    
    /// Triggers widget timeline reload
    public func triggerWidgetReload() {
        print("🔄 [WidgetDataCache] Triggering widget reload")
        WidgetCenter.shared.reloadTimelines(ofKind: "KadigaramWidget")
    }
    
    /// Triggers widget reload for specific kind
    /// - Parameter kind: Widget kind identifier
    public func triggerWidgetReload(ofKind kind: String) {
        WidgetCenter.shared.reloadTimelines(ofKind: kind)
    }
}

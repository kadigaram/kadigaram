//
//  Contracts/Protocols.swift
//  Kadigaram
//
//  Defines the core interfaces for the application engines.
//

import Foundation
import CoreLocation

/// Manages the in-app language state independent of System Locale.
protocol BhashaEngine: ObservableObject {
    var currentLanguage: AppLanguage { get }
    
    /// Forces a language change and reloads the Bundle.
    /// - Parameter language: The target language.
    func setLanguage(_ language: AppLanguage)
    
    /// localizedString("key", table: "Sanskrit")
    func localizedString(_ key: String) -> String
}

/// Calculates Vedic time components based on Solar position.
protocol VedicEngine {
    /// Calculates the Nazhigai time for a given Date and Location.
    func calculateVedicTime(date: Date, location: CLLocationCoordinate2D) async -> VedicTime
    
    /// Calculates the full Panchangam date components.
    func calculateVedicDate(date: Date, location: CLLocationCoordinate2D) async -> VedicDate
}

/// Manages Solar events (Sunrise/Sunset).
protocol SolarEngine {
    func getSunriseSunset(for date: Date, at location: CLLocationCoordinate2D) -> (sunrise: Date, sunset: Date)?
}

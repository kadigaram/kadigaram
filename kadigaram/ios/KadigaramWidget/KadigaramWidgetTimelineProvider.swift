//
//  KadigaramWidgetTimelineProvider.swift
//  KadigaramWidget
//
//  Created for Feature 006: Clock UI Improvements
//

import WidgetKit
import SwiftUI
import CoreLocation
import KadigaramCore
import SixPartsLib

struct KadigaramWidgetTimelineProvider: TimelineProvider {
    let configuration = WidgetTimelineConfiguration.default
    
    // Engines
    // Use engines from library
    let engine = VedicEngine()
    let astronomicalEngine = SolarAstronomicalEngine() // or similar available engine
    
    func placeholder(in context: Context) -> ClockWidgetEntry {
        ClockWidgetEntry(
            date: Date(),
            locationName: "Chennai",
            vedicTime: nil,
            moonPhase: nil,
            nazhigai: 30,
            tamilDate: "Thai 1"
        )
    }

    func getSnapshot(in context: Context, completion: @escaping (ClockWidgetEntry) -> ()) {
        Task {
            let entry = await createEntry(for: Date())
            completion(entry)
        }
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<ClockWidgetEntry>) -> ()) {
        Task {
            var entries: [ClockWidgetEntry] = []
            let currentDate = Date()
            
            // Generate entries based on configuration
            // Default 24 entries, every 60 mins
            
            for i in 0..<configuration.numberOfEntries {
                let secondsOffset = i * configuration.timelineIntervalSeconds
                if let entryDate = Calendar.current.date(byAdding: .second, value: secondsOffset, to: currentDate) {
                    let entry = await createEntry(for: entryDate)
                    entries.append(entry)
                }
            }
            
            // Refresh policy
            // Refresh policy
            let policy = configuration.refreshPolicy.toWidgetKitPolicy()
            let completionTimeline = Timeline(entries: entries, policy: policy)
            completion(completionTimeline)
        }
    }
    
    // MARK: - Helper Methods
    
    // MARK: - Helper Methods
    
    @MainActor
    private func createEntry(for date: Date) async -> ClockWidgetEntry {
        let location = WidgetDataCache.shared.retrieveLocation()
        let coordinate = location?.coordinate ?? CLLocationCoordinate2D(latitude: 13.0827, longitude: 80.2707)
        let locationName = location?.name ?? "Chennai"
        let timeZone = TimeZone(identifier: location?.timeZoneIdentifier ?? "") ?? TimeZone.current
        
        let appConfig = AppConfig()
        let bhashaEngine = BhashaEngine()
        
        // 1. Vedic Time
        let vedicTime = engine.calculateVedicTime(
            date: date,
            location: coordinate,
            astronomicalEngine: astronomicalEngine,
            timeZone: timeZone
        )
        
        // 2. Tamil Date
        // 2. Tamil Date
        let td = SixPartsLib.calculateTamilDate(for: date, location: coordinate, timeZone: timeZone)
        let month = bhashaEngine.localizedString(td.monthName)
        let tamilDateString = "\(month) \(td.dayNumber)"
        
        // 3. Vedic Date (Tithi)
        // This is async, so the function must be async
        let vedicDate = await engine.calculateVedicDate(
            date: date,
            location: coordinate,
            calendarSystem: appConfig.calendarSystem // Use shared pref
        )
        
        // Map Tithi to Moon Phase String (localized)
        let tithiName = bhashaEngine.localizedString(vedicDate.tithi)
        
        return ClockWidgetEntry(
            date: date,
            locationName: locationName,
            vedicTime: vedicTime,
            moonPhase: tithiName,
            nazhigai: vedicTime.nazhigai,
            tamilDate: tamilDateString
        )
    }
}

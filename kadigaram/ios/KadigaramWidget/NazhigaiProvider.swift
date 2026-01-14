import WidgetKit
import SwiftUI
import CoreLocation
import KadigaramCore

struct NazhigaiEntry: TimelineEntry {
    let date: Date
    let vedicTime: VedicTime
}

struct NazhigaiProvider: TimelineProvider {
    let engine = VedicEngine()
    let astronomicalEngine = SolarAstronomicalEngine()
    
    // Default location for now (Chennai) until we implement shared location config
    let defaultLocation = CLLocationCoordinate2D(latitude: 13.0827, longitude: 80.2707)
    
    func placeholder(in context: Context) -> NazhigaiEntry {
        NazhigaiEntry(date: Date(), vedicTime: VedicTime(nazhigai: 30, vinazhigai: 0, percentElapsed: 0.5, progressIndicatorAngle: 180.0, sunrise: Date(), sunset: Date(), isDaytime: true))
    }

    func getSnapshot(in context: Context, completion: @escaping (NazhigaiEntry) -> ()) {
        let entry = NazhigaiEntry(date: Date(), vedicTime: VedicTime(nazhigai: 30, vinazhigai: 0, percentElapsed: 0.5, progressIndicatorAngle: 180.0, sunrise: Date(), sunset: Date(), isDaytime: true))
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<NazhigaiEntry>) -> ()) {
        // Generate 24-hour timeline with 5-minute intervals (288 entries)
        var entries: [NazhigaiEntry] = []
        let currentDate = Date()
        
        // Start from current time rounded to nearest 5 minutes
        let calendar = Calendar.current
        let minute = calendar.component(.minute, from: currentDate)
        let roundedMinute = (minute / 5) * 5
        let startDate = calendar.date(bySetting: .minute, value: roundedMinute, of: currentDate)!
        
        for offset in 0 ..< 288 {
            guard let entryDate = calendar.date(byAdding: .minute, value: offset * 5, to: startDate) else { continue }
            
            // Calculate Vedic time for this entry
            // This implicitly handles day boundaries as AstronomicalEngine will calculate
            // appropriate sunrise/sunset for the given entryDate
            let time = engine.calculateVedicTime(date: entryDate, location: defaultLocation, astronomicalEngine: astronomicalEngine, timeZone: TimeZone.current)
            
            let entry = NazhigaiEntry(date: entryDate, vedicTime: time)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

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
    
    // Default location for now (Chennai) until we implement shared location config
    let defaultLocation = CLLocationCoordinate2D(latitude: 13.0827, longitude: 80.2707)
    
    func placeholder(in context: Context) -> NazhigaiEntry {
        NazhigaiEntry(date: Date(), vedicTime: VedicTime(nazhigai: 30, vinazhigai: 0, percentElapsed: 0.5, sunrise: Date(), sunset: Date(), isDaytime: true))
    }

    func getSnapshot(in context: Context, completion: @escaping (NazhigaiEntry) -> ()) {
        let entry = NazhigaiEntry(date: Date(), vedicTime: VedicTime(nazhigai: 30, vinazhigai: 0, percentElapsed: 0.5, sunrise: Date(), sunset: Date(), isDaytime: true))
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<NazhigaiEntry>) -> ()) {
        print("[Widget] Generating Timeline at \(Date())")
        // Calculate next 60 minutes of updates
        var entries: [NazhigaiEntry] = []
        let currentDate = Date()
        
        let sunrise = Calendar.current.startOfDay(for: currentDate).addingTimeInterval(6 * 3600)
        let sunset = sunrise.addingTimeInterval(12 * 3600)
        
        for minuteOffset in 0 ..< 60 {
            let entryDate = Calendar.current.date(byAdding: .minute, value: minuteOffset, to: currentDate)!
            let time = engine.calculateVedicTime(date: entryDate, location: defaultLocation, sunrise: sunrise, sunset: sunset)
            let entry = NazhigaiEntry(date: entryDate, vedicTime: time)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

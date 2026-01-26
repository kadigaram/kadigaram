//
//  ClockWidgetEntry.swift
//  KadigaramWidget
//
//  Created for Feature 006: Clock UI Improvements
//

import WidgetKit
import SixPartsLib

/// Timeline entry for Kadigaram clock widget
struct ClockWidgetEntry: TimelineEntry {
    /// Date for this timeline entry
    let date: Date
    
    /// Location name to display
    let locationName: String
    
    /// Current Vedic time information
    let vedicTime: VedicTime?
    
    /// Moon phase description (e.g. "Waxing Gibbous") if available
    let moonPhase: String?
    
    /// Nazhigai value (integer part)
    let nazhigai: Int
    
    /// Tamil month and day string
    let tamilDate: String?
}

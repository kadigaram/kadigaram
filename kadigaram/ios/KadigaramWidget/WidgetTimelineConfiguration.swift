//
//  WidgetTimelineConfiguration.swift
//  KadigaramWidget
//
//  Created for Feature 006: Clock UI Improvements
//

import Foundation

/// Manages widget update behavior and timeline entry generation
struct WidgetTimelineConfiguration {
    /// Update interval for timeline entries (in seconds)
    let timelineIntervalSeconds: Int
    
    /// Number of future entries to generate
    let numberOfEntries: Int
    
    /// Timeline refresh policy
    let refreshPolicy: WidgetRefreshPolicy
    
    /// Whether to use dynamic date formatting
    let useDynamicTimeDisplay: Bool
    
    /// Data update triggers
    let updateTriggers: [WidgetUpdateTrigger]
}

/// Defines when the widget timeline should be reloaded
enum WidgetRefreshPolicy {
    /// Reload after last timeline entry
    case atEnd
    
    /// Reload at specific date
    case after(Date)
    
    /// Never reload automatically (manual only)
    case never
}

import WidgetKit

extension WidgetRefreshPolicy {
    /// Converts configuration policy to WidgetKit policy
    func toWidgetKitPolicy() -> WidgetKit.TimelineReloadPolicy {
        switch self {
        case .atEnd:
            return .atEnd
        case .after(let date):
            return .after(date)
        case .never:
            return .never
        }
    }
}

/// Triggers that cause widget data updates
enum WidgetUpdateTrigger {
    /// User changed location
    case locationChanged
    
    /// User changed language/locale
    case localeChanged
    
    /// Significant astronomical event
    case astronomicalEvent(Date)
    
    /// App settings changed
    case settingsChanged
    
    /// System time zone changed
    case timeZoneChanged
}

// MARK: - Defaults

extension WidgetTimelineConfiguration {
    /// Default configuration for Kadigaram widget
    static var `default`: WidgetTimelineConfiguration {
        WidgetTimelineConfiguration(
            timelineIntervalSeconds: 24,  // Update every Vinazhigai (24 seconds)
            numberOfEntries: 60,          // Approx 24 minutes of future data
            refreshPolicy: .atEnd,
            useDynamicTimeDisplay: true,
            updateTriggers: [.locationChanged, .settingsChanged, .timeZoneChanged]
        )
    }
    
    /// Configuration for frequent updates (debugging)
    static var debug: WidgetTimelineConfiguration {
        WidgetTimelineConfiguration(
            timelineIntervalSeconds: 24,
            numberOfEntries: 10,
            refreshPolicy: .atEnd,
            useDynamicTimeDisplay: true,
            updateTriggers: [.locationChanged]
        )
    }
}

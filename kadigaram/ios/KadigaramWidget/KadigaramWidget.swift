//
//  KadigaramWidget.swift
//  KadigaramWidget
//
//  Created for Feature 006: Clock UI Improvements
//

import WidgetKit
import SwiftUI
import KadigaramCore

struct KadigaramWidget: Widget {
    let kind: String = "KadigaramWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: KadigaramWidgetTimelineProvider()) { entry in
            ClockWidgetEntryView(entry: entry)
                .containerBackground(for: .widget) {
                    // Start with basic background, View handles theme-specific
                     if let colorScheme = Environment(\.colorScheme).wrappedValue as ColorScheme? {
                        if colorScheme == .light {
                            Color(uiColor: .systemGray6)
                        } else {
                            Color.black
                        }
                    } else {
                        Color.black
                    }
                }
        }
        .configurationDisplayName("Kadigaram")
        .description("Shows current time and Vedic details.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

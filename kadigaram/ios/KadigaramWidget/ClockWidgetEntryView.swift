//
//  ClockWidgetEntryView.swift
//  KadigaramWidget
//
//  Created for Feature 006: Clock UI Improvements
//

import SwiftUI
import WidgetKit
import KadigaramCore
import SixPartsLib

struct ClockWidgetEntryView: View {
    var entry: ClockWidgetEntry
    @Environment(\.widgetFamily) var family
    @Environment(\.colorScheme) var colorScheme
    
    // Theme colors
    private var isDaytime: Bool {
        entry.vedicTime?.isDaytime ?? true
    }
    
    private var nazhigaiColor: Color {
        // Brighter gold during day, darker/dimmer gold at night
        if isDaytime {
            // Bright Gold
            return Color(red: 255/255, green: 215/255, blue: 0/255)
        } else {
            // Darker/Bronze Gold for night
            return Color(red: 184/255, green: 134/255, blue: 11/255)
        }
    }
    
    private var secondaryColor: Color {
        colorScheme == .dark ? .white.opacity(0.8) : Color.black.opacity(0.8)
    }
    
    var body: some View {
        ZStack {
            // Background
            if colorScheme == .light {
                Color(uiColor: .systemGray6).ignoresSafeArea()
            } else {
                Color.black.ignoresSafeArea()
            }
            
            VStack {
                switch family {
                case .systemSmall:
                    SmallWidgetView(entry: entry, nazhigaiColor: nazhigaiColor, secondaryColor: secondaryColor)
                case .systemMedium:
                    MediumWidgetView(entry: entry, nazhigaiColor: nazhigaiColor, secondaryColor: secondaryColor)
                case .systemLarge:
                    MediumWidgetView(entry: entry, nazhigaiColor: nazhigaiColor, secondaryColor: secondaryColor) // Fallback
                default:
                    SmallWidgetView(entry: entry, nazhigaiColor: nazhigaiColor, secondaryColor: secondaryColor)
                }
            }
            .padding()
        }
    }
}

// MARK: - Subviews

struct SmallWidgetView: View {
    let entry: ClockWidgetEntry
    let nazhigaiColor: Color
    let secondaryColor: Color
    
    var body: some View {
        VStack(spacing: 8) {
             // Location
            Text(entry.locationName)
                .font(.system(size: 10, weight: .medium, design: .rounded))
                .foregroundColor(secondaryColor.opacity(0.7))
                .lineLimit(1)
            
            Spacer()
            
            // Big Nazhigai
            if let time = entry.vedicTime {
                VStack(spacing: -4) {
                    Text("\(time.nazhigai)")
                         .font(.system(size: 48, weight: .black, design: .rounded)) // Hero Size
                         .foregroundColor(nazhigaiColor)
                    
                    Text("\(time.vinazhigai)")
                        .font(.system(size: 20, weight: .bold, design: .monospaced))
                        .foregroundColor(nazhigaiColor.opacity(0.8))
                }
            } else {
                // Placeholder if no data
                Text("--")
                    .font(.largeTitle)
                    .foregroundColor(secondaryColor)
            }
            
            Spacer()
            
            Text("NAZHIGAI")
                .font(.system(size: 8, weight: .semibold))
                .foregroundColor(secondaryColor.opacity(0.5))
                .tracking(1.0)
        }
    }
}

struct MediumWidgetView: View {
    let entry: ClockWidgetEntry
    let nazhigaiColor: Color
    let secondaryColor: Color
    
    var body: some View {
        HStack {
            // Left Side: Info & Date
            VStack(alignment: .leading, spacing: 6) {
                Text(entry.locationName)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(secondaryColor)
                    .lineLimit(1)
                
                Spacer()
                
                if let tamilDate = entry.tamilDate {
                    Text(tamilDate)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(secondaryColor.opacity(0.9))
                }
                
                if let phase = entry.moonPhase {
                    Text(phase)
                        .font(.caption2)
                        .foregroundColor(secondaryColor.opacity(0.6))
                }
            }
            
            Spacer()
            
            // Right Side: Hero Nazhigai
            if let time = entry.vedicTime {
                VStack(alignment: .trailing, spacing: 0) {
                    Text("NAZHIGAI")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(secondaryColor.opacity(0.5))
                        .tracking(2.0)
                    
                    HStack(alignment: .lastTextBaseline, spacing: 4) {
                        Text("\(time.nazhigai)")
                            .font(.system(size: 56, weight: .black, design: .rounded))
                            .foregroundColor(nazhigaiColor)
                            .minimumScaleFactor(0.5)
                        
                        Text(":")
                            .font(.title)
                            .foregroundColor(nazhigaiColor.opacity(0.6))
                            .offset(y: -4)
                        
                        Text(String(format: "%02d", time.vinazhigai))
                            .font(.system(size: 38, weight: .bold, design: .monospaced))
                            .foregroundColor(nazhigaiColor.opacity(0.9))
                    }
                }
            }
        }
        .padding(.horizontal, 4)
    }
}

// MARK: - Preview

struct ClockWidgetEntryView_Previews: PreviewProvider {
    static var previews: some View {
        ClockWidgetEntryView(entry: ClockWidgetEntry(
            date: Date(),
            locationName: "Chennai",
            vedicTime: VedicTime(nazhigai: 12, vinazhigai: 45, percentElapsed: 0.2, progressIndicatorAngle: 0, sunrise: Date(), sunset: Date(), isDaytime: true),
            moonPhase: "Waxing Gibbous",
            nazhigai: 12,
            tamilDate: "Thai 10"
        ))
        .previewContext(WidgetPreviewContext(family: .systemSmall))
        
        ClockWidgetEntryView(entry: ClockWidgetEntry(
            date: Date(),
            locationName: "Chennai",
            vedicTime: VedicTime(nazhigai: 55, vinazhigai: 10, percentElapsed: 0.9, progressIndicatorAngle: 0, sunrise: Date(), sunset: Date(), isDaytime: false), // Night test
            moonPhase: "Full Moon",
            nazhigai: 12,
            tamilDate: "Thai 10"
        ))
        .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}

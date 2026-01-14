import WidgetKit
import SwiftUI
import KadigaramCore

struct KadigaramWidgetEntryView : View {
    var entry: NazhigaiProvider.Entry

    var body: some View {
        VStack {
            // Title for context
            Text("Kadigaram")
                .font(.caption)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // The Wheel
            NazhigaiWheel(vedicTime: entry.vedicTime)
                .scaleEffect(0.8) // Fit in widget
        }
        .containerBackground(for: .widget) {
            Color.black
        }
        .environment(\.colorScheme, .dark) // Force dark mode for white text on black background
    }
}

struct KadigaramWidget: Widget {
    let kind: String = "KadigaramWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: NazhigaiProvider()) { entry in
            KadigaramWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Nazhigai")
        .description("Shows current Nazhigai and Vinazhigai.")
        #if os(watchOS)
        .supportedFamilies([.accessoryCircular, .accessoryRectangular, .accessoryCorner])
        #else
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
        #endif
    }
}

//
//  KadigaramWidgetLiveActivity.swift
//  KadigaramWidget
//
//  Created by Dhilip Shankaranarayanan on 2026-01-12.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct KadigaramWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct KadigaramWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: KadigaramWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension KadigaramWidgetAttributes {
    fileprivate static var preview: KadigaramWidgetAttributes {
        KadigaramWidgetAttributes(name: "World")
    }
}

extension KadigaramWidgetAttributes.ContentState {
    fileprivate static var smiley: KadigaramWidgetAttributes.ContentState {
        KadigaramWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: KadigaramWidgetAttributes.ContentState {
         KadigaramWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: KadigaramWidgetAttributes.preview) {
   KadigaramWidgetLiveActivity()
} contentStates: {
    KadigaramWidgetAttributes.ContentState.smiley
    KadigaramWidgetAttributes.ContentState.starEyes
}

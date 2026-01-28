import SwiftUI
import KadigaramCore

@main
struct KadigaramApp: App {
    /// Global theme object accessible throughout the app
    @StateObject private var theme = AppTheme.default()
    
    var body: some Scene {
        WindowGroup {
            DashboardView()
                .environmentObject(theme)
        }
    }
}

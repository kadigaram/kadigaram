import SwiftUI
import KadigaramCore

@main
struct KadigaramApp: App {
    /// Global theme object accessible throughout the app
    @StateObject private var theme = AppTheme.default()
    
    init() {
        // Register background tasks
        BackgroundTaskManager.shared.registerBackgroundTasks()
        BackgroundTaskManager.shared.scheduleAlarmSyncTask()
        
        // Sync alarms on app launch (mitigation for missed background tasks)
        Task {
            await BackgroundTaskManager.shared.syncAlarms()
        }
    }
    
    var body: some Scene {
        WindowGroup {
            DashboardView()
                .environmentObject(theme)
        }
    }
}

import SwiftUI
import KadigaramCore

struct DashboardView: View {
    @StateObject private var viewModel = DashboardViewModel()
    @StateObject private var bhashaEngine = BhashaEngine()
    @StateObject private var appConfig = AppConfig()
    @StateObject private var clockViewModel = ClockDialViewModel() // New clock VM
    @State private var showSettings = false
    @State private var showAlarms = false
    @Environment(\.scenePhase) private var scenePhase
    
    /// Theme object injected from app root
    @EnvironmentObject var theme: AppTheme
    
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.colorSchemeContrast) private var colorSchemeContrast
    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    
    /// Update theme with current accessibility settings
    private func updateAccessibilitySettings() {
        print("🎨 [Theme] Updating accessibility settings - colorScheme: \(colorScheme)")
        print("🎨 [Theme] Background color: \(theme.backgroundColor)")
        
        theme.updateAccessibilitySettings(
            increaseContrast: colorSchemeContrast == .increased,
            reduceTransparency: reduceTransparency,
            dynamicTypeSize: dynamicTypeSize,
            reduceMotion: reduceMotion
        )
        theme.applyIncreasedContrast()
    }

    
    var body: some View {
        ZStack {
            theme.backgroundColor.ignoresSafeArea()
            
            VStack {
                // Header
                DualDateHeader(gregorianDate: viewModel.currentDate, vedicDate: viewModel.vedicDate, tamilDate: viewModel.tamilDate, bhashaEngine: bhashaEngine)
                    .padding(.top)
                
                Spacer()
                
                // Adaptive Clock Dial (Replacing NazhigaiWheel)
                AdaptiveClockDialView(viewModel: clockViewModel)
                    .padding()
                    // Apply design customization if needed via clockViewModel.applyIconDesign(...)
                    // For now using default which is icon-matched
                
                Spacer()
                
                HStack {
                    Menu {
                        Button(action: { showSettings = true }) {
                            Label("Settings", systemImage: "gear")
                        }
                        Button(action: { showAlarms = true }) {
                            Label("Alarms", systemImage: "bell.fill")
                        }
                        LanguageToggle(bhashaEngine: bhashaEngine)
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .font(.title2)
                            .padding()
                    }
                    
                    Spacer()
                }
            }

        }
        .onChange(of: viewModel.vedicTime) { _, newTime in
            clockViewModel.updateVedicTime(newTime, date: viewModel.vedicDate)
        }
        .onChange(of: viewModel.vedicDate) { _, newDate in
            clockViewModel.updateVedicTime(viewModel.vedicTime, date: newDate)
        }
        .onChange(of: viewModel.currentDate) { _, newDate in
            clockViewModel.updateCurrentTime(to: newDate)
        }
        .sheet(isPresented: $showSettings) {
            SettingsView(appConfig: appConfig)
        }
        .sheet(isPresented: $showAlarms) {
            AlarmListView()
        }
        .onChange(of: colorScheme) { _, newScheme in
            theme.updateColorScheme(newScheme)
        }
        .onChange(of: colorSchemeContrast) { _, _ in
            updateAccessibilitySettings()
        }
        .onChange(of: reduceTransparency) { _, _ in
            updateAccessibilitySettings()
        }
        .onChange(of: dynamicTypeSize) { _, _ in
            updateAccessibilitySettings()
        }
        .onChange(of: reduceMotion) { _, _ in
            updateAccessibilitySettings()
        }
        .onChange(of: scenePhase) { _, newPhase in
            if newPhase == .active {
                NotificationService.shared.rescheduleFromPersistence()
            }
        }
        .onAppear {
            theme.updateColorScheme(colorScheme)
            updateAccessibilitySettings()
        }
        .environmentObject(appConfig) // Inject AppConfig for child views (ClockDialView)
    }
    

}

#Preview {
    DashboardView()
        .environmentObject(AppTheme.default())
}

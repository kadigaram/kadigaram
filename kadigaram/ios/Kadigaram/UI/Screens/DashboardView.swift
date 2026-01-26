import SwiftUI
import KadigaramCore

struct DashboardView: View {
    @StateObject private var viewModel = DashboardViewModel()
    @StateObject private var bhashaEngine = BhashaEngine()
    @StateObject private var appConfig = AppConfig()
    @StateObject private var clockViewModel = ClockDialViewModel() // New clock VM
    @State private var showSettings = false
    
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
                    Button(action: { showSettings = true }) {
                        Image(systemName: "gear")
                            .font(.title2)
                    }
                    .padding()
                    
                    Spacer()
                    
                    LanguageToggle(bhashaEngine: bhashaEngine)
                        .padding()
                }
            }

        }
        .onChange(of: viewModel.vedicTime) { newTime in
            clockViewModel.updateVedicTime(newTime)
        }
        .onChange(of: viewModel.currentDate) { newDate in
            clockViewModel.updateCurrentTime(to: newDate)
        }
        .sheet(isPresented: $showSettings) {
            SettingsView(appConfig: appConfig)
        }
        .onChange(of: colorScheme) { newScheme in
            theme.updateColorScheme(newScheme)
        }
        .onChange(of: colorSchemeContrast) { _ in
            updateAccessibilitySettings()
        }
        .onChange(of: reduceTransparency) { _ in
            updateAccessibilitySettings()
        }
        .onChange(of: dynamicTypeSize) { _ in
            updateAccessibilitySettings()
        }
        .onChange(of: reduceMotion) { _ in
            updateAccessibilitySettings()
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

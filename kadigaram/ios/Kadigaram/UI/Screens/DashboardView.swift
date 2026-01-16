import SwiftUI
import KadigaramCore

struct DashboardView: View {
    @StateObject private var viewModel = DashboardViewModel()
    @StateObject private var bhashaEngine = BhashaEngine()
    @StateObject private var appConfig = AppConfig()
    @State private var showSettings = false
    
    @Environment(\.colorScheme) private var colorScheme
    
    // Theme-adaptive background for better contrast with golden dial
    private var backgroundColor: Color {
        colorScheme == .dark ? Color(white: 0.08) : Color(white: 0.95)
    }
    
    var body: some View {
        ZStack {
            backgroundColor.ignoresSafeArea()
            
            VStack {
                // Header
                DualDateHeader(gregorianDate: viewModel.currentDate, vedicDate: viewModel.vedicDate, bhashaEngine: bhashaEngine)
                    .padding(.top)
                
                Spacer()
                
                // Wheel
                NazhigaiWheel(vedicTime: viewModel.vedicTime)
                    .frame(maxWidth: 500, maxHeight: 500) // Scaling constraint
                    .padding()
                
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
        .sheet(isPresented: $showSettings) {
            SettingsView(appConfig: appConfig)
        }
    }
}

#Preview {
    DashboardView()
}

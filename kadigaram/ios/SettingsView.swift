import SwiftUI
import KadigaramCore

struct SettingsView: View {
    @ObservedObject var appConfig: AppConfig
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Calendar System")) {
                    Picker("Month Calculation", selection: $appConfig.calendarSystem) {
                        Text("Solar (Vakya)").tag(CalendarSystem.solar)
                        Text("Lunar (Amanta/Purnimanta)").tag(CalendarSystem.lunar)
                    }
                    .pickerStyle(.inline)
                }
                
                Section(header: Text("About")) {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0 (Alpha)")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    SettingsView(appConfig: AppConfig())
}

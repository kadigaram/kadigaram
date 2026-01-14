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
                
                Section(header: Text("Location Settings")) {
                    Toggle("Use Manual Location", isOn: $appConfig.isManualLocation)
                    
                    if appConfig.isManualLocation {
                        HStack {
                            Text("Lat:")
                            TextField("Latitude", value: $appConfig.manualLatitude, format: .number)
                                .keyboardType(.decimalPad)
                        }
                        HStack {
                            Text("Long:")
                            TextField("Longitude", value: $appConfig.manualLongitude, format: .number)
                                .keyboardType(.decimalPad)
                        }
                    } else {
                         Text("Using GPS: \(String(format: "%.4f", appConfig.manualLatitude)), \(String(format: "%.4f", appConfig.manualLongitude))") // Placeholder display if we could access real location here
                            .foregroundColor(.secondary)
                            .font(.caption)
                    }
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

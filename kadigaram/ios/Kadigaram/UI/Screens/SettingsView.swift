import SwiftUI
import KadigaramCore

struct SettingsView: View {
    @ObservedObject var appConfig: AppConfig
    @Environment(\.dismiss) var dismiss
    @State private var showLocationSearch = false
    
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
                        Button {
                            showLocationSearch = true
                        } label: {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("Location")
                                        .foregroundColor(.primary)
                                    Text(appConfig.manualLocationName)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                            }
                        }
                    } else {
                        VStack(alignment: .leading) {
                            Text("Using GPS Location")
                                .foregroundColor(.primary)
                            Text("Coordinates will be updated automatically.")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 4)
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
            .sheet(isPresented: $showLocationSearch) {
                LocationSearchView { result in
                    appConfig.manualLatitude = result.latitude
                    appConfig.manualLongitude = result.longitude
                    appConfig.manualLocationName = result.name
                    if let tz = result.timeZoneIdentifier {
                        appConfig.manualTimeZone = tz
                    }
                }
            }
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

import SwiftUI
import Combine
import KadigaramCore

struct AlarmEditView: View {
    @Binding var alarm: NazhigaiAlarm
    var onSave: () -> Void
    var onCancel: () -> Void
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Time")) {
                    HStack {
                        Picker("Nazhigai", selection: $alarm.nazhigai) {
                            ForEach(0..<60) { i in
                                Text("\(i) Na").tag(i)
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(maxWidth: .infinity)
                        .clipped()
                        
                        Picker("Vinazhigai", selection: $alarm.vinazhigai) {
                            ForEach(0..<60) { i in
                                Text("\(i) Vi").tag(i)
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(maxWidth: .infinity)
                        .clipped()
                    }
                    .frame(height: 150)
                }
                
                Section(header: Text("Label")) {
                    TextField("Alarm Label", text: $alarm.label)
                }
                
                Section {
                    Toggle("Enabled", isOn: $alarm.isEnabled)
                }
            }
            .navigationTitle("Edit Alarm")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        onCancel()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        onSave()
                    }
                }
            }
        }
    }
}

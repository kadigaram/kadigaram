import SwiftUI
import Combine
import CoreLocation
import KadigaramCore
import SixPartsLib

struct AlarmListView: View {
    @StateObject private var viewModel = AlarmListViewModel()
    @State private var showingAddSheet = false
    @State private var newAlarm = NazhigaiAlarm()
    
    var body: some View {
        return NavigationView {
            List {
                if viewModel.alarms.isEmpty {
                    Text("No Alarms Set")
                        .foregroundColor(.secondary)
                }
                
                ForEach(viewModel.alarms) { alarm in
                    AlarmRowView(alarm: alarm, onToggle: { isEnabled in
                        viewModel.toggleAlarm(id: alarm.id, isEnabled: isEnabled)
                    }, onSystemClockToggle: { addToSystemClock in
                        viewModel.toggleSystemClock(id: alarm.id, addToSystemClock: addToSystemClock)
                    })
                }
                .onDelete { indexSet in
                    viewModel.removeAlarm(at: indexSet)
                }
            }
            .navigationTitle("Nazhigai Alarms")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: {
                        newAlarm = NazhigaiAlarm() // Reset
                        showingAddSheet = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddSheet) {
                AlarmEditView(alarm: $newAlarm, onSave: {
                    viewModel.addAlarm(newAlarm)
                    showingAddSheet = false
                }, onCancel: {
                    showingAddSheet = false
                })
            }
        }
    }
}

// Separate row view to isolate toggle state
struct AlarmRowView: View {
    let alarm: NazhigaiAlarm
    let onToggle: (Bool) -> Void
    let onSystemClockToggle: (Bool) -> Void
    
    @State private var isEnabled: Bool
    @State private var addToSystemClock: Bool
    @ObservedObject private var locationManager = LocationManager.shared
    
    init(alarm: NazhigaiAlarm, onToggle: @escaping (Bool) -> Void, onSystemClockToggle: @escaping (Bool) -> Void = { _ in }) {
        self.alarm = alarm
        self.onToggle = onToggle
        self.onSystemClockToggle = onSystemClockToggle
        self._isEnabled = State(initialValue: alarm.isEnabled)
        self._addToSystemClock = State(initialValue: alarm.addToSystemClock)
    }
    
    /// Calculate the next time this alarm will fire
    private var nextScheduledTime: Date? {
        guard let location = locationManager.location else { return nil }
        
        let calendar = Calendar.current
        
        // Try today first
        if let todayDate = SixPartsLib.calculateDate(
            nazhigai: alarm.nazhigai,
            vinazhigai: alarm.vinazhigai,
            on: Date(),
            location: location
        ), todayDate > Date() {
            return todayDate
        }
        
        // Try tomorrow
        if let tomorrow = calendar.date(byAdding: .day, value: 1, to: Date()),
           let tomorrowDate = SixPartsLib.calculateDate(
            nazhigai: alarm.nazhigai,
            vinazhigai: alarm.vinazhigai,
            on: tomorrow,
            location: location
           ) {
            return tomorrowDate
        }
        
        return nil
    }
    
    /// Format the next scheduled time for display in local timezone
    private var formattedNextAlarmTime: String {
        guard let nextTime = nextScheduledTime else {
            return "Calculating..."
        }
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.timeZone = .current
        
        return formatter.string(from: nextTime)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading) {
                    Text("\(alarm.nazhigai) Na : \(alarm.vinazhigai) Vi")
                        .font(.title3)
                        .fontWeight(.bold)
                    if !alarm.label.isEmpty {
                        Text(alarm.label)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                Spacer()
                Toggle("", isOn: $isEnabled)
                    .labelsHidden()
                    .onChange(of: isEnabled) { _, newValue in
                        onToggle(newValue)
                    }
            }
            
            // Add to Clock toggle (iOS 26+ only)
            if #available(iOS 26, *) {
                HStack {
                    Image(systemName: "clock.badge.checkmark")
                        .foregroundColor(.secondary)
                        .font(.caption)
                    Text("Add to Clock")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Spacer()
                    Toggle("", isOn: $addToSystemClock)
                        .labelsHidden()
                        .scaleEffect(0.8)
                        .onChange(of: addToSystemClock) { _, newValue in
                            onSystemClockToggle(newValue)
                        }
                }
                .padding(.leading, 4)
                
                // Show next scheduled time when Add to Clock is enabled
                if addToSystemClock && isEnabled {
                    HStack(spacing: 4) {
                        Image(systemName: "calendar.badge.clock")
                            .foregroundColor(.blue)
                            .font(.caption2)
                        Text("Next: \(formattedNextAlarmTime)")
                            .font(.caption2)
                            .foregroundColor(.blue)
                    }
                    .padding(.leading, 4)
                    .padding(.top, 2)
                }
            }
        }
        .padding(.vertical, 4)
    }
}

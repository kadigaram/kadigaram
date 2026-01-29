//
//  ClockDialViewModel.swift
//  Kadigaram
//
//  Created for Feature 006: Clock UI Improvements
//  Task: T013 - ClockDialViewModel
//

import SwiftUI
import Combine
import KadigaramCore
import SixPartsLib

/// View model for clock dial with time calculations and design application
@MainActor
final class ClockDialViewModel: ObservableObject {
    /// Current time being displayed
    @Published var currentTime: Date
    
    /// Clock ticks/labels
    struct ClockLabel: Identifiable {
        let id = UUID()
        let angle: Double
        let text: String
    }
    
    @Published var timeLabels: [ClockLabel] = []
    
    /// Clock dial design configuration
    @Published var design: ClockDialDesign
    
    /// Timer for updating the clock
    private var timer: Timer?
    
    // MARK: - Initialization
    
    /// Initialize with current time and default design
    init(currentTime: Date = Date(), design: ClockDialDesign? = nil) {
        self.currentTime = currentTime
        self.design = design ?? .default
    }
    
    /// Current Vedic time data
    @Published var vedicTime: VedicTime?
    
    // MARK: - Time Calculations
    
    /// Calculate the angle for the Nazhigai indicator (0-360 degrees)
    /// representing the progress through the day (sunrise to sunrise)
    func nazhigaiAngle() -> Double {
        guard let time = vedicTime else { return 0 }
        
        // Progress angle is mapped to day progress.
        // If progressIndicatorAngle is already 0-360 in VedicTime, use it.
        // Assuming VedicTime.percentElapsed is 0.0 to 1.0
        
        // Use progressIndicatorAngle from VedicTime directly if available and correct,
        // otherwise calculating from percentElapsed:
        if time.progressIndicatorAngle > 0 {
            return time.progressIndicatorAngle
        } else {
            return time.percentElapsed * 360.0
        }
    }

    /// Formatted string for "Modern time since sunrise"
    var timeSinceSunriseText: String {
        guard let time = vedicTime else { return "--:--:--" }
        
        // Calculate difference between now (or target time) and sunrise
        // We use the same 'currentTime' logic implicitly, but vedicTime is calculated for a specific instant.
        // Let's rely on vedicTime.sunrise and the current time of calculation.
        // Ideally vedicTime should have the "current" time used for its calculation, 
        // but since we are continuously updating, we can use Date() or better, 
        // derive it if we assume vedicTime is fresh.
        // Let's use Date() vs time.sunrise. Use abs() to handle small discrepancies.
        
        // Better yet, just use the current time the VM holds
        let diff = currentTime.timeIntervalSince(time.sunrise)
        
        // If diff < 0 (before sunrise), arguably it should Reference previous sunrise? 
        // But VedicTime logic handles day boundaries. 
        // If isDaytime is false and we are after sunset but before next sunrise, 
        // we might want time since *Sunset*? 
        // User request: "Modern time since sunrise". 
        // Standard "Nazhigai" implies time since sunrise (even at night).
        
        let seconds = Int(diff)
        if seconds < 0 {
             // Edge case where currentTime is slightly before the sunrise stored in vedicTime 
             // (unlikely if vedicTime is derived from currentTime correctly)
             return "00:00:00"
        }
        
        let h = seconds / 3600
        let m = (seconds % 3600) / 60
        let s = seconds % 60
        
        return String(format: "%02d:%02d:%02d", h, m, s)
    }
    
    /// Update with new VedicTime data
    func updateVedicTime(_ time: VedicTime) {
        self.vedicTime = time
        calculateTimeLabels()
    }
    
    /// Calculate tick labels every 2 hours from sunrise
    private func calculateTimeLabels() {
        guard let time = vedicTime else {
            timeLabels = []
            return
        }
        
        // Estimate day duration
        // If percentElapsed is very small, calculation might be unstable
        // Default to 24 hours (86400 seconds) if undetermined
        var dayDuration: TimeInterval = 86400
        
        let elapsed = currentTime.timeIntervalSince(time.sunrise)
        if time.percentElapsed > 0.01 { // Avoid divide by zero or noise
             dayDuration = elapsed / time.percentElapsed
        }
        
        var labels: [ClockLabel] = []
        
        // Generate ticks every 2 hours relative to Sunrise
        // We ideally want "nice" times like 06:00, 08:00... or just Sunrise + 2h?
        // User request: "Modern time 24hr clock is ploted around the dial starting from sunrise"
        // Image shows "05:45", "07:45" (if sunrise is 05:45).
        // So it's Sunrise + N * 2h.
        
        for i in 0..<12 { // Up to 24 hours
            let offset = TimeInterval(i * 7200) // 2 hours = 7200 seconds
            if offset >= dayDuration { break }
            
            let angle = (offset / dayDuration) * 360.0
            let tickDate = time.sunrise.addingTimeInterval(offset)
            
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            let labelText = formatter.string(from: tickDate)
            
            labels.append(ClockLabel(angle: angle, text: labelText))
        }
        
        self.timeLabels = labels
    }
    
    // MARK: - Time Updates
    
    // Timer removed to optimize CPU usage. Updates are now driven by parent view.
    
    /// Update current time manually
    func updateCurrentTime(to date: Date = Date()) {
        self.currentTime = date
    }
    
    /// Legacy compatibility
    func startUpdating(interval: TimeInterval = 1.0) {
        updateCurrentTime()
    }
    
    func stopUpdating() {
        timer?.invalidate()
        timer = nil
    }
    
    func updateTime() {
        updateCurrentTime()
    }
    
    /// Set specific time (useful for testing)
    /// - Parameter time: The time to set
    func setTime(_ time: Date) {
        currentTime = time
    }
    
    // MARK: - Design Application
    
    /// Apply design from extracted icon colors
    /// - Parameter iconColors: Color palette extracted from app icon
    func applyIconDesign(iconColors: ImageColorExtraction.ExtractedColorPalette) {
        let dialPalette = DialColorPalette(fromExtractedPalette: iconColors)
        design = ClockDialDesign(
            colorPalette: dialPalette,
            gradientConfig: design.gradientConfig,
            strokeStyles: design.strokeStyles,
            geometry: design.geometry,
            animationConfig: design.animationConfig
        )
    }
    
    /// Apply custom design
    /// - Parameter newDesign: The design to apply
    func applyDesign(_ newDesign: ClockDialDesign) {
        design = newDesign
    }
    
    // MARK: - Cleanup
    

}

// MARK: - Preview Helpers

extension ClockDialViewModel {
    /// Create a preview instance with a fixed time
    @MainActor
    static func preview(hour: Int = 10, minute: Int = 10) -> ClockDialViewModel {
        var components = DateComponents()
        components.hour = hour
        components.minute = minute
        components.second = 0
        
        let time = Calendar.current.date(from: components) ?? Date()
        return ClockDialViewModel(currentTime: time)
    }
}

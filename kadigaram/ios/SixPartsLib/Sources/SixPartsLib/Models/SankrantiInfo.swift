import Foundation

/// Internal structure for tracking Sankranti calculation details
/// Not exposed in public API
internal struct SankrantiInfo {
    /// Target Rasi boundary degree (0, 30, 60, ..., 330)
    let rasiDegree: Double
    
    /// Exact timestamp when Sun crossed the boundary
    let sankrantiTime: Date
    
    /// Sunset time on Sankranti date for given location
    let sunsetTime: Date
    
    /// True if Sankranti occurred before sunset (making that day "Day 1")
    let isDayOne: Bool
    
    /// Day 1 date after applying sunset rule
    let dayOneDate: Date
}

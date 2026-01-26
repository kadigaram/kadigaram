import Foundation
import Solar

/// Represents the calculated point in time (Nazhigai, Vinazhigai) relative to Sunrise.
public struct VedicTime: Equatable, Sendable {
    public let nazhigai: Int // 0-59
    public let vinazhigai: Int // 0-59
    public let percentElapsed: Double // 0.0-1.0
    public let progressIndicatorAngle: Double // Angle in degrees (0-360)
    public let sunrise: Date
    public let sunset: Date
    public let isDaytime: Bool
    
    public init(nazhigai: Int, vinazhigai: Int, percentElapsed: Double, progressIndicatorAngle: Double, sunrise: Date, sunset: Date, isDaytime: Bool) {
        self.nazhigai = nazhigai
        self.vinazhigai = vinazhigai
        self.percentElapsed = percentElapsed
        self.progressIndicatorAngle = progressIndicatorAngle
        self.sunrise = sunrise
        self.sunset = sunset
        self.isDaytime = isDaytime
    }
}

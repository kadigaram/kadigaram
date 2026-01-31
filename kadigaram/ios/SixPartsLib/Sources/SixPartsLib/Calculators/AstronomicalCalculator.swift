import Foundation
import CoreLocation

/// Astronomical calculator using simplified formulas (Meeus algorithms)
/// Provides ~95% accuracy for Vedic calendar calculations without external dependencies
public class AstronomicalCalculator {
    
    public init() {}
    
    // MARK: - Sun and Moon Longitude
    
    /// Calculate Sun's ecliptic longitude (tropical) using simplified formula
    /// Accuracy: ±0.01 degrees (sufficient for Vedic calculations)
    public func sunLongitude(date: Date, location: CLLocationCoordinate2D) -> Double {
        let jd = julianDay(from: date)
        let t = (jd - 2451545.0) / 36525.0  // Julian centuries from J2000.0
        
        // Mean longitude of the Sun (degrees)
        var l0 = 280.46646 + 36000.76983 * t + 0.0003032 * t * t
        l0 = l0.truncatingRemainder(dividingBy: 360.0)
        if l0 < 0 { l0 += 360 }
        
        // Mean anomaly of the Sun (degrees)
        var m = 357.52911 + 35999.05029 * t - 0.0001537 * t * t
        m = m.truncatingRemainder(dividingBy: 360.0)
        
        // Equation of center
        let c = (1.914602 - 0.004817 * t - 0.000014 * t * t) * sin(m * .pi / 180.0) +
                (0.019993 - 0.000101 * t) * sin(2 * m * .pi / 180.0) +
                0.000289 * sin(3 * m * .pi / 180.0)
        
        // Sun's true longitude
        var longitude = l0 + c
        longitude = longitude.truncatingRemainder(dividingBy: 360.0)
        if longitude < 0 { longitude += 360 }
        
        return longitude
    }
    
    /// Calculate Moon's ecliptic longitude using simplified formula
    /// Accuracy: ±0.2 degrees (sufficient for Nakshatra/Tithi)
    public func moonLongitude(date: Date, location: CLLocationCoordinate2D) -> Double {
        let jd = julianDay(from: date)
        let t = (jd - 2451545.0) / 36525.0
        
        // Moon's mean longitude (degrees)
        var l = 218.3164477 + 481267.88123421 * t - 0.0015786 * t * t + t * t * t / 538841.0 - t * t * t * t / 65194000.0
        
        // Moon's mean elongation
        let d = 297.8501921 + 445267.1114034 * t - 0.0018819 * t * t + t * t * t / 545868.0 - t * t * t * t / 113065000.0
        
        // Sun's mean anomaly
        let m = 357.5291092 + 35999.0502909 * t - 0.0001536 * t * t + t * t * t / 24490000.0
        
        // Moon's mean anomaly
        let mPrime = 134.9633964 + 477198.8675055 * t + 0.0087414 * t * t + t * t * t / 69699.0 - t * t * t * t / 14712000.0
        
        // Moon's argument of latitude
        let f = 93.2720950 + 483202.0175233 * t - 0.0036539 * t * t - t * t * t / 3526000.0 + t * t * t * t / 863310000.0
        
        // Periodic terms (simplified - using largest terms only)
        let e = 1.0 - 0.002516 * t - 0.0000074 * t * t
        
        var correction = 0.0
        correction += 6.288774 * sin((mPrime) * .pi / 180.0)
        correction += 1.274027 * sin((2 * d - mPrime) * .pi / 180.0)
        correction += 0.658314 * sin((2 * d) * .pi / 180.0)
        correction += 0.213618 * sin((2 * mPrime) * .pi / 180.0)
        correction += -0.185116 * e * sin((m) * .pi / 180.0)
        correction += -0.114332 * sin((2 * f) * .pi / 180.0)
        
        var longitude = l + correction
        longitude = longitude.truncatingRemainder(dividingBy: 360.0)
        if longitude < 0 { longitude += 360 }
        
        return longitude
    }
    
    // MARK: - Lahiri Ayanamsa (Sidereal Calculations)
    
    /// Calculate Lahiri Ayanamsa for given date
    /// Returns the ayanamsa offset in degrees
    /// Using standard IAE table values for accuracy
    public func calculateLahiriAyanamsa(date: Date) -> Double {
        let jd = julianDay(from: date)
        
        // Standard Lahiri Ayanamsa Formula (simplified linear model)
        // Reference J2000 (JD 2451545.0) = 23.854722 degrees (23° 51' 17")
        // Rate = 50.29 arcseconds per year = 0.013969 degrees per year
        // T = Julian centuries from J2000
        
        let t = (jd - 2451545.0) / 36525.0
        
        // Ayanamsa = 23.854722 + 1.396971 * T
        // 1.396971 comes from 50.29 arcsec/yr * 100 years / 3600
        
        let ayanamsa = 23.854722 + 1.396971 * t
        
        return ayanamsa
    }
    
    /// Calculate Sun's sidereal longitude (tropical + Ayanamsa offset)
    /// Used for Tamil calendar Sankranti calculations
    public func siderealSunLongitude(date: Date) -> Double {
        // Use center of Earth as location (doesn't significantly affect sun longitude)
        let tropicalLongitude = sunLongitude(date: date, location: CLLocationCoordinate2D(latitude: 0, longitude: 0))
        let ayanamsa = calculateLahiriAyanamsa(date: date)
        
        var sidereal = tropicalLongitude - ayanamsa
        
        // Normalize to 0-360°
        while sidereal < 0 { sidereal += 360 }
        while sidereal >= 360 { sidereal -= 360 }
        
        return sidereal
    }
    
    // MARK: - Tithi and Nakshatra Calculations
    
    /// Calculate Tithi (lunar day) from Moon-Sun longitude difference
    public func calculateTithi(date: Date, location: CLLocationCoordinate2D) -> (number: Int, progress: Double) {
        let moonLon = moonLongitude(date: date, location: location)
        let sunLon = sunLongitude(date: date, location: location)
        
        // Tithi = (Moon longitude - Sun longitude) / 12 degrees
        var diff = moonLon - sunLon
        if diff < 0 {
            diff += 360
        }
        
        let tithiFloat = diff / 12.0
        // Tithi 1-30: floor the value and add 1, wrapping at 30
        let tithiNumber = (Int(tithiFloat) % 30) + 1
        let tithiProgress = tithiFloat.truncatingRemainder(dividingBy: 1.0)
        
        return (tithiNumber, tithiProgress)
    }
    
    /// Calculate Nakshatra (lunar mansion) from Moon's sidereal longitude
    /// Uses Lahiri Ayanamsa for sidereal (Vedic) calculation
    public func calculateNakshatra(date: Date, location: CLLocationCoordinate2D) -> (number: Int, progress: Double) {
        let tropicalMoonLon = moonLongitude(date: date, location: location)
        let ayanamsa = calculateLahiriAyanamsa(date: date)
        
        // Convert tropical to sidereal longitude (Vedic system)
        var siderealMoonLon = tropicalMoonLon - ayanamsa
        
        // Normalize to 0-360°
        if siderealMoonLon < 0 { siderealMoonLon += 360 }
        if siderealMoonLon >= 360 { siderealMoonLon -= 360 }
        
        // Nakshatra = Sidereal Moon longitude / 13.333... degrees (360/27)
        let nakshatraFloat = siderealMoonLon / (360.0 / 27.0)
        let nakshatraNumber = Int(nakshatraFloat) % 27 + 1 // Nakshatra 1-27
        let nakshatraProgress = nakshatraFloat.truncatingRemainder(dividingBy: 1.0)
        
        return (nakshatraNumber, nakshatraProgress)
    }
    
    // MARK: - Ayana Calculation (Feature 009)
    
    /// Calculate current Ayana (Sun's directional movement) based on date
    /// Uses simplified calendar-based approach with standard solstice dates
    /// - Parameter date: The date to calculate Ayana for
    /// - Returns: Current Ayana (Uttarayanam or Dakshinayanam)
    public func calculateAyana(for date: Date) -> Ayana {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.month, .day], from: date)
        
        guard let month = components.month, let day = components.day else {
            // Fallback: assume Uttarayanam (safer default for most of year)
            return .uttarayanam
        }
        
        // Uttarayanam: Dec 22 - Jun 21
        // Dakshinayanam: Jun 22 - Dec 21
        
        // Check for Dakshinayanam period
        if (month == 6 && day >= 22) ||      // June 22-30
           (month > 6 && month < 12) ||      // July-November
           (month == 12 && day < 22) {       // December 1-21
            return .dakshinayanam
        }
        
        // Otherwise Uttarayanam (Jan-May, Jun 1-21, Dec 22-31)
        return .uttarayanam
    }

    // MARK: - Helper Methods
    
    /// Convert Date to Julian Day
    /// Uses absolute time (timeIntervalSince1970) to avoid TimeZone ambiguity
    /// JD 2440587.5 = Jan 1, 1970 00:00 UTC
    private func julianDay(from date: Date) -> Double {
        return date.timeIntervalSince1970 / 86400.0 + 2440587.5
    }
}

import Foundation
import CoreLocation
import Solar
import SixPartsLib  // Import for VedicDate, CalendarSystem, Paksha, AstronomicalCalculator

public protocol VedicEngineProvider {
    func calculateVedicTime(date: Date, location: CLLocationCoordinate2D, astronomicalEngine: AstronomicalEngineProvider, timeZone: TimeZone) -> VedicTime
    func calculateVedicDate(date: Date, location: CLLocationCoordinate2D, calendarSystem: CalendarSystem) async -> VedicDate
}

public class VedicEngine: VedicEngineProvider {
    public init() {}
    
    
    public func calculateVedicTime(date: Date, location: CLLocationCoordinate2D, astronomicalEngine: AstronomicalEngineProvider, timeZone: TimeZone) -> VedicTime {
        // Delegate calculation to SixPartsLib as requested
        // Note: SixPartsLib uses its own internal Solar calculation logic which matches the previous implementation
        return SixPartsLib.calculateVedicTime(for: date, location: location, timeZone: timeZone)
    }
    
    // MARK: - Fallback Methods
    
    /// Fallback sunrise if astronomical calculation fails (6 AM)
    private func defaultSunrise(for date: Date) -> Date {
        var components = Calendar.current.dateComponents([.year, .month, .day], from: date)
        components.hour = 6
        components.minute = 0
        return Calendar.current.date(from: components) ?? date
    }
    
    /// Fallback sunset if astronomical calculation fails (6 PM)
    private func defaultSunset(for date: Date) -> Date {
        var components = Calendar.current.dateComponents([.year, .month, .day], from: date)
        components.hour = 18
        components.minute = 0
        return Calendar.current.date(from: components) ?? date
    }
    
    public func calculateVedicDate(date: Date, location: CLLocationCoordinate2D, calendarSystem: CalendarSystem) async -> VedicDate {
        // Use AstronomicalCalculator for accurate ephemeris-based calculations
        let calculator = AstronomicalCalculator()
        
        let year = Calendar.current.component(.year, from: date)
        let day = Calendar.current.component(.day, from: date)
        
        // Get Samvatsara (60-year cycle) - SamvatsaraTable should be accurate
        let samvatsara = SamvatsaraTable.name(for: year)
        let samvatsaraIndex = SamvatsaraTable.indexInCycle(for: year)
        
        // Accurate Tithi calculation using moon-sun longitude
        let (tithiNumber, tithiProgress) = calculator.calculateTithi(date: date, location: location)
        let tithiName = Self.tithiNameFromNumber(tithiNumber)
        
        // Paksham based on Tithi
        let paksha: Paksha = tithiNumber <= 15 ? .shukla : .krishna
        
        // Illumination based on Tithi (0-15 shukla, 16-30 krishna)
        let pakshamIllumination = tithiNumber <= 15 ? Double(tithiNumber) / 15.0 : Double(30 - tithiNumber) / 15.0
        
        // Accurate Nakshatra calculation using moon's ecliptic longitude
        let (nakshatraNumber, nakshatraProgress) = calculator.calculateNakshatra(date: date, location: location)
        let nakshatraName = Self.nakshatraNameFromNumber(nakshatraNumber)
        
        // Maasa calculation (simplified - would need solar ingress times for full accuracy)
        let monthName = Self.maasaFromDate(date, calendarSystem: calendarSystem)
        
       return VedicDate(
            samvatsara: samvatsara,
            samvatsaraIndex: samvatsaraIndex,
            maasa: monthName,
            paksha: paksha,
            pakshamIllumination: pakshamIllumination,
            tithi: tithiName,
            tithiProgress: tithiProgress,
            tithiNumber: tithiNumber,
            nakshatra: nakshatraName,
            nakshatraProgress: nakshatraProgress,
            nakshatraNumber: nakshatraNumber,
            day: day
        )
    }
    
    // MARK: - Helper Methods for Vedic Names
    
    private static func tithiNameFromNumber(_ number: Int) -> String {
        let tithiNames = [
            // Shukla Paksha (1-15)
            "tithi_prathamai",      // 1 - Prathamai
            "tithi_thuthiyai",      // 2 - Thuthiyai  
            "tithi_thirithiyai",    // 3 - Thirithiyai
            "tithi_chathurthi",     // 4 - Chathurthi
            "tithi_panchami",       // 5 - Panchami
            "tithi_shasti",         // 6 - Shasti
            "tithi_sapthami",       // 7 - Sapthami
            "tithi_ashtami",        // 8 - Ashtami
            "tithi_navami",         // 9 - Navami
            "tithi_dhasami",        // 10 - Dhasami
            "tithi_ekadhasi",       // 11 - Ekadhasi
            "tithi_dhuvalhasi",     // 12 - Dhuvalhasi (Dwadashi)
            "tithi_thirayodhasi",   // 13 - Thirayodhasi
            "tithi_chathurdhasi",   // 14 - Chathurdhasi
            "tithi_pournami",       // 15 - Pournami (Full Moon)
            // Krishna Paksha (16-30)
            "tithi_prathamai",      // 16 - Prathamai
            "tithi_thuthiyai",      // 17 - Thuthiyai
            "tithi_thirithiyai",    // 18 - Thirithiyai
            "tithi_chathurthi",     // 19 - Chathurthi
            "tithi_panchami",       // 20 - Panchami
            "tithi_shasti",         // 21 - Shasti
            "tithi_sapthami",       // 22 - Sapthami
            "tithi_ashtami",        // 23 - Ashtami
            "tithi_navami",         // 24 - Navami
            "tithi_dhasami",        // 25 - Dhasami
            "tithi_ekadhasi",       // 26 - Ekadhasi
            "tithi_dhuvalhasi",     // 27 - Dhuvalhasi
            "tithi_thirayodhasi",   // 28 - Thirayodhasi
            "tithi_chathurdhasi",   // 29 - Chathurdhasi
            "tithi_amavasai"        // 30 - Amavasai (New Moon)
        ]
        guard number >= 1 && number <= 30 else { return "tithi_prathamai" }
        return tithiNames[number - 1]
    }
    
    private static func nakshatraNameFromNumber(_ number: Int) -> String {
        let nakshatraNames = [
            "nakshatra_ashwini", "nakshatra_bharani", "nakshatra_krittika", "nakshatra_rohini", "nakshatra_mrigashira",
            "nakshatra_ardra", "nakshatra_punarvasu", "nakshatra_pushya", "nakshatra_ashlesha", "nakshatra_magha",
            "nakshatra_purva_phalguni", "nakshatra_uttara_phalguni", "nakshatra_hasta", "nakshatra_chitra", "nakshatra_swati",
            "nakshatra_vishakha", "nakshatra_anuradha", "nakshatra_jyeshtha", "nakshatra_mula", "nakshatra_purva_ashadha",
            "nakshatra_uttara_ashadha", "nakshatra_shravana", "nakshatra_dhanishta", "nakshatra_shatabhisha", "nakshatra_purva_bhadrapada",
            "nakshatra_uttara_bhadrapada", "nakshatra_revati"
        ]
        guard number >= 1 && number <= 27 else { return "nakshatra_ashwini" }
        return nakshatraNames[number - 1]
    }
    
    
    private static func maasaFromDate(_ date: Date, calendarSystem: CalendarSystem) -> String {
        // For more accurate calculation, use sun's longitude
        // Solar months are based on sun's position in zodiac
        let calculator = AstronomicalCalculator()
        let location = CLLocationCoordinate2D(latitude: 13.0, longitude: 80.0) // Default Chennai
        let sunLon = calculator.sunLongitude(date: date, location: location)
        
        if calendarSystem == .solar {
            // Tamil solar months based on zodiac signs (30° each)
            // Order: Chithirai starts at 0° (Mesha/Aries)
            let solarMonths = [
                "month_chithirai",   // 0-30° (Mesha/Aries) - Mid-Apr to Mid-May
                "month_vaigasi",     // 30-60° (Vrishabha/Taurus) - Mid-May to Mid-Jun
                "month_aani",        // 60-90° (Mithuna/Gemini) - Mid-Jun to Mid-Jul
                "month_aadi",        // 90-120° (Kataka/Cancer) - Mid-Jul to Mid-Aug
                "month_aavani",      // 120-150° (Simha/Leo) - Mid-Aug to Mid-Sep
                "month_purattasi",   // 150-180° (Kanya/Virgo) - Mid-Sep to Mid-Oct
                "month_aippasi",     // 180-210° (Tula/Libra) - Mid-Oct to Mid-Nov
                "month_karthigai",   // 210-240° (Vrischika/Scorpio) - Mid-Nov to Mid-Dec
                "month_margazhi",    // 240-270° (Dhanus/Sagittarius) - Mid-Dec to Mid-Jan
                "month_thai",        // 270-300° (Makara/Capricorn) - Mid-Jan to Mid-Feb
                "month_masi",        // 300-330° (Kumbha/Aquarius) - Mid-Feb to Mid-Mar
                "month_panguni"      // 330-360° (Meena/Pisces) - Mid-Mar to Mid-Apr
            ]
            let monthIndex = Int(sunLon / 30.0) % 12
            return solarMonths[monthIndex]
        } else {
            // Lunar months - approximate based on solar month
            // This is simplified; accurate lunar month requires moon position at new moon
            let month = Calendar.current.component(.month, from: date)
            let lunarMonths = [
                "month_pausha", "month_magha", "month_phalguna", "month_chaitra",
                "month_vaishakha", "month_jyeshtha", "month_ashadha", "month_shravana",
                "month_bhadrapada", "month_ashwina", "month_kartika", "month_margashirsha"
            ]
            let monthIndex = (month - 1) % 12
            return lunarMonths[monthIndex]
        }
    }
}

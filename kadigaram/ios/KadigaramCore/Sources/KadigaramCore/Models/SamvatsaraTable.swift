import Foundation

/// 60-year cycle of Samvatsara names in Vedic calendar
/// Based on Jupiter's 12-year cycle × Saturn's 30-year cycle = 60 years
/// Reference year: 1987 = Krodhi (year 1 of cycle)
public struct SamvatsaraTable {
    
    /// Base year for the 60-year cycle
    private static let baseYear = 1987
    
    /// 60 Samvatsara names in order (localization keys)
    private static let names: [String] = [
        "year_prabhava",    // 1
        "year_vibhava",     // 2
        "year_shukla",      // 3
        "year_pramoduta",     // 4
        "year_prajotpatti",   // 5
        "year_angirasa",    // 6
        "year_srimukha",   // 7
        "year_bhava",       // 8
        "year_yuva",        // 9
        "year_dhatru",      // 10
        "year_ishwara",     // 11
        "year_bahudhanya",  // 12
        "year_pramathi",    // 13
        "year_vikrama",     // 14
        "year_vrusha",      // 15
        "year_chitrabhanu", // 16
        "year_subhanu",     // 17
        "year_tarana",      // 18
        "year_parthiva",    // 19
        "year_vyaya",       // 20
        "year_sarvajit",    // 21
        "year_sarvadhari", // 22
        "year_virodhi",    // 23
        "year_vikruti",     // 24
        "year_khara",       // 25
        "year_nandana",     // 26
        "year_vijaya",      // 27
        "year_jaya",        // 28
        "year_manmatha",    // 29
        "year_durmukhi",    // 30
        "year_hevilambi",   // 31
        "year_vilambi",     // 32
        "year_vikari",      // 33
        "year_sharvari",    // 34
        "year_plava",       // 35
        "year_shubhakrut",  // 36
        "year_shobhakrut",  // 37
        "year_krodhi",      // 38 (1987 = base year)
        "year_viswavasu",  // 39
        "year_parabhava",   // 40
        "year_plavanga",    // 41
        "year_keelaka",      // 42
        "year_soumya",      // 43
        "year_sadharana",   // 44
        "year_virodhikrut", // 45
        "year_paridhavi",   // 46
        "year_pramadicha",    // 47
        "year_ananda",      // 48
        "year_rakshasa",    // 49
        "year_nala",        // 50 (also "anala")
        "year_pingala",     // 51
        "year_kalayukti",   // 52
        "year_siddharthi",  // 53
        "year_roudri",      // 54
        "year_durmati",     // 55
        "year_dundubhi",    // 56
        "year_rudhirodgari",// 57
        "year_raktakshi",   // 58
        "year_krodhana",    // 59
        "year_akshaya",     // 60
    ]
    
    /// Get Samvatsara name (localization key) for a given year
    /// - Parameter year: Gregorian year (e.g., 2026)
    /// - Returns: Localization key for the year name (e.g., "samvatsara_krodhi")
    public static func name(for year: Int) -> String {
        let index = indexInCycle(for: year)
        return names[index - 1] // Convert 1-based index to 0-based array index
    }
    
    /// Get the position in the 60-year cycle (1-60)
    /// - Parameter year: Gregorian year
    /// - Returns: Index in cycle (1-60)
    public static func indexInCycle(for year: Int) -> Int {
        // Reference: 1988 is year 1 of the cycle (Prabhava)
        //  Therefore: 2026 is year 39 (Viswavasu) 
        // Calculation: (2026 - 1988) + 1 = 38 + 1 = 39 ✓
        
        let cycleStartYear = 1988  // Year 1 (Prabhava) of current 60-year cycle
        let offset = year - cycleStartYear + 1  // +1 to make it 1-indexed
        let modulo = offset % 60
        
        // Adjust for negative years (before 1988)
        let adjustedModulo = modulo <= 0 ? modulo + 60 : modulo
        
        return adjustedModulo
    }
    
    /// Base year (1987 = Krodhi, index 38 in traditional ordering)
    /// For this implementation, we treat 1988 as index 1 (Prabhava)
    public static var referenceYear: Int {
        return 1988
    }
}

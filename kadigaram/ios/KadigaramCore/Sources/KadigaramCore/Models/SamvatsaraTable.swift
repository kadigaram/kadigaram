import Foundation

/// 60-year cycle of Samvatsara names in Vedic calendar
/// Based on Jupiter's 12-year cycle × Saturn's 30-year cycle = 60 years
/// Reference year: 1987 = Krodhi (year 1 of cycle)
public struct SamvatsaraTable {
    
    /// Base year for the 60-year cycle
    private static let baseYear = 1987
    
    /// 60 Samvatsara names in order (localization keys)
    private static let names: [String] = [
        "samvatsara_prabhava",    // 1
        "samvatsara_vibhava",     // 2
        "samvatsara_shukla",      // 3
        "samvatsara_pramoda",     // 4
        "samvatsara_prajapati",   // 5
        "samvatsara_angirasa",    // 6
        "samvatsara_shrimukha",   // 7
        "samvatsara_bhava",       // 8
        "samvatsara_yuva",        // 9
        "samvatsara_dhatri",      // 10
        "samvatsara_ishvara",     // 11
        "samvatsara_bahudhanya",  // 12
        "samvatsara_pramadhi",    // 13
        "samvatsara_vikrama",     // 14
        "samvatsara_vrisha",      // 15
        "samvatsara_chitrabhanu", // 16
        "samvatsara_subhanu",     // 17
        "samvatsara_tarana",      // 18
        "samvatsara_parthiva",    // 19
        "samvatsara_vyaya",       // 20
        "samvatsara_sarvajit",    // 21
        "samvatsara_sarvadharin", // 22
        "samvatsara_virodhin",    // 23
        "samvatsara_vikrita",     // 24
        "samvatsara_khara",       // 25
        "samvatsara_nandana",     // 26
        "samvatsara_vijaya",      // 27
        "samvatsara_jaya",        // 28
        "samvatsara_manmatha",    // 29
        "samvatsara_durmukhi",    // 30
        "samvatsara_hevilambi",   // 31
        "samvatsara_vilambi",     // 32
        "samvatsara_vikari",      // 33
        "samvatsara_sharvari",    // 34
        "samvatsara_plava",       // 35
        "samvatsara_shubhakrit",  // 36
        "samvatsara_shobhana",    // 37
        "samvatsara_krodhi",      // 38 (1987 = base year)
        "samvatsara_vishvavasu",  // 39
        "samvatsara_parabhava",   // 40
        "samvatsara_plavanga",    // 41
        "samvatsara_kilaka",      // 42
        "samvatsara_saumya",      // 43
        "samvatsara_sadharana",   // 44
        "samvatsara_virodhikrit", // 45
        "samvatsara_paridhavi",   // 46
        "samvatsara_pramadin",    // 47
        "samvatsara_ananda",      // 48
        "samvatsara_rakshasa",    // 49
        "samvatsara_nala",        // 50 (also "anala")
        "samvatsara_pingala",     // 51
        "samvatsara_kalayukti",   // 52
        "samvatsara_siddharthi",  // 53
        "samvatsara_raudra",      // 54
        "samvatsara_durmati",     // 55
        "samvatsara_dundubhi",    // 56
        "samvatsara_rudhirodgari",// 57
        "samvatsara_raktakshi",   // 58
        "samvatsara_krodhana",    // 59
        "samvatsara_akshaya",     // 60
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
        let offset = year - baseYear
        let modulo = offset % 60
        // Adjust for negative years (before base year)
        let adjustedModulo = modulo < 0 ? modulo + 60 : modulo
        // Convert 0-based to 1-based (1-60 instead of 0-59)
        return adjustedModulo + 1
    }
    
    /// Base year (1987 = Krodhi, index 38 in traditional ordering)
    /// For this implementation, we treat 1987 as index 1 for simplicity
    public static var referenceYear: Int {
        return baseYear
    }
}

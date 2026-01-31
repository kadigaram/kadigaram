
import Foundation

/// Loads help content from localized Markdown files in the app bundle.
public struct HelpContentLoader {
    
    /// Loads the markdown content for the specified language.
    /// - Parameter language: The language code (e.g., "en", "ta").
    /// - Returns: The content of the Help.md file, or a fallback message/English content if not found.
    public static func loadContent(for language: AppLanguage) -> String {
        // Correct logic to find the file:
        // 1. Try to find Help.md in the language-specific lproj folder
        // 2. Fallback to en.lproj if not found
        // 3. Last resort fallback string
        
        let langCode = language.rawValue
        
        // Log for debugging
        print("[HelpContentLoader] Attempting to load content for: \(langCode)")
        
        if let content = loadFile(language: langCode) {
             print("[HelpContentLoader] Successfully loaded \(langCode) content")
            return content
        }
        
        // Fallback to English if the requested language was not English
        if language != .english {
            print("[HelpContentLoader] Fallback: Attempting to load English content")
            if let content = loadFile(language: "en") {
                return content
            }
        }
        
        print("[HelpContentLoader] Critical Error: Helper content not found")
        return "# Help\n\nHelp content is currently unavailable."
    }
    
    private static func loadFile(language: String) -> String? {
        // Use Bundle.module for package resources
        // Note: For Bundle.module to work, the package must include resources in Package.swift
        
        // We look for "Help" in the localized lproj
        if let path = Bundle.module.path(forResource: "Help", ofType: "md", inDirectory: "\(language).lproj") {
            return try? String(contentsOfFile: path)
        }
        
        return nil
    }
}

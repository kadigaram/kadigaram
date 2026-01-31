import SwiftUI
import KadigaramCore

struct LanguageToggle: View {
    @ObservedObject var bhashaEngine: BhashaEngine
    
    var body: some View {
        Picker(selection: Binding(
            get: { bhashaEngine.currentLanguage },
            set: { newLanguage in
                bhashaEngine.setLanguage(newLanguage)
            }
        )) {
            ForEach(AppLanguage.allCases, id: \.self) { language in
                Text(languageName(for: language)).tag(language)
            }
        } label: {
            Label("Language", systemImage: "textformat.size")
        }
        .pickerStyle(.menu)
    }
    
    func languageName(for language: AppLanguage) -> String {
        switch language {
        case .english: return "English"
        case .tamil: return "Tamil (தமிழ்)"
        case .sanskrit: return "Sanskrit (संस्कृतम्)"
        case .telugu: return "Telugu (తెలుగు)"
        case .kannada: return "Kannada (ಕನ್ನಡ)"
        case .malayalam: return "Malayalam (മലയാളം)"
        }
    }
}

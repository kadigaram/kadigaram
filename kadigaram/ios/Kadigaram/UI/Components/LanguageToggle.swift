import SwiftUI
import KadigaramCore

struct LanguageToggle: View {
    @ObservedObject var  bhashaEngine: BhashaEngine
    @State private var showingMenu = false
    
    var body: some View {
        Button(action: {
            showingMenu = true
        }) {
            HStack {
                Image(systemName: "textformat.size") // Icon representing language/text
                Text(currentLanguageLabel)
            }
            .padding(10)
            .background(Color.secondary.opacity(0.1))
            .cornerRadius(20)
        }
        .sheet(isPresented: $showingMenu) {
            LanguageSelectionView(bhashaEngine: bhashaEngine)
                .presentationDetents([.medium])
        }
    }
    
    private var currentLanguageLabel: String {
        switch bhashaEngine.currentLanguage {
        case .english: return "English"
        case .tamil: return "தமிழ்"
        case .sanskrit: return "संस्कृतम्"
        case .telugu: return "తెలుగు"
        case .kannada: return "ಕನ್ನಡ"
        case .malayalam: return "മലയാളം"
        }
    }
}

struct LanguageSelectionView: View {
    @ObservedObject var bhashaEngine: BhashaEngine
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            List(AppLanguage.allCases, id: \.self) { language in
                Button(action: {
                    bhashaEngine.setLanguage(language)
                    dismiss()
                }) {
                    HStack {
                        Text(languageName(for: language))
                            .foregroundColor(.primary)
                        Spacer()
                        if bhashaEngine.currentLanguage == language {
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
            .navigationTitle("Choose Language")
            .navigationBarTitleDisplayMode(.inline)
        }
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

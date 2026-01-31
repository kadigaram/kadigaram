
import SwiftUI

public struct HelpView: View {
    @ObservedObject var bhashaEngine: BhashaEngine
    @Environment(\.dismiss) var dismiss
    
    // We can load content on init or on appear. On appear is safer/lazy.
    @State private var markdownContent: String = ""
    
    public init(bhashaEngine: BhashaEngine) {
        self.bhashaEngine = bhashaEngine
    }
    
    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text(LocalizedStringKey(markdownContent))
                        .padding()
                }
            }
            // Use key for localization or raw string if simple
            .navigationTitle(bhashaEngine.localizedString("Help"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.gray)
                    }
                }
            }
            .onAppear {
                loadContent()
            }
            .onChange(of: bhashaEngine.currentLanguage) { _, _ in
                loadContent()
            }
        }
    }
    
    private func loadContent() {
        self.markdownContent = HelpContentLoader.loadContent(for: bhashaEngine.currentLanguage)
    }
}

#Preview {
    HelpView(bhashaEngine: BhashaEngine())
}

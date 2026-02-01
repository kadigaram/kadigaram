
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
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(parsedComponents, id: \.id) { component in
                        renderComponent(component)
                    }
                }
                .padding()
            }
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
        let rawContent = HelpContentLoader.loadContent(for: bhashaEngine.currentLanguage)
        self.markdownContent = rawContent
        parseMarkdown(rawContent)
    }
    
    // MARK: - Simple Markdown Parsing
    
    struct MarkdownComponent: Identifiable {
        let id = UUID()
        let type: ComponentType
        let text: String
    }
    
    enum ComponentType {
        case header1
        case header2
        case body
        case bullet
    }
    
    @State private var parsedComponents: [MarkdownComponent] = []
    
    private func parseMarkdown(_ content: String) {
        var components: [MarkdownComponent] = []
        let lines = content.components(separatedBy: .newlines)
        
        for line in lines {
            let trimmed = line.trimmingCharacters(in: .whitespaces)
            guard !trimmed.isEmpty else { continue } // Skip empty lines for cleaner UI
            
            if trimmed.hasPrefix("# ") {
                components.append(MarkdownComponent(type: .header1, text: String(trimmed.dropFirst(2))))
            } else if trimmed.hasPrefix("## ") {
                components.append(MarkdownComponent(type: .header2, text: String(trimmed.dropFirst(3))))
            } else if trimmed.hasPrefix("- ") {
                 components.append(MarkdownComponent(type: .bullet, text: String(trimmed.dropFirst(2))))
            } else {
                components.append(MarkdownComponent(type: .body, text: trimmed))
            }
        }
        self.parsedComponents = components
    }
    
    @ViewBuilder
    private func renderComponent(_ component: MarkdownComponent) -> some View {
        switch component.type {
        case .header1:
            Text(try! AttributedString(markdown: component.text))
                .font(.largeTitle)
                .bold()
                .padding(.top, 10)
        case .header2:
            Text(try! AttributedString(markdown: component.text))
                .font(.title2)
                .bold()
                .padding(.top, 8)
        case .body:
            Text(try! AttributedString(markdown: component.text))
                .font(.body)
                .padding(.bottom, 2)
        case .bullet:
            HStack(alignment: .top) {
                Text("•").font(.body).bold()
                Text(try! AttributedString(markdown: component.text))
                    .font(.body)
            }
        }
    }
}

#Preview {
    HelpView(bhashaEngine: BhashaEngine())
}

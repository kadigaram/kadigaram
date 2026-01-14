import SwiftUI
import Combine
import KadigaramCore

@MainActor
class LocationSearchViewModel: ObservableObject {
    @Published var query = ""
    @Published var results: [LocationResult] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let service = LocationSearchService()
    private var searchTask: Task<Void, Never>?
    
    func performSearch() {
        searchTask?.cancel()
        
        guard !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            results = []
            isLoading = false
            errorMessage = nil
            return
        }
        
        searchTask = Task {
            isLoading = true
            errorMessage = nil
            
            // Artificial delay for debounce when typing fast
            try? await Task.sleep(nanoseconds: 300_000_000) // 0.3s
            if Task.isCancelled { return }
            
            do {
                let items = try await service.search(query: query)
                if !Task.isCancelled {
                    self.results = items
                    self.isLoading = false
                }
            } catch {
                print("Search error: \(error)")
                if !Task.isCancelled {
                    self.isLoading = false
                    self.errorMessage = "Could not find locations. Please check your internet connection."
                }
            }
        }
    }
}

public struct LocationSearchView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = LocationSearchViewModel()
    
    // Callback when user selects a location
    public var onSelect: (LocationResult) -> Void
    
    public init(onSelect: @escaping (LocationResult) -> Void) {
        self.onSelect = onSelect
    }
    
    public var body: some View {
        NavigationStack {
            List {
                if viewModel.isLoading {
                    HStack {
                        Spacer()
                        ProgressView("Searching...")
                        Spacer()
                    }
                    .listRowSeparator(.hidden)
                } else if let error = viewModel.errorMessage {
                    VStack(spacing: 8) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.largeTitle)
                            .foregroundColor(.orange)
                        Text(error)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.secondary)
                        Button("Retry") {
                            viewModel.performSearch()
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .listRowSeparator(.hidden)
                    .padding()
                } else if viewModel.results.isEmpty && !viewModel.query.isEmpty {
                    Text("No results found for \"\(viewModel.query)\"")
                        .foregroundColor(.secondary)
                        .listRowSeparator(.hidden)
                } else {
                    ForEach(viewModel.results) { result in
                        Button {
                            onSelect(result)
                            dismiss()
                        } label: {
                            VStack(alignment: .leading) {
                                Text(result.name)
                                    .font(.body)
                                    .foregroundColor(.primary)
                                if let timeZone = result.timeZoneIdentifier {
                                    Text(timeZone)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                    }
                }
            }
            .listStyle(.plain)
            .searchable(text: $viewModel.query, prompt: "Search for a city (e.g. Chennai)")
            .onChange(of: viewModel.query) { oldValue, newValue in
                viewModel.performSearch()
            }
            .navigationTitle("Set Location")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    LocationSearchView { result in
        print("Selected: \(result.name)")
    }
}

import Combine
import Dependencies

@MainActor
final class MovieListViewModel: ObservableObject {
    
    @Dependency(\.movieService) private var movieService
    
    @Published var searchText = "" {
        willSet {
            Task {
                try? await debounce()
                await updateSuggestions(for: newValue)
            }
        }
    }
    
    @Published private(set) var movies: [Movie] = []
    @Published private(set) var filteredMovies: [Movie] = []
    @Published private(set) var suggestions: [String] = []
    

    private var searchTask: Task<Void, Error>?
    private var suggestionsTask: Task<Void, Never>?
    
    private lazy var paginator: Paginator<Movie> = {
        Paginator(loadPage: movieService.fetchLatest)
    }()

    func loadMoreIfNeeded(currentItem: Movie? = nil) async throws {
        guard
            currentItem == nil ||
            currentItem?.id == movies.last?.id
        else { return }
        
        try await paginator.loadNextPage()
        let newOnes = await paginator.items
        let unseen = newOnes.filter { new in
            !movies.contains(where: { $0.id == new.id })
        }
        movies.append(contentsOf: unseen)
    }
    
    func updateSuggestions(for query: String) async {
        guard searchTask == nil else { return }
        suggestionsTask?.cancel()
        suggestions = []
        filteredMovies = []
        guard !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return
        }
        let task = Task {
            let results = try? await movieService.searchMovies(query: query)
            let titles  = results?.compactMap(\.title) ?? []
            suggestions = titles
            suggestionsTask = nil
        }
        suggestionsTask = task
        await task.value
    }
    
    func loadSearchResults(query: String) {
        Task { @MainActor in
            suggestions = []
            filteredMovies = []
            suggestionsTask?.cancel()
            searchTask?.cancel()
            let task = Task { @MainActor in
                try await debounce()
                let movies = try await movieService.searchMovies(query: query)
                filteredMovies = movies
                searchTask = nil
            }
            searchTask = task
            try await task.value
        }
    }
    
    func debounce() async throws {
        try await Task.sleep(nanoseconds: 500_000_000)
    }
}

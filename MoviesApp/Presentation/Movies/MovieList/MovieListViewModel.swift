import Combine
import Dependencies

@MainActor
final class MovieListViewModel: ObservableObject {
    
    @Dependency(\.movieService) private var movieService
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
        
        do {
            try await paginator.loadNextPage()
            let newOnes = await paginator.items
            let unseen = newOnes.filter { new in
                !movies.contains(where: { $0.id == new.id })
            }
            movies.append(contentsOf: unseen)
        } catch {
            // not showing error here due to infinite scroll
        }
    }
    
    func updateSuggestions(for query: String) async {
        guard searchTask == nil else { return }
        guard !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            suggestions = []
            filteredMovies = []
            return
        }
        suggestions = []
        filteredMovies = []
        suggestionsTask?.cancel()
        let task = Task {
            try? await debounce()
            let results = try? await movieService.searchMovies(query: query)
            let titles  = results?.compactMap(\.title) ?? []
            suggestions = titles
            suggestionsTask = nil
        }
        suggestionsTask = task
        await task.value
    }
    
    func loadSearchResults(query: String) async throws {
        suggestions = []
        filteredMovies = []
        suggestionsTask?.cancel()
        searchTask?.cancel()
        let task = Task {
            try await debounce()
            let movies = try await movieService.searchMovies(query: query)
            filteredMovies = movies
            searchTask = nil
        }
        searchTask = task
        try await task.value
    }
    
    private func debounce() async throws {
        try await Task.sleep(nanoseconds: 500_000_000)
    }
}

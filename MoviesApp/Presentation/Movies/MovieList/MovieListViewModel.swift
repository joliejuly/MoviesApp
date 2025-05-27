import Combine
import Dependencies

@MainActor
final class MovieListViewModel: ObservableObject {
    
    @Dependency(\.movieService) private var movieService
    @Published private(set) var movies: [Movie] = []
    @Published private(set) var filteredMovies: [Movie] = []
    @Published var suggestions: [String] = []
    
    private var searchTask: Task<[Movie], Error>?
    
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
        try? await debounce()
        guard !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            suggestions = []
            return
        }
        let results = try? await loadSearchResults(query: query, shouldUpdate: false)
        let titles  = results?.compactMap(\.title) ?? []
        suggestions = titles
    }
    
    func loadSearchResults(query: String, shouldUpdate: Bool = true) async throws -> [Movie] {
        try await debounce()
        let task = Task<[Movie], Error> {
            let movies = try await movieService.searchMovies(query: query)
            if shouldUpdate {
                filteredMovies = movies
                suggestions = []
            }
            searchTask = nil
            return movies
        }
        searchTask = task
        return try await task.value
    }
    
    private func debounce() async throws {
        try await Task.sleep(nanoseconds: 500_000_000)
    }
}

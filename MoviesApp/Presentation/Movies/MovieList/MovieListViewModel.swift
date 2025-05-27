import Combine
import Dependencies

@MainActor
final class MovieListViewModel: ObservableObject {
    
    @Dependency(\.movieService) private var movieService
    @Published private(set) var movies: [Movie] = []
    @Published private(set) var filteredMovies: [Movie] = []
    
    private var searchTask: Task<Void, Error>?
    
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
    
    func loadSearchResults(query: String) async throws {
        searchTask?.cancel()
        searchTask = Task {
            // debounce
            try await Task.sleep(nanoseconds: 500_000_000)
            filteredMovies = try await movieService.searchMovies(query: query)
        }
    }
}

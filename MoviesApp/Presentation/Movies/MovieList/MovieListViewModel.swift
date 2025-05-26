import Combine
import Dependencies

@MainActor
final class MovieListViewModel: ObservableObject {
    
    @Dependency(\.movieService) private var movieService
    @Published private(set) var movies: [Movie] = []
    
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
            movies = await paginator.items
        } catch {
            // not showing error here due to infinite scroll
        }
    }
}


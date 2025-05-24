import Combine

@MainActor
final class MovieListViewModel: ObservableObject {
    @Published private(set) var movies: [Movie] = []
    
    private let paginator: Paginator<Movie>
    
    init(movieService: MovieService) {
        paginator = Paginator(loadPage: movieService.fetchNowPlaying)
    }
    
    func loadMoreIfNeeded(currentItem: Movie? = nil) async throws {
        guard
            currentItem == nil ||
            currentItem?.id == movies.last?.id
        else { return }
        
        do {
            try await paginator.loadNextPage()
            movies = paginator.items
        } catch {
            // TODO: show error
        }
    }
}


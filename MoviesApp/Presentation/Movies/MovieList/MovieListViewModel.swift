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
            let newOnes = await paginator.items
            let unseen = newOnes.filter { new in
                !movies.contains(where: { $0.id == new.id })
            }
            movies.append(contentsOf: unseen)
        } catch {
            // not showing error here due to infinite scroll
        }
    }
}

import SwiftUI

@MainActor
final class MovieDetailViewModel: ObservableObject {
    @Published private(set) var movieDetail: MovieDetail? = nil
    
    private let movieService: MovieService
    
    init(movieService: MovieService) {
        self.movieService = movieService
    }
    
    func loadDetails(id: Int) async throws {
        movieDetail = try await movieService.fetchDetails(id: id)
    }
}

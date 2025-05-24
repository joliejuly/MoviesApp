import SwiftUI
import Dependencies

@MainActor
final class MovieDetailViewModel: ObservableObject {
    @Dependency(\.movieService) private var movieService
    
    @Published private(set) var movieDetailInfo: MovieDetailInfo? = nil
    
    func loadDetails(id: Int) async throws {
        async let movieDetail = try await movieService.fetchDetails(id: id)
        // let image =
        movieDetailInfo = MovieDetailInfo(
            movieDetail: try await movieDetail,
            movieImage: nil
        )
    }
}

struct MovieDetailInfo {
    let movieDetail: MovieDetail?
    let movieImage: Image?
}

import SwiftUI
import Dependencies

@MainActor
final class MovieDetailViewModel: ObservableObject {
    
    @Dependency(\.movieService) private var movieService
    @Dependency(\.movieImageLoader) private var movieImageLoader
    
    @Published var isLoading = false
    @Published var detailImage: Image?

    @Published private(set) var movieDetailInfo: MovieDetailInfo? = nil
    
    func loadDetails(for movie: Movie?) async throws {
        isLoading = true
        defer { isLoading = false }
        guard let movie else { return }
        
        async let detail = try await movieService.fetchDetails(id: movie.id)
        async let image: Image? = {
            guard let path = movie.posterPath else { return nil }
            return try await movieImageLoader.fetchDetailImage(path: path)
        }()
        
        let (movieDetail, movieImage) = try await (detail, image)
        
        movieDetailInfo = MovieDetailInfo(
            movieDetail: movieDetail,
            movieImage: movieImage
        )
    }
    
    func loadImage(for movie: Movie?) async throws {
        try? await loadDetails(for: movie)
        guard let loadedImage = movieDetailInfo?.movieImage else { return }
        detailImage = loadedImage
    }
}

struct MovieDetailInfo {
    let movieDetail: MovieDetail?
    let movieImage: Image?
}

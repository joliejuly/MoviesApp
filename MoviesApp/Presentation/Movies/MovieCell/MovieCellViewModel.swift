import SwiftUI
import Dependencies

@MainActor
final class MovieCellViewModel: ObservableObject {
    
    @Dependency(\.movieService) private var movieService
    @Dependency(\.movieImageLoader) private var movieImageLoader
    
    @Published var image: Image? = nil
    
    func loadImage(for movie: Movie) async throws {
        guard let posterPath = movie.posterPath else { return }
        image = try await movieImageLoader.fetchThumbnail(path: posterPath)
    }
}

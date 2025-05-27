import SwiftUI
import Dependencies

@MainActor
final class MovieCellViewModel: ObservableObject {
    
    @Dependency(\.movieService) private var movieService
    @Dependency(\.movieImageLoader) private var movieImageLoader
    
    @Published var image: Image? = nil
    @Published var isLoading = false
    
    
    func loadImage(for movie: Movie) async throws {
        isLoading = true
        defer { isLoading = false }
        guard let posterPath = movie.posterPath else { return }
        image = try await movieImageLoader.fetchThumbnail(path: posterPath)
    }
}

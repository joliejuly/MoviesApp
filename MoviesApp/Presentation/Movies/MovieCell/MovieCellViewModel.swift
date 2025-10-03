import SwiftUI
import Dependencies

@MainActor
final class MovieCellViewModel: ObservableObject {
    
    @Dependency(\.movieImageLoader) private var movieImageLoader
    
    @Published var image: Image? = nil
    @Published var isLoading = false
    
    
    func loadImage(for movie: Movie) async throws {
        isLoading = true
        defer { isLoading = false }
        guard let posterPath = movie.posterPath else { return }
        image = try await movieImageLoader.fetchThumbnail(path: posterPath)
    }
    
    func releaseYear(for movie: Movie) -> String?  {
        guard let date = movie.releaseDate else { return nil }
        let year = yearDateFormatter.string(from: date)
        return "Release year: \(year)"
    }
    
    func rating(for movie: Movie) -> String?  {
        guard let rating = movie.rating else { return nil }
        return "Rating: \(rating)"
    }
    
}

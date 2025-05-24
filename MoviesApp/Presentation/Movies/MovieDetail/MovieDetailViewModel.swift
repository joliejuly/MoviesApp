import SwiftUI
import Dependencies

@MainActor
final class MovieDetailViewModel: ObservableObject {
    @Dependency(\.movieService) private var movieService
    
    @Published private(set) var movieDetail: MovieDetail? = nil
    
    func loadDetails(id: Int) async throws {
        movieDetail = try await movieService.fetchDetails(id: id)
    }
}

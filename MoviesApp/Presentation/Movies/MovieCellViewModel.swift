import SwiftUI

@MainActor
final class MovieCellViewModel: ObservableObject {
    @Published private(set) var image: Image? = nil
    
    private let movieService: MovieService
    
    init(movieService: MovieService) {
        self.movieService = movieService
    }
    
    // todo: clear cache on background
    func loadImage(for movie: Movie) async throws {
        
        
    }
}

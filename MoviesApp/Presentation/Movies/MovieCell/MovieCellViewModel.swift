import SwiftUI
import Dependencies

@MainActor
final class MovieCellViewModel: ObservableObject {
    
    @Dependency(\.movieService) private var movieService
    
    @Published private(set) var image: Image? = nil
    
    func loadImage(for movie: Movie) async throws {
        
        
    }
}

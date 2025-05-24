import Foundation
import struct MVNetwork.MovieDTO

struct Movie: Equatable, Identifiable {
    let id: Int
    let originalTitle: String
    let posterPath: String?
    let title: String
    
    init(dto: MovieDTO) {
        self.id = dto.id
        self.originalTitle = dto.originalTitle
        self.posterPath = dto.posterPath
        self.title = dto.title.capitalized(with: Locale.autoupdatingCurrent)
    }
}

import Foundation
import struct MVNetwork.MovieDTO

struct MovieMapper {
    static func map(_ dto: MovieDTO) -> Movie {
        Movie(
            id: dto.id,
            title: dto.originalTitle.capitalized(with: Locale.autoupdatingCurrent),
            originalTitle: dto.title.capitalized(with: Locale.autoupdatingCurrent),
            posterPath: dto.posterPath,
            releaseDate: dto.releaseDate,
            rating: dto.voteAverage
        )
    }
}

import Foundation
import struct MVNetwork.MovieDTO
import struct MVNetwork.SuggestionMovieDTO

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
    
    static func suggestionMap(_ dto: SuggestionMovieDTO) -> SuggestionMovie {
        SuggestionMovie(
            id: dto.id,
            title: dto.title.capitalized(with: Locale.autoupdatingCurrent)
        )
    }
}

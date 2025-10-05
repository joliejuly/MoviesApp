import Foundation
import struct MVNetwork.MovieDetailDTO

/// Maps DTOs to presentation models with additional formatting
struct MovieDetailMapper {
    static func map(_ dto: MovieDetailDTO) -> MovieDetail {
        let genres = dto.genres.map(\.name).joined(separator: ", ")
        let budget = dto.budget > 0 ? dto.budget : nil
        return MovieDetail(
            id: dto.id,
            title: dto.title.capitalized(with: Locale.autoupdatingCurrent),
            budget: budget,
            genres: genres.isEmpty ? nil : genres,
            originalTitle: dto.originalTitle.capitalized(with: Locale.autoupdatingCurrent),
            overview: dto.overview.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : dto.overview
        )
    }
}

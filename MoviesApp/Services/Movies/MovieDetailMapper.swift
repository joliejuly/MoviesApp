import struct MVNetwork.MovieDetailDTO

struct MovieDetailMapper {
    static func map(_ dto: MovieDetailDTO) -> MovieDetail {
        MovieDetail(
            id: dto.id,
            title: dto.title,
            budget: dto.budget,
            genres: dto.genres.map { Genre(id: $0.id, name: $0.name) },
            homepage: dto.homepage,
            imdbID: dto.imdbID,
            originCountry: dto.originCountry,
            originalLanguage: dto.originalLanguage,
            originalTitle: dto.originalTitle,
            overview: dto.overview,
            popularity: dto.popularity,
            posterPath: dto.posterPath,
            productionCompanies: dto.productionCompanies.map {
                ProductionCompany(
                    id: $0.id,
                    logoPath: $0.logoPath,
                    name: $0.name,
                    originCountry: $0.originCountry
                )
            },
            productionCountries: dto.productionCountries.map {
                ProductionCountry(
                    name: $0.name
                )
            },
            releaseDate: dto.releaseDate,
            revenue: dto.revenue,
            runtime: dto.runtime,
            spokenLanguages: dto.spokenLanguages.map {
                SpokenLanguage(
                    englishName: $0.englishName,
                    name: $0.name
                )
            },
            status: dto.status,
            tagline: dto.tagline
        )
    }
}

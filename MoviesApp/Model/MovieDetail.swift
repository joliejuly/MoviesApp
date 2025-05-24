import Foundation

struct MovieDetail: Identifiable, Equatable {
    let id: Int
    let title: String
    let budget: Int
    let genres: [Genre]
    let homepage: String
    let imdbID: String?
    let originCountry: [String]
    let originalLanguage: String
    let originalTitle: String
    let overview: String
    let popularity: Double
    let posterPath: String?
    let productionCompanies: [ProductionCompany]
    let productionCountries: [ProductionCountry]
    let releaseDate: Date?
    let revenue: Int
    let runtime: Int?
    let spokenLanguages: [SpokenLanguage]
    let status: String
    let tagline: String
}

struct Genre: Equatable {
    let id: Int
    let name: String
}

struct ProductionCompany: Equatable {
    let id: Int?
    let logoPath: String?
    let name: String
    let originCountry: String
}

struct ProductionCountry: Equatable {
    let name: String
}

struct SpokenLanguage: Equatable {
    let englishName: String
    let name: String
}

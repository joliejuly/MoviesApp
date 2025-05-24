import Foundation

public struct MovieDetailDTO: Decodable {
    public let id: Int
    public let title: String
    public let budget: Int
    public let genres: [GenreDTO]
    public let homepage: String
    public let imdbID: String?
    public let originCountry: [String]
    public let originalLanguage: String
    public let originalTitle: String
    public let overview: String
    public let popularity: Double
    public let posterPath: String?
    public let productionCompanies: [ProductionCompanyDTO]
    public let productionCountries: [ProductionCountryDTO]
    public let releaseDate: Date?
    public let revenue: Int
    public let runtime: Int?
    public let spokenLanguages: [SpokenLanguageDTO]
    public let status: String
    public let tagline: String
}

public struct GenreDTO: Decodable {
    public let id: Int
    public let name: String
}

public struct ProductionCompanyDTO: Decodable {
    public let id: Int?
    public let logoPath: String?
    public let name: String
    public let originCountry: String
}

public struct ProductionCountryDTO: Decodable {
    public let name: String
}

public struct SpokenLanguageDTO: Decodable {
    public let englishName: String
    public let name: String
}

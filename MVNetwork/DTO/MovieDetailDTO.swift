import Foundation

public struct MovieDetailDTO: Decodable {
    public let id: Int
    public let title: String
    public let budget: Int
    public let genres: [GenreDTO]
    public let originalTitle: String
    public let overview: String
    public let posterPath: String?
}

public struct GenreDTO: Decodable {
    public let id: Int
    public let name: String
}

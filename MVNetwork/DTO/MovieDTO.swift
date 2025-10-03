import Foundation

public struct MovieDTO: Decodable {
    public let id: Int
    public let title: String
    public let originalTitle: String
    public let posterPath: String?
    public let releaseDate: Date?
    public let voteAverage: Double?
}

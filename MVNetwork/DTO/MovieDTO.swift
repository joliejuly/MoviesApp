import Foundation

public struct MovieDTO: Decodable {
    public let id: Int
    public let title: String
    public let originalTitle: String
    public let posterPath: String?
}

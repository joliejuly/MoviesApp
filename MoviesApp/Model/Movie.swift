import Foundation

/// Main movie model used in the list of movies
struct Movie: Equatable, Identifiable, Hashable {
    let id: Int
    let title: String
    let originalTitle: String
    let posterPath: String?
    let releaseDate: Date?
    let rating: Double?
}


import Foundation

struct Movie: Equatable, Identifiable, Hashable {
    let id: Int
    let title: String
    let originalTitle: String
    let posterPath: String?
    let releaseDate: Date?
    let rating: Double?
}

struct SuggestionMovie: Equatable, Identifiable, Hashable {
    let id: Int
    let title: String
}

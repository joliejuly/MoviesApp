import Foundation

/// Model for displaying movie details on its own page
struct MovieDetail: Identifiable, Equatable {
    let id: Int
    let title: String
    let budget: Int?
    let genres: String?
    let originalTitle: String
    let overview: String?
}

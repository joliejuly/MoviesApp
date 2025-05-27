import Foundation

struct MovieDetail: Identifiable, Equatable {
    let id: Int
    let title: String
    let budget: Int?
    let genres: String?
    let originalTitle: String
    let overview: String?
}

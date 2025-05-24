import Foundation

struct Movie: Equatable, Identifiable, Hashable {
    let id: Int
    let title: String
    let originalTitle: String
    let posterPath: String?
}

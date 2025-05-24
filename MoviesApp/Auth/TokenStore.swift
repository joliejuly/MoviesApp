import Foundation

public protocol TokenStore {
    var currentToken: String? { get }
}

struct DefaultTokenStore: TokenStore {
    var currentToken: String? {
        Bundle.main.tmdbAccessToken
    }
}

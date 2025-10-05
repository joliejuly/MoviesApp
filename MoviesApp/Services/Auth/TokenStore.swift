import Foundation

/// Flexible TokenStore that can be changed in tests
public protocol TokenStore {
    var currentToken: String? { get }
}

struct DefaultTokenStore: TokenStore {
    var currentToken: String? {
        Bundle.main.tmdbAccessToken
    }
}

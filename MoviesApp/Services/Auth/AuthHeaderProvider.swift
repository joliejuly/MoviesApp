import MVNetwork

/// Helper that constructs auth header for api
struct AuthHeaderProvider: HeaderProvider {
    let tokenStore: TokenStore
    
    func headers(for endpoint: Endpoint) -> [String: String] {
        var all = defaultHeaders()
        endpoint.headers.forEach { all[$0] = $1 }
        if let token = tokenStore.currentToken {
            all["Authorization", default: ""] = "Bearer \(token)"
        }
        return all
    }
}

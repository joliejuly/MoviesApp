import Network

struct AuthHeaderProvider: HeaderProvider {
    let tokenStore: TokenStore
    
    func headers(for endpoint: Endpoint) -> [String: String] {
        var all = defaultHeaders()
        endpoint.headers.forEach { all[$0] = $1 }
        if let t = tokenStore.currentToken {
            all["Authorization", default: ""] = "Bearer \(t)"
        }
        return all
    }
}

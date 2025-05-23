public protocol HeaderProvider {
    func headers(for endpoint: Endpoint) -> [String: String]
    func defaultHeaders() -> [String: String]
}

public extension HeaderProvider {
    func defaultHeaders() -> [String: String] {
        Constants.defaultHeaders
    }
    
    func headers(for endpoint: Endpoint) -> [String: String] {
        var all = defaultHeaders()
        endpoint.headers.forEach { all[$0] = $1 }
        return all
    }
}

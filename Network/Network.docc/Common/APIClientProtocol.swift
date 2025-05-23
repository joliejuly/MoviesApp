public protocol APIClientProtocol {
    var baseURL: URL { get }
    func send<T: Decodable>(_ endpoint: Endpoint, as type: T.Type) async throws -> T
}

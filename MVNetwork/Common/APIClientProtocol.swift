public protocol APIClientProtocol {
    func send<Response: Decodable>(_ endpoint: Endpoint, type: Response.Type, baseURL: URL) async throws -> Response
    func send<Body: Encodable, Response: Decodable>(_ endpoint: Endpoint, body: Body?, type: Response.Type, baseURL: URL) async throws -> Response
    func fetchData(_ endpoint: Endpoint, baseURL: URL) async throws -> Data
}

extension APIClientProtocol {
    func send<Body: Encodable, Response: Decodable>(_ endpoint: Endpoint, body: Body?, type: Response.Type, baseURL: URL) async throws -> Response {
        throw APIError.notImplemented
    }
}

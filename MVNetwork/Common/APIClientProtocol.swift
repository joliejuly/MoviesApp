public protocol APIClientProtocol {
    func send<Response: Decodable>(_ endpoint: Endpoint, type: Response.Type, baseURL: URL) async throws -> Response
    func send<Body: Encodable, Response: Decodable>(_ endpoint: Endpoint, body: Body?, type: Response.Type, baseURL: URL) async throws -> Response
}

extension APIClientProtocol {
    func send<Body: Encodable, Response: Decodable>(_ endpoint: Endpoint, body: Body?, type: Response.Type, baseURL: URL) async throws -> Response {
        throw APIError.notImplemented
    }
}

public protocol APIClientProtocol {
    var baseURL: URL { get }
    func send<Body: Encodable, Response: Decodable>(_ endpoint: Endpoint, body: Body?, type: Response.Type) async throws -> Response
}

import os
import Foundation

public actor APIClient: APIClientProtocol {
    
    private let session: URLSession
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder
    private let logger = Logger(subsystem: Constants.bundleIdentifier, category: "API")
    private let headerProvider: HeaderProvider?
    
    public init(
        session: URLSession = .shared,
        headerProvider: HeaderProvider? = nil,
        decoder: JSONDecoder = {
            let d = JSONDecoder()
            d.keyDecodingStrategy = .convertFromSnakeCase
            d.dateDecodingStrategy = .formatted(yyyyMMddDateFormatter)
            return d
        }(),
        encoder: JSONEncoder = {
            let d = JSONEncoder()
            d.keyEncodingStrategy = .convertToSnakeCase
            d.dateEncodingStrategy = .formatted(yyyyMMddDateFormatter)
            return d
        }()
    ) {
        self.session = session
        self.headerProvider = headerProvider
        self.decoder = decoder
        self.encoder = encoder
    }
    
    public func send<Body: Encodable, Response: Decodable>(_ endpoint: Endpoint, body: Body? = nil, type: Response.Type, baseURL: URL) async throws -> Response {
        
        let url = try makeURL(baseURL: baseURL, endpoint: endpoint)
        var request = try makeRequest(url: url, endpoint: endpoint)
        
        if let body {
            let encoded = try encoder.encode(body)
            request.httpBody = encoded
        }
        
        logRequestStart(url: url, endpoint: endpoint, request: request)
        
        return try await perform(request, decodeTo: type)
    }
    
    public func send<Response: Decodable>(_ endpoint: Endpoint, type: Response.Type, baseURL: URL) async throws -> Response {
        
        let url = try makeURL(baseURL: baseURL, endpoint: endpoint)
        let request = try makeRequest(url: url, endpoint: endpoint)
        
        logRequestStart(url: url, endpoint: endpoint, request: request)
        
        return try await perform(request, decodeTo: type)
    }
    
    public func fetchData(_ endpoint: Endpoint, baseURL: URL) async throws -> Data {
        let url = try makeURL(baseURL: baseURL, endpoint: endpoint)
        let request = try makeRequest(url: url, endpoint: endpoint)
        
        logger.debug("📡 → FETCH-DATA \(url.absoluteString)")
        
        let (data, response) = try await session.data(for: request)
        guard let http = response as? HTTPURLResponse, (200...299).contains(http.statusCode) else {
            let code = (response as? HTTPURLResponse)?.statusCode ?? -1
            logger.error("🚫 HTTP \(code) for \(url)")
            throw APIError.http(statusCode: code, data: data)
        }
        return data
    }
    
    private func logRequestStart(url: URL, endpoint: Endpoint, request: URLRequest) {
        logger.debug("📡 → \(endpoint.method.rawValue.uppercased()) \(url.absoluteString) headers: \(String(describing: request.allHTTPHeaderFields))")
    }
    
    private func perform<Response: Decodable>(
        _ request: URLRequest,
        decodeTo type: Response.Type
    ) async throws -> Response {
        do {
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.unknown
            }
            
            let url = request.url?.absoluteString ?? ""
            
            guard (200...299).contains(httpResponse.statusCode) else {
                
                logger.error("🚫 HTTP \(httpResponse.statusCode) for \(url)")
                
                throw APIError.http(
                    statusCode: httpResponse.statusCode,
                    data: data
                )
            }
            
            let value = try decoder.decode(Response.self, from: data)
            logger.debug("✅ ← Decoded \(Response.self) from \(url)")
            return value
        } catch let error as APIError {
            throw error
        } catch let error as DecodingError {
            logger.error("⚠️ Decoding error for \(Response.self): \(error.localizedDescription)")
            throw APIError.decoding(error)
        } catch {
            logger.error("⚠️ Network error: \(error.localizedDescription)")
            throw APIError.network(error)
        }
    }
    
    private func makeURL(baseURL: URL, endpoint: Endpoint) throws -> URL {
        guard
            var components = URLComponents(
                url: baseURL.appendingPathComponent(endpoint.path),
                resolvingAgainstBaseURL: false
            ) else {
            throw APIError.invalidURL
        }
        
        components.queryItems = endpoint.queryItems
        guard let url = components.url else {
            throw APIError.invalidURL
        }
        
        return url
    }
    
    private func makeRequest(url: URL, endpoint: Endpoint) throws -> URLRequest {
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue.uppercased()
        
        let headers = headerProvider?.headers(for: endpoint)
        headers?.forEach {
            request.setValue($0.value, forHTTPHeaderField: $0.key)
        }
        
        return request
    }
}

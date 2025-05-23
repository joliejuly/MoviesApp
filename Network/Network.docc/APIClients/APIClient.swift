import os
import Foundation

public final class APIClient: APIClientProtocol {
    
    public let baseURL: URL
    
    private let session: URLSession
    private let decoder: JSONDecoder
    private let logger = Logger(subsystem: "com.joliejuly.MovieApp", category: "API")
    private let headerProvider: HeaderProvider?
    
    public init(
        baseURL: URL,
        session: URLSession = .shared,
        headerProvider: HeaderProvider? = nil,
        decoder: JSONDecoder = {
            let d = JSONDecoder()
            d.keyDecodingStrategy = .convertFromSnakeCase
            return d
        }()
    ) {
        self.baseURL = baseURL
        self.session = session
        self.headerProvider = headerProvider
        self.decoder = decoder
    }
    
    public func send<T: Decodable>(_ endpoint: Endpoint, as type: T.Type) async throws -> T {

        let url = try makeURL(baseURL: baseURL, path: endpoint.path)
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.httpBody = endpoint.body
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        logger.debug("📡 → \(endpoint.method.rawValue) \(url.absoluteString)")
        
        do {
            // 3. Perform
            let (data, response) = try await session.data(for: request)
            
            // 4. Check HTTP status
            if let http = response as? HTTPURLResponse,
               !(200...299).contains(http.statusCode) {
                logger.error("🚫 HTTP \(http.statusCode) for \(url.absoluteString)")
                throw APIError.http(statusCode: http.statusCode, data: data)
            }
            
            // 5. Decode
            let value = try decoder.decode(T.self, from: data)
            logger.debug("✅ ← decoded \(T.self) from \(url.absoluteString)")
            return value
            
        } catch let err as APIError {
            throw err
        } catch is DecodingError {
            logger.error("⚠️ Decoding error for \(T.self): \(err.localizedDescription)")
            throw APIError.decoding(err)
        } catch {
            logger.error("⚠️ Network error: \(err.localizedDescription)")
            throw APIError.network(err)
        }
    }
    
    private func makeURL(baseURL: URL, path: String) throws -> URL {
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
}

public enum APIError: Error, LocalizedError {
    case invalidURL
    case network(Error)
    case http(statusCode: Int, data: Data?)
    case decoding(Error)
    case unknown
    case notImplemented
    
    public var description: String {
        switch self {
            case .invalidURL:       
                return "Invalid URL"
            case .network(let error):
                return "Network error: \(error.localizedDescription)"
            case .http(let code, _):
                return "HTTP error \(code)"
            case .decoding(let error):
                return "Decoding error: \(error.localizedDescription)"
            case .notImplemented:
                return "Api client method not implemented"
            case .unknown:
                return "Unknown error"
            
        }
    }
}


import Foundation

final class MockURLProtocol: URLProtocol {
    static var stubData: Data?
    static var stubResponse: HTTPURLResponse?
    static var stubError: Error?
    
    override class func canInit(with request: URLRequest) -> Bool {
        // Intercept all requests
        true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }
    
    override func startLoading() {
        if let error = MockURLProtocol.stubError {
            client?.urlProtocol(self, didFailWithError: error)
        } else {
            if let response = MockURLProtocol.stubResponse {
                client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            }
            if let data = MockURLProtocol.stubData {
                client?.urlProtocol(self, didLoad: data)
            }
            client?.urlProtocolDidFinishLoading(self)
        }
    }
    
    override func stopLoading() {
        
    }
}

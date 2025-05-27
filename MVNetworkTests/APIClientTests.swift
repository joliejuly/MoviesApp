import XCTest
@testable import MVNetwork

private struct DummyResponse: Codable, Equatable {
    let id: Int
    let name: String
}

final class APIClientTests: XCTestCase {
    private var client: APIClient!
    private static let baseURL = URL(string: "https://example.com")!
    
    override func setUp() {
        super.setUp()
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: config)
        client = APIClient(session: session, headerProvider: nil)
    }
    
    override func tearDown() {
        MockURLProtocol.stubData = nil
        MockURLProtocol.stubResponse = nil
        MockURLProtocol.stubError = nil
        client = nil
        super.tearDown()
    }
    
    func testSendDecodable_ReturnsDecodedObject() async throws {
        
        let dummy = DummyResponse(id: 42, name: "Test")
        MockURLProtocol.stubData = try JSONEncoder().encode(dummy)
        MockURLProtocol.stubResponse = HTTPURLResponse(
            url: Self.baseURL,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
    
        let result: DummyResponse = try await client.send(
            Endpoint(path: "/exapmple", method: .get),
            type: DummyResponse.self,
            baseURL: Self.baseURL
        )
        
       
        XCTAssertEqual(result, dummy)
    }
    
    func testSendDecodable_HTTPErrorThrowsAPIErrorHttp() async {
        
        let text = "Not Found"
        MockURLProtocol.stubData = text.data(using: .utf8)
        MockURLProtocol.stubResponse = HTTPURLResponse(
            url: Self.baseURL,
            statusCode: 404,
            httpVersion: nil,
            headerFields: nil
        )
        
        do {
            let _: DummyResponse = try await client.send(
                Endpoint(path: "/example"),
                type: DummyResponse.self,
                baseURL: Self.baseURL
            )
            XCTFail("Expected to throw")
        } catch APIError.http(let statusCode, let data) {
            XCTAssertEqual(statusCode, 404)
            XCTAssertEqual(data, text.data(using: .utf8))
        } catch {
            XCTFail("Expected APIError.http, got \(error)")
        }
    }
    
    func testSendDecodable_DecodingErrorThrowsAPIErrorDecoding() async {
        // Given: valid HTTP 200 but invalid JSON for DummyResponse
        let invalidJSON = #"{"identifier":1,"title":"Error"}"#.data(using: .utf8)!
        MockURLProtocol.stubData = invalidJSON
        MockURLProtocol.stubResponse = HTTPURLResponse(
            url: Self.baseURL,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        
        do {
            let _: DummyResponse = try await client.send(
                Endpoint(path: "/example"),
                type: DummyResponse.self,
                baseURL: Self.baseURL
            )
            XCTFail("Expected to throw")
        } catch APIError.decoding(let decodingError) {
            // We got a DecodingError as expected
            XCTAssertTrue(decodingError is DecodingError)
        } catch {
            XCTFail("Expected APIError.decoding, got \(error)")
        }
    }
    
    func testFetchData_ReturnsRawData() async throws {
        // Given
        let expected = "raw data".data(using: .utf8)!
        MockURLProtocol.stubData = expected
        MockURLProtocol.stubResponse = HTTPURLResponse(
            url: Self.baseURL,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        
        let data = try await client.fetchData(
            Endpoint(path: "/data"),
            baseURL: Self.baseURL
        )
        
        XCTAssertEqual(data, expected)
    }
    
    func testFetchData_HTTPErrorThrowsAPIErrorHttp() async {
        MockURLProtocol.stubData = Data()
        MockURLProtocol.stubResponse = HTTPURLResponse(
            url: Self.baseURL,
            statusCode: 500,
            httpVersion: nil,
            headerFields: nil
        )
        
        do {
            _ = try await client.fetchData(
                Endpoint(path: "/data"),
                baseURL: Self.baseURL
            )
            XCTFail("Expected to throw")
        } catch APIError.http(let statusCode, _) {
            XCTAssertEqual(statusCode, 500)
        } catch {
            XCTFail("Expected APIError.http, got \(error)")
        }
    }
}

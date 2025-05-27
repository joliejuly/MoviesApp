import Foundation
@testable import MVNetwork

enum TestError: Error, Equatable {
    case noStub, fetchFailed, configFailed
}

final class MockAPIClient: APIClientProtocol {
    
    var fetchDataResult: Result<Data, Error> = .failure(TestError.noStub)
    var sendResult: Result<Decodable, Error> = .failure(TestError.noStub)
    
    var sendCount = 0
    var fetchDataCount = 0
    
    func send<T>(
        _ endpoint: Endpoint,
        type: T.Type,
        baseURL: URL
    ) async throws -> T where T : Decodable {
        sendCount += 1
        switch sendResult {
            case .success(let result):
                return result as! T
            case .failure(let err):
                throw err
        }
    }
    
    func fetchData(
        _ endpoint: Endpoint,
        baseURL: URL
    ) async throws -> Data {
        fetchDataCount += 1
        switch fetchDataResult {
            case .success(let data):
                return data
            case .failure(let err):
                throw err
        }
    }
}

import Foundation
@testable import PatternMVVM

final class APISessionMock: APISessionContract {
    let mockResponse: ((any APIRequest) -> Result<Data, any Error>)
    
    init(mockResponse: @escaping (any APIRequest) -> Result<Data, any Error>) {
        self.mockResponse = mockResponse
    }
    
    func request<Request: APIRequest>(_ apiRequest: Request, completion: @escaping (Result<Data, any Error>) -> Void) {
        completion(mockResponse(apiRequest))
    }
}

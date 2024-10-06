import Foundation
@testable import PatternMVVM
import XCTest

private final class DummyDataSource: SessionDataSourceContract {
    private(set) var session: Data?
    
    func storeSession(_ session: Data) {
        self.session = session
    }
    
    func getSession() -> Data? { nil }
}

final class LoginUseCaseTests: XCTestCase {
    func testSuccessStoresToken() {
        let dataSource = DummyDataSource()
        let sut = LoginUseCase(dataSource)
        let expectation = self.expectation(description: "TestSuccessToken")
        let data = Data("hello-world".utf8)
        APISession.shared = APISessionMock { request in
            return .success(data)
        }
        sut.execute(username: "potato", password: "password") { result in
            guard case .success = result else {
                return
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5)
        XCTAssertEqual(dataSource.session, data)
    }
    
    func testFailureDoesNotStoreToken() {
        let dataSource = DummyDataSource()
        let sut = LoginUseCase(dataSource)
        let expectation = self.expectation(description: "TestFailure")
        APISession.shared = APISessionMock { request in
            return .failure(APIErrorResponse.unknown(""))
        }
        sut.execute(username: "potato", password: "password") { result in
            guard case .failure = result else {
                return
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5)
        XCTAssertNil(dataSource.session)
    }
}

import Foundation
@testable import PatternMVVM
import XCTest

final class GetHeroDetailUseCaseTests: XCTestCase {
    func testSuccess() {
        guard let mockURL = Bundle(for: type(of: self)).url(forResource: "HeroListMock", withExtension: "json"),
              let data = try? Data(contentsOf: mockURL) else {
            return XCTFail("Mock can't be found")
        }
        let sut = GetHeroesUseCase()
        let expectation = self.expectation(description: "TestSuccessToken")
        
        APISession.shared = APISessionMock { _ in .success(data) }
        sut.execute { result in
            guard case .success(let heroes) = result else {
                return
            }
            XCTAssertEqual(heroes.count, 23)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5)
    }
    
    func testFailure() {
        let sut = GetHeroesUseCase()
        let expectation = self.expectation(description: "TestFailure")
        APISession.shared = APISessionMock { request in
            return .failure(APIErrorResponse.unknown(""))
        }
        sut.execute { result in
            guard case .failure = result else {
                return
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5)
    }
}

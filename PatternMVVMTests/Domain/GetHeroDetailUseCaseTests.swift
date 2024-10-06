import Foundation
@testable import PatternMVVM
import XCTest

final class GetHeroesUseCaseTests: XCTestCase {
    func testSuccess() {
        guard let mockURL = Bundle(for: type(of: self)).url(forResource: "GetHeroDetailMock", withExtension: "json"),
              let data = try? Data(contentsOf: mockURL) else {
            return XCTFail("Mock can't be found")
        }
        let sut = GetHeroDetailUseCase()
        let expectation = self.expectation(description: "TestSuccessToken")
        
        APISession.shared = APISessionMock { _ in .success(data) }
        sut.execute(name: "Goku")  { result in
            guard case .success(let hero) = result else {
                return
            }
            XCTAssertEqual(hero.name, "Maestro Roshi")
            XCTAssertEqual(hero.identifier, "14BB8E98-6586-4EA7-B4D7-35D6A63F5AA3")
            XCTAssertEqual(hero.photo, "https://cdn.alfabetajuega.com/alfabetajuega/2020/06/Roshi.jpg?width=300")
            XCTAssertFalse(hero.favorite)
            XCTAssertFalse(hero.description.isEmpty)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5)
    }
    
    func testFailure() {
        let sut = GetHeroDetailUseCase()
        let expectation = self.expectation(description: "TestFailure")
        APISession.shared = APISessionMock { request in
            return .failure(APIErrorResponse.unknown(""))
        }
        sut.execute(name: "Goku") { result in
            guard case .failure = result else {
                return
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5)
    }
}

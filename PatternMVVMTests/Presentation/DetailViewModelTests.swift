@testable import PatternMVVM
import XCTest

private final class SuccessGetHeroDetailUseCaseMock: GetHeroDetailUseCaseContract {
    func execute(name: String, completion: @escaping (Result<HeroModel, any Error>) -> Void) {
        XCTAssertEqual("Goku", name)
        let hero = HeroModel(identifier: "14BB8E98-6586-4EA7-B4D7-35D6A63F5AA3",
                             name: "Maestro Roshi",
                             description: "Lorem ipsum dolor est",
                             photo: "https://cdn.alfabetajuega.com/alfabetajuega/2020/06/Roshi.jpg?width=300",
                             favorite: false)
        completion(.success(hero))
    }
}

private final class FailGetHeroDetailUseCaseMock: GetHeroDetailUseCaseContract {
    func execute(name: String, completion: @escaping (Result<HeroModel, any Error>) -> Void) {
        XCTAssertEqual("Goku", name)
        completion(.failure(APIErrorResponse.unknown("undetermined")))
    }
}

final class DetailViewModelTests: XCTestCase {
    func testSuccessScenario() {
        let expectation = self.expectation(description: "success scenario expects heroes")
        let useCaseMock = SuccessGetHeroDetailUseCaseMock()
        let sut = DetailViewModel(heroName: "Goku", useCase: useCaseMock)
        
        sut.onStateChanged.bind { state in
            if case .idle = state {
                expectation.fulfill()
            }
        }
        
        sut.load()
        waitForExpectations(timeout: 5)
        XCTAssertNotNil(sut.hero)
    }
    
    func testFailureScenario() {
        let expectation = self.expectation(description: "success scenario expects heroes")
        let useCaseMock = FailGetHeroDetailUseCaseMock()
        let sut = DetailViewModel(heroName: "Goku", useCase: useCaseMock)
        
        sut.onStateChanged.bind { state in
            if case .error = state {
                expectation.fulfill()
            }
        }
        
        sut.load()
        waitForExpectations(timeout: 5)
        XCTAssertNil(sut.hero)
    }
}

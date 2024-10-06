@testable import PatternMVVM
import XCTest

private final class SuccessGetHeroesUseCaseMock: GetHeroesUseCaseContract {
    func execute(completion: @escaping (Result<[HeroModel], any Error>) -> Void) {
        completion(.success([HeroModel(identifier: "1234", name: "potato", description: "", photo: "", favorite: false)]))
    }
}

private final class FailGetHeroesUseCaseMock: GetHeroesUseCaseContract {
    func execute(completion: @escaping (Result<[HeroModel], any Error>) -> Void) {
        completion(.failure(APIErrorResponse.network("")))
    }
}

final class HeroesListViewModelTests: XCTestCase {
    func testSuccessScenario() {
        let expectation = self.expectation(description: "success scenario expects heroes")
        let useCaseMock = SuccessGetHeroesUseCaseMock()
        let sut = HeroesListViewModel(getHeroesUseCase: useCaseMock)
        
        sut.onStateChanged.bind { state in
            if case .idle = state {
                expectation.fulfill()
            }
        }
        
        sut.load()
        waitForExpectations(timeout: 5)
        XCTAssertEqual(sut.heroes.count, 1)
    }
    
    func testFailureScenario() {
        let expectation = self.expectation(description: "success scenario expects heroes")
        let useCaseMock = FailGetHeroesUseCaseMock()
        let sut = HeroesListViewModel(getHeroesUseCase: useCaseMock)
        
        sut.onStateChanged.bind { state in
            if case .error = state {
                expectation.fulfill()
            }
        }
        
        sut.load()
        waitForExpectations(timeout: 5)
        XCTAssertTrue(sut.heroes.isEmpty)
    }
}

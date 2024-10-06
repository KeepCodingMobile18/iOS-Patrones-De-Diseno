@testable import PatternMVVM

import XCTest

private final class SuccessUseCaseMock: LoginUseCaseContract {
    func execute(username: String, password: String, completion: @escaping (Result<Void, any Error>) -> Void) {
        XCTAssertEqual(username, "sweet@potato.com")
        XCTAssertEqual(password, "1234")
        completion(.success(()))
    }
}

private final class FailureUseCaseMock: LoginUseCaseContract {
    func execute(username: String, password: String, completion: @escaping (Result<Void, any Error>) -> Void) {
        XCTAssertEqual(username, "sweet@potato.com")
        XCTAssertEqual(password, "1234")
        completion(.failure(NSError(domain: "patternMVVM", code: 3)))
    }
}

private final class NoReachedUseCaseMock: LoginUseCaseContract {
    func execute(username: String, password: String, completion: @escaping (Result<Void, any Error>) -> Void) {
        XCTFail("NoRealUseCaseMock should not be called")
    }
}

final class LoginViewModelTests: XCTestCase {
    func testMissingUsernameAndPasswordSwitchesToErrorState() {
        let expectation = self.expectation(description: "success scenario expects fail")
        let useCaseMock = NoReachedUseCaseMock()
        let sut = LoginViewModel(loginUseCase: useCaseMock)
        // We bind the state
        sut.onStateChanged.bind { newState in
            if case .error = newState {
                expectation.fulfill()
            }
        }
        sut.signIn(username: nil, password: nil)
        waitForExpectations(timeout: 5)
    }
    
    func testPasswordSwitchesToErrorState() {
        let expectation = self.expectation(description: "success scenario expects fail")
        let useCaseMock = NoReachedUseCaseMock()
        let sut = LoginViewModel(loginUseCase: useCaseMock)
        // We bind the state
        sut.onStateChanged.bind { newState in
            if case .error = newState {
                expectation.fulfill()
            }
        }
        sut.signIn(username: "sweet@potato.com", password: nil)
        waitForExpectations(timeout: 5)
    }
    
    func testInvalidUsernameSwitchesToErrorState() {
        let expectation = self.expectation(description: "success scenario expects fail")
        let useCaseMock = NoReachedUseCaseMock()
        let sut = LoginViewModel(loginUseCase: useCaseMock)
        // We bind the state
        sut.onStateChanged.bind { newState in
            if case .error = newState {
                expectation.fulfill()
            }
        }
        sut.signIn(username: "sweetpotato.com", password: "1")
        waitForExpectations(timeout: 5)
    }
    
    func testInvalidPasswordSwitchesToErrorState() {
        let expectation = self.expectation(description: "success scenario expects fail")
        let useCaseMock = NoReachedUseCaseMock()
        let sut = LoginViewModel(loginUseCase: useCaseMock)
        // We bind the state
        sut.onStateChanged.bind { newState in
            if case .error = newState {
                expectation.fulfill()
            }
        }
        sut.signIn(username: "sweet@potato.com", password: "1")
        waitForExpectations(timeout: 5)
    }
    
    func testTransitionsToLoadingStateWhenSigningIn() {
        let loginResponseExpectation = self.expectation(description: "success scenario expects success")
        let loadingExpectation = self.expectation(description: "success scenario expects loading")
        let useCaseMock = SuccessUseCaseMock()
        let sut = LoginViewModel(loginUseCase: useCaseMock)
        sut.onStateChanged.bind { newState in
            if case .loading = newState {
                loadingExpectation.fulfill()
            } else if case .success = newState {
                loginResponseExpectation.fulfill()
            }
        }
        
        sut.signIn(username: "sweet@potato.com", password: "1234")
        waitForExpectations(timeout: 5)
    }
    
    func testTransitionsToLoadingAndFailStateWhenSigningIn() {
        let loginResponseExpectation = self.expectation(description: "success scenario expects fail")
        let loadingExpectation = self.expectation(description: "success scenario expects loading")
        let useCaseMock = FailureUseCaseMock()
        let sut = LoginViewModel(loginUseCase: useCaseMock)
        sut.onStateChanged.bind { newState in
            if case .loading = newState {
                loadingExpectation.fulfill()
            } else if case .error = newState {
                loginResponseExpectation.fulfill()
            }
        }
    
        sut.signIn(username: "sweet@potato.com", password: "1234")
        waitForExpectations(timeout: 5)
    }
}

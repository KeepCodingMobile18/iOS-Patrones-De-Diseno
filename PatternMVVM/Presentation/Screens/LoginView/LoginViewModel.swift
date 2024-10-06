import Foundation

/// Represents the state of the Login screen
enum LoginState {
    /// Represents the initial state
    case initial
    /// Represents the scenario when an error might happen
    case error(reason: String)
    /// Represents the scenario when the view is loading
    case loading
    /// Represents the scenario when the login was a success
    case success
}

final class LoginViewModel {
    // Variable to bind on
    let onStateChanged = Binding<LoginState>(initialValue: .initial)
    private let loginUseCase: LoginUseCaseContract
    
    init(loginUseCase: LoginUseCaseContract = LoginUseCase()) {
        self.loginUseCase = loginUseCase
    }
    
    func signIn(username: String?, password: String?) {
        guard let username, isValidUsername(username) else {
            return onStateChanged.update(newValue: .error(reason: "Invalid username. Must be an email"))
        }
        guard let password, isValidPassword(password) else {
            return onStateChanged.update(newValue: .error(reason: "Invalid password. Must be at least 4 characters"))
        }
        onStateChanged.update(newValue: .loading)
        loginUseCase.execute(username: username, password: password) { [weak self] result in
            switch result {
            case .success:
                self?.onStateChanged.update(newValue: .success)
            case let .failure(error):
                self?.onStateChanged.update(newValue: .error(reason: error.localizedDescription))
            }
        }
    }
    
    // MARK: - Validate functions
    private func isValidUsername(_ username: String) -> Bool {
        username.contains("@") && !username.isEmpty
    }
    
    private func isValidPassword(_ password: String) -> Bool {
        password.count >= 4
    }
}

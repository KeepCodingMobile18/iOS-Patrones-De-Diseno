import Foundation

final class LoginInteractor: LoginInteractorInputContract {
    weak var output: LoginInteractorOutputContract?
    
    private let dataSource: SessionDataSourceContract
    
    init(dataSource: SessionDataSourceContract) {
        self.dataSource = dataSource
    }
    
    func onLoginButtonTapped(_ credentials: Credentials) {
        guard validateUsername(credentials.username) else {
            output?.onFailedLoad("Invalid Username")
            return
        }
        guard validatePassword(credentials.password) else {
            output?.onFailedLoad("Invalid Password")
            return
        }
        LoginAPIRequest(credentials: credentials)
            .perform { result in
                DispatchQueue.main.async { [weak self] in
                    switch result {
                    case .success(let token):
                        self?.dataSource.storeSession(token)
                        self?.output?.onSuccessfulLoad()
                    case .failure:
                        self?.output?.onFailedLoad("Network Error")
                    }
                }
            }
    }
    
    
    private func validateUsername(_ username: String) -> Bool {
        username.contains("@") && !username.isEmpty
    }
    
    private func validatePassword(_ password: String) -> Bool {
        password.count >= 4
    }
}

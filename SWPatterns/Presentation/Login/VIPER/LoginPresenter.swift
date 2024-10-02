import Foundation

final class LoginPresenter: LoginPresenterContract, LoginInteractorOutputContract {
    weak var ui: LoginViewContract?
    private let loginInteractor: LoginInteractorInputContract
    private let router: LoginRouterContract
    
    init(loginInteractor: LoginInteractorInputContract, router: LoginRouterContract) {
        self.loginInteractor = loginInteractor
        self.router = router
    }
    
    
    func onLoginButtonTapped(_ username: String?, _ password: String?) {
        ui?.showLoading(true)
        ui?.showError(nil)
        loginInteractor.onLoginButtonTapped(Credentials(username: username ?? "",
                                                        password: password ?? ""))
    }
    
    func onSuccessfulLoad() {
        ui?.showLoading(false)
        router.showHomeView()
    }
    
    func onFailedLoad(_ reason: String) {
        ui?.showLoading(false)
        ui?.showError(reason)
    }
}

import UIKit

protocol LoginPresenterContract: AnyObject {
    func onLoginButtonTapped(_ username: String?, _ password: String?)
}

protocol LoginViewContract: AnyObject {
    func showLoading(_ isHidden: Bool)
    func showError(_ reason: String?)
}

protocol LoginInteractorInputContract: AnyObject {
    func onLoginButtonTapped(_ credentials: Credentials)
}

protocol LoginInteractorOutputContract: AnyObject {
    func onSuccessfulLoad()
    func onFailedLoad(_ reason: String)
}

protocol LoginRouterContract: AnyObject {
    func showHomeView()
}

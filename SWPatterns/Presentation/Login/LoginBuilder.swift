import UIKit

final class LoginBuilder {
// Using MVVM
//    func build() -> UIViewController {
//        let loginUseCase = LoginUseCase()
//        let viewModel = LoginViewModel(useCase: loginUseCase)
//        let viewController = LoginViewController(viewModel: viewModel)
//        viewController.modalPresentationStyle = .fullScreen
//        return viewController
//    }
    
    func build() -> UIViewController {
        let dataSource = SessionDataSource()
        let router = LoginRouter()
        let loginInteractor = LoginInteractor(dataSource: dataSource)
        let presenter = LoginPresenter(loginInteractor: loginInteractor, router: router)
        let viewController = LoginVIPERViewController(presenter: presenter)
        
        loginInteractor.output = presenter
        presenter.ui = viewController
        router.controller = viewController
        
        viewController.modalPresentationStyle = .fullScreen
        return viewController
    }
}

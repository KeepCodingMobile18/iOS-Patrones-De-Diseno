import UIKit

final class HomeBuilder {
    func build() -> UIViewController {
        let interactor = HomeInteractor()
        let router = HomeRouter()
        let presenter = HomePresenter(router: router, interactor: interactor)
        let viewController = HomeViewController(presenter: presenter)
        
        interactor.output = presenter
        presenter.ui = viewController
        router.controller = viewController
        
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .fullScreen
        
        return navigationController
    }
}

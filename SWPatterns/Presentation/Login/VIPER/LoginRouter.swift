import UIKit

final class LoginRouter: LoginRouterContract {
    weak var controller: UIViewController?
    
    func showHomeView() {
        controller?.present(HeroesListBuilder().build(), animated: true)
    }
}

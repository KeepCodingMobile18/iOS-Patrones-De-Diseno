import UIKit

final class LoginRouter: LoginRouterContract {
    weak var controller: UIViewController?
    
    func showHomeView() {
        controller?.present(HomeBuilder().build(), animated: true)
    }
}

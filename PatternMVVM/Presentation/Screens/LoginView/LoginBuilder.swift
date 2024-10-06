import UIKit

final class LoginBuilder {
    func build() -> UIViewController {
        let viewModel = LoginViewModel()
        let controller = LoginViewController(viewModel: viewModel)
        controller.modalPresentationStyle = .fullScreen
        return controller
    }
}

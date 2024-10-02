import UIKit

final class LoginVIPERViewController: UIViewController, LoginViewContract {
    @IBOutlet private weak var usernameField: UITextField!
    @IBOutlet private weak var passwordField: UITextField!
    @IBOutlet private weak var errorLabel: UILabel!
    @IBOutlet private weak var spinner: UIActivityIndicatorView!
    @IBOutlet private weak var loginButton: UIButton!
    
    private let presenter: LoginPresenterContract
    
    init(presenter: LoginPresenterContract) {
        self.presenter = presenter
        super.init(nibName: "LoginVIPERView", bundle: Bundle(for: type(of: self)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func onLoginTapped(_ sender: Any) {
        presenter.onLoginButtonTapped(usernameField.text,
                                      passwordField.text)
    }
    
    func showLoading(_ isHidden: Bool) {
        if isHidden {
            spinner.stopAnimating()
            loginButton.isEnabled = true
        } else {
            spinner.startAnimating()
            loginButton.isEnabled = false
        }
    }
    
    func showError(_ reason: String?) {
        loginButton.isEnabled = true
        errorLabel.text = reason
        errorLabel.isHidden = reason == nil
    }
}

import UIKit

final class LoginViewController: UIViewController {
    @IBOutlet private weak var usernameForm: UITextField!
    @IBOutlet private weak var signInButton: UIButton!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var passwordForm: UITextField!
    @IBOutlet weak var errorText: UILabel!

    private let viewModel: LoginViewModel
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "LoginView", bundle: Bundle(for: type(of: self)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("Please use init()")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    // MARK: - Actions
    @IBAction
    func onSignInTapped(_ sender: Any) {
        viewModel.signIn(username: usernameForm.text, password: passwordForm.text)
    }
    
    // MARK: - State operations
    private func bind() {
        viewModel.onStateChanged.bind { [weak self] newState in
            switch newState {
            case .initial:
                self?.setInitialState()
            case .loading:
                self?.setLoadingState()
            case let .error(reason):
                self?.setErrorState(reason)
            case .success:
                self?.navigateToHome()
            }
        }
    }
    
    private func setInitialState() {
        signInButton.isHidden = false
        activityIndicator.stopAnimating()
        errorText.isHidden = true
    }
    
    private func setLoadingState() {
        signInButton.isHidden = true
        activityIndicator.startAnimating()
        errorText.isHidden = true
    }
    
    private func setErrorState(_ reason: String) {
        signInButton.isHidden = false
        activityIndicator.stopAnimating()
        errorText.isHidden = false
        errorText.text = reason
    }
    
    // MARK: - Navigations
    private func navigateToHome() {
        present(HeroesListBuilder().build(), animated: true)
    }
}

#Preview {
    LoginBuilder().build()
}

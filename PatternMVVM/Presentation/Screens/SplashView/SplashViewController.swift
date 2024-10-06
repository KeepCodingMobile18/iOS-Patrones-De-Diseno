import UIKit

final class SplashViewController: UIViewController {
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    private let viewModel: SplashViewModel
    
    init(viewModel: SplashViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "SplashView", bundle: Bundle(for: type(of: self)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("Please use init()")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        viewModel.load()
    }
    
    // MARK: - State operations
    private func bind() {
        viewModel.onStateChanged.bind { [weak self] newState in
            switch newState {
            case .initial:
                self?.setAnimation(false)
            case .loading:
                print("I need to work!")
                self?.setAnimation(true)
            case .error:
                print("Hey!! I have failed!!!!")
                self?.setAnimation(false)
            case .ready:
                print("Nice ☺️")
                self?.setAnimation(false)
                self?.present(LoginBuilder().build(), animated: true)
            }
        }
    }
    
    // MARK: - UI operations
    private func setAnimation(_ animating: Bool) {
        switch activityIndicator.isAnimating {
        case true where !animating:
            activityIndicator.stopAnimating()
        case false where animating:
            activityIndicator.startAnimating()
        default: break
        }
    }
}

#Preview {
    SplashBuilder().build()
}

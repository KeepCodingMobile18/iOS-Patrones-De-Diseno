import UIKit

final class DetailViewController: UIViewController {
    @IBOutlet private weak var heroPhoto: AsyncImage!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var errorContainer: UIStackView!
    @IBOutlet private weak var spinner: UIActivityIndicatorView!
    @IBOutlet private weak var errorLabel: UILabel!
    @IBOutlet private weak var scrollView: UIScrollView!
    
    private let viewModel: DetailViewModel
    
    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "DetailView", bundle: Bundle(for: type(of: self)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.onStateChanged.bind { [weak self] state in
            switch state {
            case .idle:
                self?.onIdleState()
            case .error(let reason):
                self?.onErrorState(reason: reason)
            case .initial, .loading:
                self?.onLoadingState()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.load()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        heroPhoto.layer.masksToBounds = true
        heroPhoto.layer.cornerRadius = heroPhoto.bounds.height / 2
    }
    
    @IBAction func onRetryTapped(_ sender: Any) {
        viewModel.load()
    }
    
    // MARK: - State management
    private func onLoadingState() {
        scrollView.isHidden = true
        heroPhoto.isHidden = true
        errorContainer.isHidden = true
        spinner.startAnimating()
    }
    
    private func onIdleState() {
        titleLabel.text = viewModel.hero?.name
        descriptionLabel.text = viewModel.hero?.description
        if let photo = viewModel.hero?.photo {
            heroPhoto.setImage(photo)
        }
        scrollView.isHidden = false
        heroPhoto.isHidden = false
        errorContainer.isHidden = true
        spinner.stopAnimating()
    }
    
    private func onErrorState(reason: String) {
        errorLabel.text = reason
        scrollView.isHidden = true
        heroPhoto.isHidden = true
        errorContainer.isHidden = false
        spinner.stopAnimating()
    }
}

#Preview {
    DetailBuilder(name: "Goku")
        .build()
}

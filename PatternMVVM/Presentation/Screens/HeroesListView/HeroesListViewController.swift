import UIKit

final class HeroesListViewController: UIViewController {
    @IBOutlet weak var errorView: UIStackView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var tableView: UITableView!
    private let viewModel: HeroesListViewModel
    
    init(viewModel: HeroesListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "HeroesListView", bundle: Bundle(for: type(of: self)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("Please use init()")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "HeroCell", bundle: .main), 
                           forCellReuseIdentifier: HeroCell.reuseIdentifier)
        bind()
        viewModel.load()
        title = "Heroes"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    @IBAction func onRetryTapped(_ sender: Any) {
        viewModel.load()
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
            case .idle:
                self?.setIdleState()
            }
        }
    }
    
    private func setInitialState() {
        activityIndicator.stopAnimating()
        errorView.isHidden = true
        tableView.reloadData()
    }
    
    private func setLoadingState() {
        activityIndicator.startAnimating()
        errorView.isHidden = true
        tableView.reloadData()
    }
    
    private func setErrorState(_ reason: String) {
        activityIndicator.stopAnimating()
        errorView.isHidden = false
        errorLabel.text = reason
        tableView.reloadData()
    }
    
    private func setIdleState() {
        activityIndicator.stopAnimating()
        errorView.isHidden = true
        tableView.reloadData()
    }
}

extension HeroesListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.heroes.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        90
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HeroCell.reuseIdentifier, for: indexPath)
        if let cell = cell as? HeroCell, viewModel.heroes.count >= indexPath.row {
            let hero = viewModel.heroes[indexPath.row]
            cell.populate(title: hero.name, avatar: hero.photo)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if viewModel.heroes.count >= indexPath.row {
            let hero = viewModel.heroes[indexPath.row]
            navigationController?.pushViewController(DetailBuilder(name: hero.name).build(), animated: true)
        }
    }
}

#Preview {
    HeroesListBuilder().build()
}

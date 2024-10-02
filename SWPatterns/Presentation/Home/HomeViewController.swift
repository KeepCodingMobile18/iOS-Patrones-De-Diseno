import UIKit

final class HomeViewController: UIViewController,
                                HomeViewContract,
                                UITableViewDataSource,
                                UITableViewDelegate {
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var errorLabel: UILabel!
    @IBOutlet private weak var errorContainer: UIStackView!
    @IBOutlet private weak var spinner: UIActivityIndicatorView!
    
    private let presenter: HomePresenterContract
    
    init(presenter: HomePresenterContract) {
        self.presenter = presenter
        super.init(nibName: "HomeView", bundle: Bundle(for: type(of: self)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.loadData()
        tableView.register(HeroTableViewCell.nib, forCellReuseIdentifier: HeroTableViewCell.reuseIdentifier)
    }
    
    @IBAction func onRetryTapped(_ sender: Any) {
        presenter.loadData()
    }
    
    func showLoading(_ isHidden: Bool) {
        tableView.isHidden = !isHidden
        errorContainer.isHidden = true
        if isHidden {
            spinner.stopAnimating()
        } else {
            spinner.startAnimating()
        }
    }
    
    func showError(_ reason: String?) {
        errorContainer.isHidden = false
        errorLabel.text = reason
    }
    
    func showSuccess() {
        tableView.isHidden = false
        errorContainer.isHidden = true
        tableView.reloadData()
    }
    
    // MARK: UITable functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.heroes.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.onCellClicked(indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        90
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HeroTableViewCell.reuseIdentifier, for: indexPath)
        if let cell = cell as? HeroTableViewCell {
            let hero = presenter.heroes[indexPath.row]
            cell.setAvatar(hero.photo)
            cell.setHeroName(hero.name)
        }
        return cell
    }
}

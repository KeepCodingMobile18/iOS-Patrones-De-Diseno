final class DetailBuilder {
    private let name: String
    
    init(name: String) {
        self.name = name
    }
    
    func build() -> DetailViewController {
        DetailViewController(viewModel: DetailViewModel(heroName: name))
    }
}

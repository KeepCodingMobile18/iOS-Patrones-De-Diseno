import Foundation

final class HomePresenter: HomePresenterContract, HomeInteractorOutputContract {
    weak var ui: HomeViewContract?
    private let router: HomeRouterContract
    private let interactor: HomeInteractorInputContract
    
    private(set) var heroes: [Hero] = []
    
    init(router: HomeRouterContract, interactor: HomeInteractorInputContract) {
        self.router = router
        self.interactor = interactor
    }
    
    func loadData() {
        ui?.showLoading(true)
        interactor.loadHeroes()
    }
    
    func onCellClicked(_ indexPath: IndexPath) {
        let hero = heroes[indexPath.row]
        router.showDetail(hero.name)
    }
    
    func onSuccesfulLoad(_ heroes: [Hero]) {
        self.heroes = heroes
        ui?.showLoading(false)
        ui?.showError(nil)
        ui?.showSuccess()
    }
    
    func onFailedLoad(_ reason: String) {
        ui?.showLoading(false)
        ui?.showError(reason)
    }
}

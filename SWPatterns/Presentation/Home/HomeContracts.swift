import Foundation

protocol HomePresenterContract: AnyObject {
    var heroes: [Hero] { get }
    
    func loadData()
    func onCellClicked(_ indexPath: IndexPath)
}

protocol HomeViewContract: AnyObject {
    func showLoading(_ isHidden: Bool)
    func showError(_ reason: String?)
    func showSuccess()
}

protocol HomeInteractorInputContract: AnyObject {
    func loadHeroes()
}

protocol HomeInteractorOutputContract: AnyObject {
    func onSuccesfulLoad(_ heroes: [Hero])
    func onFailedLoad(_ reason: String)
}

protocol HomeRouterContract: AnyObject {
    func showDetail(_ name: String)
}

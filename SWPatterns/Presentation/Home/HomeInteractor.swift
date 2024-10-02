import Foundation

final class HomeInteractor: HomeInteractorInputContract {
    weak var output: HomeInteractorOutputContract?
    
    func loadHeroes() {
        GetHeroesAPIRequest(name: nil)
            .perform { result in
                DispatchQueue.main.async { [weak self] in
                    do {
                        try self?.output?.onSuccesfulLoad(result.get())
                    } catch {
                        self?.output?.onFailedLoad("Something has happened")
                    }
                }
            }
    }
}

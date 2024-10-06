import Foundation

/// Represents the state of the Heroes List screen
enum HeroesListState {
    /// Represents the initial state
    case initial
    /// Represents the scenario when an error might happen
    case error(reason: String)
    /// Represents the scenario when the view is loading
    case loading
    /// Represents the scenario when the request was a success
    case idle
}

final class HeroesListViewModel {
    // Variable to bind on
    let onStateChanged = Binding<HeroesListState>(initialValue: .initial)
    private let getHeroesUseCase: GetHeroesUseCaseContract
    private(set) var heroes: [HeroModel] = []
    
    init(getHeroesUseCase: GetHeroesUseCaseContract = GetHeroesUseCase()) {
        self.getHeroesUseCase = getHeroesUseCase
    }
    
    func load() {
        onStateChanged.update(newValue: .loading)
        getHeroesUseCase
            .execute { [weak self] result in
                do {
                    self?.heroes = try result.get()
                    self?.onStateChanged.update(newValue: .idle)
                } catch {
                    self?.onStateChanged.update(newValue: .error(reason: error.localizedDescription))
                }
            }
    }
}

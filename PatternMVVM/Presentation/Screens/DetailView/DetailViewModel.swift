import Foundation

/// Represents the state of the Heroes List screen
enum DetailState {
    /// Represents the initial state
    case initial
    /// Represents the scenario when an error might happen
    case error(reason: String)
    /// Represents the scenario when the view is loading
    case loading
    /// Represents the scenario when the request was a success
    case idle
}

final class DetailViewModel {
    let onStateChanged = Binding<DetailState>(initialValue: .initial)
    
    // Private data
    private let heroName: String
    private let useCase: GetHeroDetailUseCaseContract
    private(set) var hero: HeroModel?
    
    init(heroName: String, useCase: GetHeroDetailUseCaseContract = GetHeroDetailUseCase()) {
        self.heroName = heroName
        self.useCase = useCase
    }
    
    func load() {
        onStateChanged.update(newValue: .loading)
        useCase.execute(name: heroName) { [weak self] result in
            do {
                self?.hero = try result.get()
                self?.onStateChanged.update(newValue: .idle)
            } catch {
                self?.onStateChanged.update(newValue: .error(reason: error.localizedDescription))
            }
        }
    }
}

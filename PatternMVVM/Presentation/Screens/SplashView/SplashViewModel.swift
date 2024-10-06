import Foundation

/// Represents the state of the Splash screen
enum SplashState {
    /// Represents the initial state
    case initial
    /// Represents the state when the view is loading
    case loading
    /// Represents the state when the view has failed loading
    case error
    /// Represents the state when the view has successfully loaded
    case ready
}

final class SplashViewModel {
    // Variable to bind on
    let onStateChanged = Binding<SplashState>(initialValue: .initial)
    
    func load() {
        onStateChanged.update(newValue: .loading)
        DispatchQueue.global().asyncAfter(deadline: .now() + 3) { [weak self] in
            self?.onStateChanged.update(newValue: .ready)
        }
    }
}

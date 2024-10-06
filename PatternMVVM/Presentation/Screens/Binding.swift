import Foundation

/// This class will help us to isolate the switch to the main thread across all of our operations and
/// unify the way we create binders
class Binding<T> {
    typealias Completion = (T) -> Void
    
    private var value: T {
        didSet {
            // Ensure we're on main thread
            if Thread.current.isMainThread {
                completion?(value)
            } else {
                DispatchQueue.main.async { [weak self] in
                    guard let self else {
                        return
                    }
                    self.completion?(self.value)
                }
            }
        }
    }
    
    private var completion: Completion? {
        didSet {
            completion?(value) // If we configure the completion for the very first time we're able to get the current value
        }
    }
    
    /// Initializes a new binding instance with an initial value
    /// - Parameter initialValue: Initial value of the state
    init(initialValue: T) {
        value = initialValue
    }

    /// Binds a function to be invoked on the main thread every time the value is updated
    /// - Parameter completion: Function to be invoked once value is updated
    func bind(completion: @escaping Completion) {
        self.completion = completion
    }
    
    /// Updates the value
    /// - Parameter newValue: New value to be configured
    func update(newValue: T) {
        value = newValue
    }
}

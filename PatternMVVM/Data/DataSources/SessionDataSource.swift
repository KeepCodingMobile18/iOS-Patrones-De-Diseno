import Foundation

protocol SessionDataSourceContract {
    /// Stores the session for future usages
    /// - Parameter session: Data to identify the session
    func storeSession(_ session: Data)
    
    /// Obtains the session information
    /// - Returns: Data to identify the session
    func getSession() -> Data?
}

final class SessionDataSource: SessionDataSourceContract {
    private static var token: Data?
    
    func storeSession(_ session: Data) {
        Self.token = session
    }
    
    func getSession() -> Data? {
        Self.token
    }
}

import Foundation

protocol LoginUseCaseContract {
    func execute(username: String, password: String, completion: @escaping (Result<Void, Error>) -> Void)
}

final class LoginUseCase: LoginUseCaseContract {
    private let dataSource: SessionDataSourceContract
    
    init(_ dataSource: SessionDataSourceContract = SessionDataSource()) {
        self.dataSource = dataSource
    }
    
    func execute(username: String, password: String, completion: @escaping (Result<Void, any Error>) -> Void) {
        LoginAPIRequest(username: username, password: password)
            .perform { [weak self] result in
                do {
                    try self?.dataSource.storeSession(result.get())
                    completion(.success(()))
                } catch {
                    completion(.failure(error))
                }
            }
    }
}


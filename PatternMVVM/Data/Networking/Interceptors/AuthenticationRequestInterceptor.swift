import Foundation

final class AuthenticationRequestInterceptor: APIRequestInterceptor {
    private let dataSource: SessionDataSourceContract
    
    init(dataSource: SessionDataSourceContract = SessionDataSource()) {
        self.dataSource = dataSource
    }
    
    func intercept(_ request: inout URLRequest) {
        guard let session = dataSource.getSession() else {
            return
        }
        request.setValue("Bearer \(String(decoding: session, as: UTF8.self))", forHTTPHeaderField: "Authorization")
    }
}

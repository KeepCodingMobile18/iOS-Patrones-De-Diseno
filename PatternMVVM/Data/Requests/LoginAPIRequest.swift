import Foundation

struct LoginAPIRequest: APIRequest {
    typealias Response = Data
    
    let headers: [String: String]
    let path = "/api/auth/login"
    let method: Methods = .POST
    
    init(username: String, password: String) {
        let loginData = Data(String(format: "%@:%@", username, password).utf8)
        let base64String = loginData.base64EncodedString()
        headers = ["Authorization": "Basic \(base64String)"]
    }
}

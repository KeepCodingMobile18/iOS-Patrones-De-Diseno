import Foundation

protocol APIInterceptor { /* Common protocol to operate with in the future */ }

protocol APIRequestInterceptor: APIInterceptor {
    func intercept(_ request: inout URLRequest)
}


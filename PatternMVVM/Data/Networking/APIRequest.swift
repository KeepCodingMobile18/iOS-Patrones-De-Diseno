import Foundation

enum Methods: String, Codable {
    case GET, POST, UPDATE, DELETE, PATCH, PUT // And if we have more we can add them here
}

protocol APIRequest {
    associatedtype Response: Decodable
    
    typealias APIRequestResponse = Result<Response, APIErrorResponse>
    typealias APIRequestCompletion = (APIRequestResponse) -> Void
    
    var host: String { get }
    var method: Methods { get }
    var body: Encodable? { get }
    var path: String { get }
    var headers: [String: String] { get }
    var queryParameters: [String: String] { get }
}

extension APIRequest {
    var host: String { "dragonball.keepcoding.education" }
    var queryParameters: [String: String] { [:] }
    var headers: [String: String] { [:] }
    var body: Encodable? { nil }
    
    func getRequest() throws -> URLRequest {
        var components = URLComponents()
        components.scheme = "https"
        components.host = host
        components.path = path
        if !queryParameters.isEmpty {
            components.queryItems = queryParameters.map { URLQueryItem(name: $0, value: $1) }
        }
        
        guard let finalUrl = components.url else {
            throw APIErrorResponse.malformedUrl(path)
        }
        
        var request = URLRequest(url: finalUrl)
        request.httpMethod = method.rawValue
        if let body, method != .GET {
            request.httpBody = try? JSONEncoder().encode(body)
        }
        // We keep the default headers plus the headers from our request. If it declares the default ones,
        // they will be used instead of the default ones
        request.allHTTPHeaderFields = ["Accept": "application/json", "Content-Type": "application/json"].merging(headers) { $1 }
        request.timeoutInterval = 30
        return request
    }
    
    func perform(session: APISessionContract = APISession.shared, completion: @escaping APIRequestCompletion) {
        session.request(self) { result in
            do {
                let data = try result.get()
                if Response.self == Void.self {
                    return completion(.success(() as! Response))
                } else if Response.self == Data.self {
                    return completion(.success(data as! Response))
                }
                return try completion(.success(JSONDecoder().decode(Response.self, from: data)))
            } catch let error as APIErrorResponse {
                completion(.failure(error))
            } catch is DecodingError {
                completion(.failure(APIErrorResponse.parseData(path)))
            } catch {
                completion(.failure(APIErrorResponse.unknown(path)))
            }
        }
    }
}

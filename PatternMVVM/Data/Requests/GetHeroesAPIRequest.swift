import Foundation

struct GetHeroesAPIRequest: APIRequest {
    typealias Response = [HeroModel]
    
    let path = "/api/heros/all"
    let method: Methods = .POST
    let body: (any Encodable)?

    init(name: String?) {
        body = name.map { RequestEntity(name: $0) }
    }
}

private extension GetHeroesAPIRequest {
    struct RequestEntity: Codable {
        let name: String
    }
}

import Foundation

protocol GetHeroDetailUseCaseContract {
    func execute(name: String, completion: @escaping (Result<HeroModel, Error>) -> Void)
}

enum GetHeroDetailUseCaseError: Error {
    case missingValue
}

final class GetHeroDetailUseCase: GetHeroDetailUseCaseContract {
    func execute(name: String, completion: @escaping (Result<HeroModel, any Error>) -> Void) {
        GetHeroesAPIRequest(name: name)
            .perform { result in
                do {
                    guard let hero = try result.get().first else {
                        return completion(.failure(GetHeroDetailUseCaseError.missingValue))
                    }
                    completion(.success(hero))
                } catch {
                    completion(.failure(error))
                }
            }
    }
}

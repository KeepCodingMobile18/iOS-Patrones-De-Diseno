import Foundation

protocol GetHeroesUseCaseContract {
    func execute(completion: @escaping (Result<[HeroModel], Error>) -> Void)
}

final class GetHeroesUseCase: GetHeroesUseCaseContract {
    func execute(completion: @escaping (Result<[HeroModel], any Error>) -> Void) {
        GetHeroesAPIRequest(name: "")
            .perform { result in
                do {
                    completion(.success(try result.get()))
                } catch {
                    completion(.failure(error))
                }
            }
    }
}

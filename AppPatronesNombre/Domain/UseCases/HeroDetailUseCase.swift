import Foundation


protocol HeroDetailUseCaseContract {
    func execute(heroId: String, completion: @escaping (Result<Hero, Error>) -> Void)
}


final class HeroDetailUseCase: HeroDetailUseCaseContract {
    
    private let getAllHeroesUseCase: GetAllHeroesUseCaseContract
    
    init(getAllHeroesUseCase: GetAllHeroesUseCaseContract = GetAllHeroesUseCase()) {
        self.getAllHeroesUseCase = getAllHeroesUseCase
    }
    
    func execute(heroId: String, completion: @escaping (Result<Hero, Error>) -> Void) {
        getAllHeroesUseCase.execute { result in
            switch result {
            case .success(let heroes):
                if let hero = heroes.first(where: { $0.identifier == heroId }) {
                    completion(.success(hero))
                } else {
                    completion(.failure(NSError(domain: "Cannot find Character", code: 404, userInfo: nil)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

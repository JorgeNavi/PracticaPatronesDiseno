import UIKit

final class HeroDetailBuilder {
    func build(with hero: Hero) -> UIViewController {
        let viewModel = HeroDetailViewModel(hero: hero)
        let viewController = HeroDetailViewController(viewModel: viewModel)
        return viewController
    }
}

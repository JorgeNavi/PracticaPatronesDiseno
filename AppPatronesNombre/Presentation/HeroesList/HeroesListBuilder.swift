import UIKit


//Recordatorio, el Builder es unicamente construir el viewController, en este caso además le hemos especificado que es navigationController (que hereda de UIVIewController)
final class HeroesListBuilder {
    func build() -> UIViewController {
        let useCase = GetAllHeroesUseCase()
        let viewModel = HeroesListViewModel(useCase: useCase)
        let viewController = HeroesListViewController(viewModel: viewModel)
        
        //Como en este caso ya hemos accedido al área privada de la app y la navigación es de tipo push (las pantallas se mueven de lado a lado y no de abajo a arriba), vamos a establecer que, al ser el HeroesViewController la primera pantalla privada, también sea el navigation controller entre pantallas
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .fullScreen //Esto para hacer que se presente a pantalla completa
        return navigationController
    }
}

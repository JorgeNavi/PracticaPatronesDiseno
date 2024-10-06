//Los Builder tienen todos la misma estructura:

//Un inicializador que incia

//Unos setter que responden siempre la misma estancia (el propio builder)

//Un método build() que nos devuelve la instancia



import UIKit

//esta es la manera de inicializar el viewController
final class LoginBuilder {
    func build() -> UIViewController { //Establecemos una función build() que instancia un UIViewController
        let useCase = LoginUseCase()
        let viewModel = LoginViewModel(useCase: useCase)
        let viewController = LoginViewController(viewModel: viewModel)
        viewController.modalPresentationStyle = .fullScreen //Esto se hace para evitar el modo de presentación que tiene apple por defecto
        return viewController //Al haber metido el viewModel en el inicializador en la clase de LoginViewController, esta función lo que hace es introducir el LoginViewModel en una constante a la que nombramos viewModel. Acto seguido se le pide que retorne el LoginViewController con dicha constante como parámetro
    }
}

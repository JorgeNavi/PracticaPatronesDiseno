//Los Builder tienen todos la misma estructura:

//Un inicializador que incia

//Unos setter que responden siempre la misma estancia (el propio builder)

//Un método build() que nos devuelve la instancia

import UIKit

final class SplashBuilder {
    func build() -> UIViewController {  //Establecemos una función build() que instancia un UIViewController
        let viewModel = SplashViewModel()
        return SplashViewController(viewModel: viewModel)  //Al haber metido el viewModel en el inicializador en la clase de SplashViewController, esta función lo que hace es introducir el SplashViewModel en una constante a la que nombramos viewModel. Acto seguido se le pide que retorne el SplasViewController con dicha constante como parámetro
    }
}

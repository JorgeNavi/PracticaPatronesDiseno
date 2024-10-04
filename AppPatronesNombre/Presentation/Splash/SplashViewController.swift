import UIKit

final class SplashViewController: UIViewController {
    @IBOutlet private weak var spinner: UIActivityIndicatorView!
    
    //Creamos esta constante para referenciar/meter nuestro ViewModel, ya que el viewModel notifica a la vista mediante eventos
    private let viewModel: SplashViewModel //Constante llamada viewModel del type SplashViewModel
    //El compilador se queja porque aunque se referencie en una constante el viewModel, te va a decir que no le estas pasando un viewModel en ningun momento.
    //De manera que se lo pasamos introduciéndolo como parámetro en el inicializador de la clase
    
    
    init(viewModel: SplashViewModel) {
        self.viewModel = viewModel //Se lo pasamos por parámetro como bien se ha explicado antes
        //nibName es lo mismo que XiB, es inciarlo pasandole el XiB correspondiente
        //bundle es donde lo tiene que buscar. Podriamos dejarlo en .main
        //pero se puede usar la propia clase (en este caso SplashViewController)
        //esto se utiliza para que lo encuentre siempre.
        //escribiendo lo siguiente:
        super.init(nibName: "SplashView", bundle: Bundle(for: type(of: self))) //El string es el nombre del archivo XiB. "Dame el bundle para el type que soy yo
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Definimos una función para activar o desactivar nuestro spinner
    //Le pasamos una variable animating de tipo Bool
    private func setAnimation(_ animating: Bool) {
        //Establecemos la lógica de los casos del spinner
        //y observamos el estado en el que se encuentra nuestro spinner
        switch spinner.isAnimating { //Si el spinner esta animando:
        case true where !animating: //Si el spinner esta animando y yo quiero pararlo (Caso animating true donde yo quiero NoAnimating)
            spinner.stopAnimating()
        case false where animating: //Si el spinner no está animando y yo quiero iniciarlo (Caso animating false donde yo quiero Animating)
            spinner.startAnimating()
        default: //Por defecto si yo no estoy en ninguno de estos estados le meto un break
            break
        }
    }
}

#Preview {
    SplashBuilder().build()
}

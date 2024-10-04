import UIKit

final class SplashViewController: UIViewController {
    init() {
        //nibName es lo mismo que XiB
        //bundle es donde lo tiene que buscar. Podriamos dejarlo en .main
        //pero se puede usar la propia clase (en este caso SplashViewController)
        //esto se utiliza para que lo encuentre siempre.
        //escribiendo lo siguiente:
        super.init(nibName: "SplashView", bundle: Bundle(for: type(of: self))) //El string es el nombre del archivo XiB. "Dame el bundle para el type que soy yo
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

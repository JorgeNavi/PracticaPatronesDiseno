import UIKit

/// <#Description#>
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
        super.init(nibName: "SplashView", bundle: Bundle(for: type(of: self))) //El string es el nombre del archivo XiB. "Dame el bundle para el type que soy yo"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Este método es el primero que se ejecuta una vez cargue la vista
    //¿Cuándo usar viewDidLoad()?
    
    /*Este método es el lugar ideal para:
     
        •    Inicializar datos: Por ejemplo, configurar variables o preparar datos que se usarán en la vista.
        •    Configurar la interfaz de usuario (UI): Modificar elementos como colores, textos o imágenes.
        •    Hacer conexiones iniciales: Si tienes que cargar información desde una base de datos o un servicio, es buen momento para iniciar esas llamadas (aunque no para mostrar aún el resultado en la vista).
        •    Registrar observadores o notificaciones: Puedes utilizar este método para registrar observadores de eventos o suscribirte a notificaciones que luego se eliminarán en el viewWillDisappear().
     Nota importante:
     
        Aunque viewDidLoad() es un buen lugar para configuraciones iniciales, no debes hacer tareas que consuman mucho tiempo aquí, ya que eso podría hacer que la aplicación se sienta lenta o trabada al cargar la vista. Para tareas pesadas, es mejor utilizar otros hilos o esperar a momentos más apropiados en el ciclo de vida de la vista.
     */
    //Por ello, lo primero que hacemos es llamar a su super para que lo instancie o lo arranque (creo) y cargar el viewModel
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.load()
    }
    //Para enganchar la función de estados que le hemos metido al viewModel aquí mediante un binding, vamos a hacer una función en el viewModel llamada bind().
    private func bind() {
        viewModel.onStateChanged.bind { [weak self] state in  //viewModel.onStateChanged (que acabamos transformandolo en .bind tras haber programado el binding) en referencia a mi mismo (SplashViewController) vas a hacer lo siguiente con el estado del spinner (que es lo que controla onsTateChanged):
            switch state {
            case .loading: //En el caso de state .loading:
                self?.setAnimation(true) //Animation true
            case .ready: //En el caso del state .ready:
                self?.setAnimation(false) //Animation false
            case .error: //En caso de error:
                break //break
            }
        }
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

/*
 #Preview {
 SplashBuilder().build()
 }
 */

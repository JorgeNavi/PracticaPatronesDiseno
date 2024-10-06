import UIKit

final class LoginViewController: UIViewController {

    //Estas son las conexiones de los elementos de la vista (en este caso del stackView), al arrastrar con tecla control
    @IBOutlet private weak var sigInButton: UIButton!
    @IBOutlet private weak var errorLabel: UILabel!
    @IBOutlet private weak var spinner: UIActivityIndicatorView!
    @IBOutlet private weak var passwordField: UITextField!
    @IBOutlet private weak var usernameField: UITextField!
    //Creamos esta constante para referenciar/meter nuestro ViewModel, ya que el viewModel notifica a la vista mediante eventos
    private let viewModel: LoginViewModel //Constante llamada viewModel del type LoginViewModel
    
    //El compilador se queja porque aunque se referencie en una constante el viewModel, te va a decir que no le estas pasando un viewModel en ningun momento.
    //De manera que se lo pasamos introduciéndolo como parámetro en el inicializador de la clase
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel //Se lo pasamos por parámetro como bien se ha explicado antes
        //nibName es lo mismo que XiB, es inciarlo pasandole el XiB correspondiente
        //bundle es donde lo tiene que buscar. Podriamos dejarlo en .main
        //pero se puede usar la propia clase (en este caso LoginViewController)
        //esto se utiliza para que lo encuentre siempre.
        //escribiendo lo siguiente:
        super.init(nibName: "LoginView", bundle: Bundle(for: type(of: self))) //El string es el nombre del archivo XiB. "Dame el bundle para el type que soy yo"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    
    
    //El boton, como va a realizar una acción, en lugar de realizar una conexión Outlet se hace como acción y el compilador genera un método de acción (evento, por eso como parámetro mete un sender) al que nostros le damos el nombre de "onLoginButtonTapped" (con el boton del login pulsado)
    @IBAction func onLoginButtonTapped(_ sender: Any) {
        viewModel.sigIn(usernameField.text, passwordField.text)//LLamamos al metodo signIn del viewModel con el valor del campo de texto de las conexiones otlets que hemos establecido antes, de tal manera que cada vez que el usuario haga tap, lo mandamos al viewModel
    }
    
    
    //En esta función bind() nos suscribimos a ese binding "onStateChanged" y la llamamos arriba en el viewDidLoad
    private func bind() {
        viewModel.onStateChanged.bind { [weak self] state in
        //viewModel.onStateChanged (que acabamos transformandolo en .bind tras haber programado el binding) en referencia a mi mismo (LoginViewController) vas a hacer lo siguiente con el estado de la pantalla del Login (que es lo que controla onStateChanged):
            switch state {
                case .success:
                    self?.renderSuccess()
                self?.present(HeroesListBuilder().build(), animated: true) //Aqui presentamos la lista de heroes una vez que el login ha hecho success
                case .error(let reason):   //Le pasamos aquí el motivo del error, se escribe así porque le pasamos una constante como parámetro como exije el enum y le damos el mismo nombre que el que proporcionamos como parametro a la func renderError() en la siguiente linea
                    self?.renderError(reason)
                case .loading:
                    self?.renderLoading()
            }
        }
    }
    
    //podemos generar funciones para aquellos casos de los estados en la función bind() para no llenar cada caso del switch case de código. Sigue asi:
    
    // MARK: - State Rendering Functions
    private func renderSuccess () {
        sigInButton.isHidden = false
        spinner.stopAnimating()
        errorLabel.isHidden = true
    }
    
    private func renderError(_ reason: String) { //Le pasamos aquí el motivo del error
        sigInButton.isHidden = false
        spinner.stopAnimating()
        errorLabel.isHidden = false
        errorLabel.text = reason
    }
    
    private func renderLoading() {
        sigInButton.isHidden = true
        spinner.startAnimating()
        errorLabel.isHidden = true
    }
    
    //de esta manera en la que hacemos las funciones anteriores, se establece lo que debe hacer cada elemento según el estado de la pantalla y al switch case solo tenemos que pasarle las funciones
}

/*
 #Preview {
 LoginBuilder().build()
 }
 */


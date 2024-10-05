import UIKit

final class LoginViewController: UIViewController {

    //Estas son las conexiones de los elementos de la vista (en este caso del stackView), al arrastrar con tecla control
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
    
    
    
    //El boton, como va a realizar una acción, en lugar de realizar una conexión Outlet se hace como acción y el compilador genera un método de acción (evento, por eso como parámetro mete un sender) al que nostros le damos el nombre de "onLoginButtonTapped" (con el boton del login pulsado)
    @IBAction func onLoginButtonTapped(_ sender: Any) {
        viewModel.sigIn(usernameField.text, _password: passwordField.text)//LLamamos al metodo signIn del viewModel con el valor del campo de texto de las conexiones otlets que hemos establecido antes, de tal manera que cada vez que el usuario haga tap, lo mandamos al viewModel
    }
}

/*
 #Preview {
 LoginBuilder().build()
 }
 */


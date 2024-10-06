import Foundation

//Establecemos los estados que debe tener nuestro Login/pantalla:

enum LoginState {
    case success
    case error(reason: String) //Aqui en el error aprovechamos para pasarle el motivo del error como tipo String
    case loading
}



final class LoginViewModel {
    
    //Volvemos a utilizar el binding como en SplashViewModel
    //Este onStateChanged lo tenemos que leer (o suscribirnos a esos cambios) en el viewDidLoad de su controller
    let onStateChanged = Binding<LoginState>()
    //Nos vamos a atrae aquí la funcionalidad del LoginUseCase para actualizar nuestro viewModel
    private let useCase: LoginUseCaseContract
    
    //Aquí le pasamos esa consante al inicializador como parámetro. Sin embargo cada vez que inicialice un LoginViewControler, me va a pedir que la pase el LoginViewModel y éste, a su vez, me va a peidir que le pase un LoginUseCase. Para solucionar esto vamos a meter nuestro UseCase en el Builder
    init(useCase: LoginUseCaseContract) {
        self.useCase = useCase
    }
    
    //Aquí vamos a establcer las acciones que puede llevar a cabo el Login:
    //Acción/método de logearse a la que se les pasa como parámetros un username como String y una password como String
    func sigIn(_ username: String?, _ password: String?) {
        //Pasamos la accion/método al viewController en la acción del botón
        //Ahora en esta función establecemos la lógica del Login:
        // 1. Valido username valido
        // 2. Valido password valida
        // 3. Hago Login.
        // Esto vamos a hacerlo en otras funciones mas abajo (que nos hemos terminao llevando a LoginUseCase junto con los estados
        
        //Despues de que se ha validado el usuario y la contraseña se ejecuta el siguiente código para hacer el Login:
        onStateChanged.update(newValue: .loading) //el estado pasa a cargando y
        let credentials = Credentials(username: username ?? "", password: password ?? "") //Se introducen las credenciales. El operador ?? indica que si el valor que se le introduce a username o password es nil, automaticamente se les asignará como valor una cadena vacía
        useCase.execute(credentials: credentials) { [weak self] result in //Se ejecuta el metodo del useCase con las credenciales para que las valide y después se realizan los consecutivos cambios de estado
            do {
                try result.get()  //esta es una funcionalidad de result para captar errores. Funciona como un try except
                self?.onStateChanged.update(newValue: .success)
            } catch let error as LoginUsecaseError {
                self?.onStateChanged.update(newValue: .error(reason: error.reason))
            } catch {
                self?.onStateChanged.update(newValue: .error(reason: "Somethin has happened"))
            }
            
        }
    }
}

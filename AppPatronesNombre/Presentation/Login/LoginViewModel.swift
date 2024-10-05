//Establecemos los estados que debe tener nuestro Login/pantalla:

enum LoginState {
    case success
    case error(reason: String) //Aqui en el error aprovechamos para pasarle el motivo del error como tipo String
    case loading
}



final class LoginViewModel {
    
    //Aquí vamos a establcer las acciones que puede llevar a cabo el Login:
    
    //Acción/método de logearse a la que se les pasa como parámetros un username como String y una password como String
    func sigIn(_ username: String?, _password: String?) {
        //Pasamos la accion/método al viewController en la acción del botón
    }
}

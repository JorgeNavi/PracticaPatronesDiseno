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
    //Aquí vamos a establcer las acciones que puede llevar a cabo el Login:
    
    //Acción/método de logearse a la que se les pasa como parámetros un username como String y una password como String
    func sigIn(_ username: String?, _ password: String?) {
        //Pasamos la accion/método al viewController en la acción del botón
        //Ahora en esta función establecemos la lógica del Login:
        // 1. Valido username valido
        // 2. Valido password valida
        // 3. Hago Login.
        // Esto vamos a hacerlo en otras funciones mas abajo
        guard let username, validateUsername(username) else { //Guard let username se encarga de asegurar que username tenga valor, es decir que no es nil, es decir, que hay algun valor en el parametro de tipo String de sigIn. después se ha de cumplir la vaidación de usuario, que es el validateUsername(username) al que se le pasa el valor del guard. Si no se cumplen esas condiciones es cuando metemos el else, que puede ser cambiar un estado o mostrar un mensaje o lo que queramos. En este caso vamos a cambiar el estado a "error" e informar el reason. Lo mismo con el password
            return onStateChanged.update(newValue: .error(reason: "Invalid username"))
        }
        guard let password, validatePassword(password) else {
            return onStateChanged.update(newValue: .error(reason: "Invalid password"))
        }
        
        //Despues de que se ha validado el usuario y la contraseña se ejecuta el siguiente código:
        onStateChanged.update(newValue: .loading) //el estado pasa a cargando y
        DispatchQueue.global().asyncAfter(deadline: .now() + 3) { [weak self] in //tras 3 segundos desde now(),
            self?.onStateChanged.update(newValue: .success) //el estado cambia a success
        }
    }
    
    private func validateUsername(_ username: String) -> Bool {
        username.contains("@") && !username.isEmpty //Username tiene que contener @ (para que sea un correo) y no estar vacio
    }
    
    private func validatePassword(_ password: String) -> Bool {
        password.count >= 4  //password .count (que es lo mismo que .lenght) tiene que ser mayor o igual que 4
    }
}

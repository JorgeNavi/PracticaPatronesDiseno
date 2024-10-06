import Foundation

//Un caso de uso se utiliza para realizar acciones con nuestro modelo de dominio/negocio. Solo tiene que tener un método que sea run() o execute() o ese tipo. Pero sólo un método que es donde se aplica la lógica de negocio. Cuanta más lógica de negocio tengamos en un caso de uso, es más completo y es cuando mejor está realizando su función.

//La diferencia entre un protocolo y una clase/struct es que el Prtocolo define funcionalidad y la clase/struct implementa funcionalidad.

//LLamarlo Contract es únicamene para hacer referencia a que nos estamos comprometiendo con el protocolo, es una mera formalidad.

/*
 Explicación detallada de (completion: @escaping (Result<Void, Error>) -> Void):
•    completion es una closure, un bloque de código que se pasa como parámetro.
•    @escaping indica que la closure puede ser ejecutada después de que la función execute termine. En otras palabras, la función puede “guardar” esta closure y ejecutarla en algún momento posterior, lo que es útil en operaciones asíncronas (por ejemplo, una solicitud a un servidor que tarda en responder).
•    (Result<Void, Error>) -> Void: La closure toma un valor de tipo Result<Void, Error> como entrada y no devuelve ningún valor (es decir, retorna Void o nada).
 
Ahora, descompongamos qué significa el tipo Result<Void, Error>:
•    Result es un tipo que representa el resultado de una operación, que puede tener éxito o fallar. Es una enumeración con dos casos:
•    .success(Void): Indica que la operación fue exitosa. Void simplemente significa que no hay datos adicionales que se necesiten devolver cuando la operación es exitosa.
•    .failure(Error): Indica que la operación falló, y en este caso, se devolverá un valor del tipo Error que proporciona información sobre qué salió mal.
*/
protocol LoginUseCaseContract {
    //Como hemos dicho, solo tendría que tener un método execute.
    func execute(credentials: Credentials, completion: @escaping (Result<Void, LoginUsecaseError>) -> Void)
    //El Result siempre nos va a pedir dos parámetros que se pasan como genéricos (Porque no tendría sentido ir porbando todos los casos como "Int, Error" o "String, Error" etc. El primero es el caso de éxito en  el Resultado y el segundo es el caso de Error en el Resultado
}

// Ahora realizamos una implementación del protocolo con una clase
final class LoginUseCase: LoginUseCaseContract {
    func execute(credentials: Credentials, completion: @escaping (Result<Void, LoginUsecaseError>) -> Void) {
        guard validateUsername(credentials.username) else { //Guard let username se encarga de asegurar que username tenga valor, es decir que no es nil, es decir, que hay algun valor en el parametro de tipo String de sigIn. después se ha de cumplir la vaidación de usuario, que es el validateUsername(username) al que se le pasa el valor del guard. Si no se cumplen esas condiciones es cuando metemos el else, que puede ser cambiar un estado o mostrar un mensaje o lo que queramos. En este caso vamos a cambiar el estado a "error" e informar el reason. Lo mismo con el password
            return completion(.failure(LoginUsecaseError(reason: "Invalid username")))
        }
        guard validatePassword(credentials.paswword) else {
            return completion(.failure(LoginUsecaseError(reason: "Invalid password")))
        }
        //DispatchQueue.global() etc quiere decir que en una cola global(segundo plano) tras 3 sec (desde .now() +3) ejecuta la siguiente función (Closure) que empieza en la llave {
        DispatchQueue.global().asyncAfter(deadline: .now() + 3) {
            completion(.success(())) //Este success es el caso de éxito dentro del Result
            
        //Para continuar nos vamos a establecer un pequeño modelo de datos para las credenciales en la carpeta Models
        }
    }
    
    private func validateUsername(_ username: String) -> Bool {
        username.contains("@") && !username.isEmpty //Username tiene que contener @ (para que sea un correo) y no estar vacio
    }
    
    private func validatePassword(_ password: String) -> Bool {
        password.count >= 4  //password .count (que es lo mismo que .lenght) tiene que ser mayor o igual que 4
    }
}

//Nos vamos a definir un error en concreto para el caso de uso de Login:
struct LoginUsecaseError: Error {
    let reason: String
}

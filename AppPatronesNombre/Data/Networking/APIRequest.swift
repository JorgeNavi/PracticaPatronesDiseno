import Foundation

//Vamos a crear el cliente HTTP

//Definimos un enumerado de los métodos
enum HTTPMethod: String {
    case GET, POST, PUT, UPDATE, HEAD, PATCH, DELETE, OPTIONS
}

//Aquí establecemos como de estar construida la URL de la petición a la API. Una petición de red
//La petición de red tiene una estructura, que es lo que me define el protocolo
protocol APIRequest {
    var host: String { get } //El host es la URL base de la API, es decir, la dirección del servidor.
    var method: HTTPMethod { get } //Representa el método HTTP de la petición, como GET (para obtener información), POST (para enviar datos), PUT (para actualizar), DELETE (para borrar), etc.
    var body: Encodable? { get } //El body es la información que se envía en la petición. Esta información debe conformar el protocolo `Encodable` para poder convertirse a JSON u otro formato que la API acepte. No es "el swift que tenemos que hacer encodable", sino la estructura de datos que queremos enviar en la solicitud, que debe ser serializable a un formato adecuado (generalmente JSON).
    var path: String { get } //El path es la ruta específica dentro del host que señala el recurso al que estás haciendo la solicitud.
    var headers: [String: String] { get } //Los headers son pares clave-valor que contienen información adicional para la solicitud, como autenticación o tipo de contenido (Content-Type).
    var queryParameters: [String: String] { get } //Los parámetros de búsqueda son pares clave-valor que se añaden a la URL en formato de consulta, generalmente para filtrar o especificar la petición.
    
    associatedtype Response: Decodable  //La respuesta de la API debe conformar el protocolo `Decodable` para poder ser convertida de JSON u otro formato a un tipo de datos Swift.
    typealias APIRequestResponse = Result<Response, APIErrorResponse> //`Result` es una enumeración que puede ser éxito (`Response`) o error (`APIErrorResponse`). Esto encapsula la respuesta de la API.
    typealias APIRequestCompletion = (APIRequestResponse) -> Void //APIRequestCompletion` es un alias para una función que toma un `APIRequestResponse` como parámetro y no devuelve nada. Esta sería una función de finalización que se llamaría cuando la solicitud a la API haya terminado.
}

//Aquí vamos a establcer los valores por defecto, como acudir siempre a nuestra API de DragonBall
extension APIRequest {
    var host: String { "dragonball.keepcoding.education" } //la URL de nuestra API
    var queryParameters: [String: String] { [:] } //No vamos a establecer valores por defecto mas alla de diccionario vacío
    var headers: [String: String] { [:] } //No vamos a establecer valores por defecto mas alla de diccionario vacío
    var body: Encodable? { nil } //valor por defecto nil
    
    func getRequest() throws -> URLRequest { //Método de llamar la Request, estamos montando una URL Request. Es decir, estamos montando la URL con los valores de nuestra API. Estamos preparando la solicitud completa para ser enviada a la API
        var components = URLComponents()
        components.scheme = "https"
        components.host = host
        components.path = path
        if !queryParameters.isEmpty {
            components.queryItems = queryParameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        guard let finalURL = components.url else { //Este  guard let finalURL = components.url es nuestra URL final. Al ser opcional entra el caso de error si viene vacio
            throw APIErrorResponse.malformedURL(path)
        }
        var request = URLRequest(url: finalURL) //Aquí vamos a hacer la peticion con la URL final
        request.httpMethod = method.rawValue //Aqui el httpMethod de la request tiene el valor String del rawvalue del enum construido arriba
        if method != .GET, let body { //Si el metodo de la request es distinto de GET, se establece una constante body. EL httpBody de la request tiene el valor de intentar usar el JSONEncoder para pasarlo a formato JSON y se pide que lo que se encode sea el body
            request.httpBody = try JSONEncoder().encode(body)
        }
        request.allHTTPHeaderFields = ["Accept": "application/json", "Content-Type": "application/json"].merging(headers) { $1 } //se añaden los headers 1 a 1 y se usa la funcion merging para concatenar ACCpet y Content-type. Y despues me quedo con el avlor de las headers con $1. "Mis cabeceras tienen mas prioridad que las que van por defecto
        request.timeoutInterval = 10 //se establece un timeout porque el valor por defecto que tiene URLSession es de 1 min. Esto lo que hace es que si la respuesta tarda mas de el tiempo que se establece en el timeout, te da un codigo de error.
        return request
    }
}

// MARK: - Execution
extension APIRequest {
    func perform(session: APISessionContract = APISession.shared, completion: @escaping APIRequestCompletion) { //Con esto ejecutamos la accion y todo el parseo de la Request
        session.request(apiRequest: self) { result in
            do {
                let data = try result.get()
                
                if Response.self == Void.self {  //Si el tipo que me estas pasando es vacio
                    return completion(.success(() as! Response)) //significa que esta bien como Respuesta (ESTO NO LO ENTIENDO)
                } else if Response.self == Data.self { //Si el tipo que me estas pasando es Data
                    return completion(.success(data as! Response)) //Significa que tambien esta bien como Respuesta (TAMPOCO LO ENTIENDO)
                }

                return try completion(.success(JSONDecoder().decode(Response.self, from: data))) //con el JSONDecoder().decode() y pasándole la respuesta, se decodifica y podemos usarla
            } catch let error as APIErrorResponse {
                completion(.failure(error))
            } catch {
                completion(.failure(APIErrorResponse.unknown(path)))
            }
        }
    }
}

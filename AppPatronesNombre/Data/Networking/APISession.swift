import Foundation

//aqui se ejecuta la request. Definiendo el objeto de session de HTTP

protocol APISessionContract {
/*
        1.    func request<Request: APIRequest>:
 
        •    Aquí se define una función llamada request.
        •    Request: APIRequest indica que el tipo genérico Request debe conformar el protocolo APIRequest. Esto significa que cualquier tipo que quieras pasar como apiRequest debe cumplir con los requisitos definidos en el protocolo APIRequest (como tener un host, path, method, etc.).
 
        2.    apiRequest: Request:
 
        •    El parámetro apiRequest es una instancia del tipo genérico Request, que, como vimos antes, debe conformar APIRequest.
        •    Este parámetro contiene toda la información que define la solicitud (como el host, la ruta, los encabezados, el cuerpo, etc.).
 
        3.    completion: @escaping (Result<Data, Error>) -> Void:
 
        •    completion es un closure (o función de finalización) que se ejecuta cuando la solicitud ha finalizado, y es de tipo @escaping. Esto significa que este closure podría ejecutarse después de que la función request haya terminado, lo cual es típico en llamadas asíncronas como las de una API.
        •    El closure toma un Result<Data, Error>:
        •    Result<Data, Error> es un tipo genérico de Swift que representa dos posibles resultados:
        •    Éxito: Contiene los datos de tipo Data que fueron devueltos por la API (normalmente una respuesta en formato JSON u otros datos).
        •    Error: Si ocurre algún error durante la petición, este resultado contendrá un objeto de tipo Error que describe lo que falló.
        •    El closure no devuelve nada (Void), solo procesa el resultado cuando la solicitud ha finalizado.
*/
    func request<Request: APIRequest>(apiRequest: Request, completion: @escaping (Result<Data, Error>) -> Void)
}

struct APISession: APISessionContract {
    static var shared: APISessionContract = APISession() //patron singleton. Un estatico que existe durante todo el ciclo de vida de la app y que yo lo puedo llamar desde cualquier sitio
    
    private let session = URLSession(configuration: .default) //creamos un objeto URLSession con la configuracion por defecto
    private let requestInterceptors: [APIRequestInterceptor]
    
    init(requestInterceptors: [APIRequestInterceptor] = [AuthenticationRequestInterceptor()]) {
        self.requestInterceptors = requestInterceptors
    }
    
    func request<Request: APIRequest >(apiRequest: Request, completion: @escaping (Result<Data, Error>) -> Void) { //Implementamos nuestra request
        do {
            var request = try apiRequest.getRequest()
            
            requestInterceptors.forEach { $0.intercept(request: &request) }
            
            session.dataTask(with: request) { data, response, error in //invocamos a la request con nuestra session
                if let error {
                    return completion(.failure(error))
                }
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else { // == 200 es que ha ido todo OK
                    return completion(.failure(APIErrorResponse.network(apiRequest.path)))
                }
                return completion(.success(data ?? Data()))
            }.resume() //el datatask hay que ejecutarlo y para eso sirve resume()
        } catch {
            completion(.failure(error))
        }
    }
}

import Foundation

//Vamos a definir el caso de que una petición a la API de Error

struct APIErrorResponse: Error, Equatable { //La respuesta de error de una API va a tener
    let url: String //Una url
    let statusCode: Int //El código del error (Ej: error 404)
    let data: Data? //Unos datos
    let message: String //Y un mensaje de error
    
    init(url: String, statusCode: Int, data: Data? = nil, message: String) { //En el inicializador le vamos a pasar todos sus atributos como parámetros
        self.url = url
        self.statusCode = statusCode
        self.data = data
        self.message = message
    }
}

extension APIErrorResponse { //Vamos a establecer más tipos de errores con una extension del struct
    static func network(_ url: String) -> APIErrorResponse {
        APIErrorResponse(url: url, statusCode: -1, message: "Network connection error")
    }
    static func parseData(_ url: String) -> APIErrorResponse {
        APIErrorResponse(url: url, statusCode: -2, message: "cannot parse data")
    }
    static func unknown(_ url: String) -> APIErrorResponse {
        APIErrorResponse(url: url, statusCode: -3, message: "unknown error")
    }
    static func empty(_ url: String) -> APIErrorResponse {
        APIErrorResponse(url: url, statusCode: -4, message: "empty response")
    }
    static func malformedURL(_ url: String) -> APIErrorResponse {
        APIErrorResponse(url: url, statusCode: -5, message: "malformed URL error")
    }
}

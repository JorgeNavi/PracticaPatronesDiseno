import Foundation

struct LoginAPIRequest: APIRequest { //Esta implementando el APIRequest que hemos cosntruido
    typealias Response = Data
    
    let headers: [String: String]
    let method: HTTPMethod = .POST
    let path: String = "/api/auth/login" //las URL estan en POSTMAN
    
    init(credentials: Credentials) {
        let loginData = Data(String(format: "%@:%@", credentials.username, credentials.password).utf8)
        let base64String = loginData.base64EncodedString()
        headers = ["Authorization": "Basic \(base64String)"]
    }
}

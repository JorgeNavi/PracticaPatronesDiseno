import Foundation

//Esto es un patrón de almacenamiento. Tampoco lo entiendo muy bien

protocol SessionDataSourceContract {
    func storeSession(_ session: Data)
    
    func getSession() -> Data?
}

final class SessionDataSource: SessionDataSourceContract {
    private static var token: Data?
    
    func storeSession(_ session: Data) {
        SessionDataSource.token = session
    }
    
    func getSession() -> Data? {
        SessionDataSource.token
    }
}

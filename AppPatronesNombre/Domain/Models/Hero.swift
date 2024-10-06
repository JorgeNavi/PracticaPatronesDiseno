struct Hero: Equatable, Decodable {
    let identifier: String
    let name: String
    let description: String
    let photo: String
    let favorite: Bool
    
    enum CodingKeys: String, CodingKey { //esto se hace porque en nuestra API por ejemplo, el identifier se llama "id", y si no se lo informamos, swift no lo va a encontrar porque va apasar identifiera a JSON y no lo encontrará
        case identifier = "id"
        case name
        case description
        case photo
        case favorite
    }
}

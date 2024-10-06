import UIKit

final class HeroTableViewCell: UITableViewCell {
    @IBOutlet private weak var avatar: AsyncImageView!
    @IBOutlet private weak var heroName: UILabel!
    static let ruseIdentifier = "HeroTableViewCell" //Esto se hace para implementar la reutilización de las celdas con el número de celdas que caben en la pantalla
    static var nib: UINib { UINib(nibName: "HeroTableViewCell", bundle: Bundle(for: HeroTableViewCell.self))}
    
    //las celdas tienen esta función por defecto que es la que se va a llamar cuando las celdas vayan a ser reutilizadas
    override func prepareForReuse() {
        super.prepareForReuse()
        avatar.cancel()
    }
    
    func setAvatar(_ avatar: String) {
        self.avatar.setImage(avatar)
    }
    
    func setHeroName(_ heroName: String){
        self.heroName.text = heroName
    }
}

import UIKit

final class HeroDetailViewController: UIViewController {
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet private weak var heroImageView: AsyncImageView!
    @IBOutlet private weak var heroNameLabel: UILabel!
    @IBOutlet private weak var heroDescriptionLabel: UILabel!
    @IBOutlet private weak var errorLabel: UILabel!
    @IBOutlet private weak var retryBotton: UIButton!
    @IBOutlet private weak var errorContainer: UIStackView!
    
    private let viewModel: HeroDetailViewModel
    
    init(viewModel: HeroDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "HeroDetailView", bundle: Bundle(for: type(of: self)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        viewModel.load()
    }
    
    private func bind() {
        viewModel.onStateChanged.bind { [weak self] state in
            switch state {
            case .loading:
                self?.spinner.startAnimating()
            case .loaded(let hero):
                self?.renderHeroDetails(hero)
            case .error(let reason):
                // Muestra un mensaje de error si quieres
                print("Error: \(message)")
            }
        }
    }
    
    private func renderHeroDetails(_ hero: Hero) {
        heroNameLabel.text = hero.name
        heroDescriptionLabel.text = hero.description
        heroImageView.setImage(hero.photo) // Usamos AsyncImageView para cargar la imagen
    }
    
    
}

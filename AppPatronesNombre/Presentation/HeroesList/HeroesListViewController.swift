import UIKit

final class HeroesListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var spinner: UIActivityIndicatorView!
    @IBOutlet private weak var errorLabel: UILabel!
    @IBOutlet private weak var retryBotton: UIButton!
    @IBOutlet private weak var errorContainer: UIStackView!
    
    private let viewModel: HeroesListViewModel
    
    init(viewModel: HeroesListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "HeroesListView", bundle: Bundle(for: type(of: self)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self //cargamos la tableView cuya fuente de datos es "yo mismo"
        tableView.delegate = self
        //Ahora vamos a registrar la celda:
        //Estamos llamando desde el archivo HeroTableViewCell su nib y su ReUseIdentifier
        tableView.register(HeroTableViewCell.nib, forCellReuseIdentifier: HeroTableViewCell.ruseIdentifier)
        bind()
        viewModel.load()
    }
    
    @IBAction func onRetryTapped(_ sender: Any) {
    }
    
    // MARK: - States
    
    private func bind() {
        viewModel.onStateChanged.bind { [weak self] state in
            switch state {
            case .loading:
                self?.renderLoading()
            case .success:
                self?.renderSuccess()
            case .error(let error):
                self?.renderError(error)
            }
        }
    }
    
    //Hacemos como en el login funciones para cada estado
    private func renderError(_ reason: String) {
        spinner.stopAnimating()
        errorContainer.isHidden = false
        tableView.isHidden = true
        errorLabel.text = reason
    }
    
    private func renderLoading() {
        spinner.startAnimating()
        errorContainer.isHidden = true
        tableView.isHidden = true
    }
    
    private func renderSuccess() {
        spinner.stopAnimating()
        errorContainer.isHidden = true
        tableView.isHidden = false
        tableView.reloadData()
    }
    
    //Esta funcion define el numero de filas que va a tener la tabla
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.heroes.count //nosotros lo configuramos con el numero de heroes del que disponemos sacado del viewModel (la variable private(set) var heroes: [Hero], a la que se le añade el valor del resultado de la request (self?.heroes = try result.get())
    }
    
    //Esto nos sirve por si tenemos celdas de diferentes alturas le podemos decir un: Dame la altura para esta tabla(Parámetro) para este indexPath(Parámetro)
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        90 //LO hardcoreamos a 90, el mismo que hemos definido en el XiB
    }
    
    //Aqui momtamos el contenido de la celda de cada fila, vamos a montarlo desde la carpeta Cells de HeroesList
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HeroTableViewCell.ruseIdentifier, for: indexPath)
        if let cell = cell as? HeroTableViewCell {
            let hero = viewModel.heroes[indexPath.row]
            cell.setAvatar(hero.photo)
            cell.setHeroName(hero.name)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedHero = viewModel.heroes[indexPath.row]
        let detailViewController = HeroDetailBuilder().build(with: selectedHero)
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
        
}
    

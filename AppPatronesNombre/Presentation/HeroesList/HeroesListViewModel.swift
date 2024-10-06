import Foundation

//en los viewModel vamos a establcer los estados de la vista

enum HeroesListState {
    case loading
    case error(reason: String)
    case success
}


final class HeroesListViewModel {
    let onStateChanged = Binding<HeroesListState>()
    //la sintaxia private(set) indica que el get es publico y accesible, pero el setter no, con lo que no se puede modificar si no es desde aqui (viewModel)
    private(set) var heroes: [Hero] = [] //guardar abajo el resultado aqui sirve para guardar en memoria los eventos y que no tengan que estar lanzando la informacion todo el rato
    
    private let useCase: GetAllHeroesUseCase

    init(useCase: GetAllHeroesUseCase) {
        self.useCase = useCase
    }
    
    //En este caso, el evento del viewModel es una acción de carga (la pantalla ha cargado)
    func load() { //Y que va a hacer nuestra func load?
        onStateChanged.update(newValue: .loading) //Lo primero es actualizar el estado de la pantalla a loading
        useCase.execute { [weak self] result in //ejecutamos el useCase para
            do {
                self?.heroes = try result.get()  //try traer el result y meterlo en la variable heroes creada mas arriba
                self?.onStateChanged.update(newValue: .success) //si lo consigues, actualiza a success
            } catch { //Si no
                self?.onStateChanged.update(newValue: .error(reason: error.localizedDescription)) //Actualiza a error
            }
        }
        
    }
    
}

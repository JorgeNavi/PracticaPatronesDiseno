// En el viewModel es donde se aplia toda la lógica de la pantalla

import Foundation

//Vamos a establecer los estados en los que se puede encontrar nuestro spinner/pantalla
enum SplashState {
    case loading
    case ready
    case error
}

final class SplashViewModel {
    //Para comunicarle desde el SplashViewModel que el estado de nuestro spinner a cambiado generamos un Completion:
    //var onStateChanged: ((SplashState) -> Void)? //Generamos una variable de nombre onStateChanged a la que le incluimos el estado del spinner introduciendole el enum
    //Comentamos la variable var onStateChanged: ((SplashState) -> Void)? porque vamos a utilizar el binding creado de la siguiente forma:
    var onStateChanged = Binding<SplashState>()
    
    func load() {
        
        
        //onStateChanged?(.loading) //"La variale tiene ahora mismo el valor de loading del enum
        //Comentamos también esta variable onStateChanged?(.loading) que habiamos utilizado antes del binding y la refactorizamos usando el binding:
        onStateChanged.update(newValue: .loading) //detal manera que ya no me tengo que preocupar del hilo en el que estoy, asi que vamos a comentar más abajo el dispactchqueue al main
        //DispatchQueue.global() etc quiere decir que en una cola global(segundo plano) tras 3 sec (desde .now() +5) ejecuta la siguiente función (Closure) que empieza en la llave {
        DispatchQueue.global().asyncAfter(deadline: .now() + 3) { [weak self] in //La función dice que "sobre mi referencia (por eso ponemos weak, para que no ocupe memoria), ejecuta onStateChanged(.ready)
            //El problema de lo que estamos haciendo arriba es que estamos lanzando un cambio de estado desde un hilo secundario y los cambios de estado deben estar en el hilo principal. Por tanto hay que mover esta ejecución al hilo principal de la siguiente manera:
            // DispatchQueue.main.async { //De esta forma la ejecución de self?.onStateChanged?(.ready) y cada vez que se llame a onStateChanged se hace en el hilo principal
            //Sin embargo hacer esto no es del todo producente porque e sprobable que se le escape al desarrollador mover las ejecuciones al hilo principal, y para eso está eñ binding, que es lo mismo que lo de arriba pero encapsulándolo en un mismo punto para usarlo de manera que estemos seguros de que siempre vamos al hilo principal, Con lo que procedemos a crear la clase Binding en la carpeta de Presentación
            //self?.onStateChanged?(.ready)
            //Comentamos pues self?.onStateChanged?(.ready) para usar el binding en su lugar:
            self?.onStateChanged.update(newValue: .ready)
            
        }
    }
}

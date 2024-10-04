import Foundation


//la idea es intentar encapsular aqui una funciñon que nos notifique el cambio de estado independientemente del hilo siempre nos cambia al hilo principal
final class Binding <State> { //Al meterle un tipo genérico (<entre estas comillas>, genérico quiere decir que "Programas contra un tipo) al binding
    //Por tanto esto es binding que recibe un tipo "State". Swift por debajo hace su magia y voilá, ya puedes meter el tipo state en la clase
    
    //Creamos un typealias. Un tuypealias es una forma de otorgar un nombre personalizado a un tipo. Por ejemplo:
    // typealias numero = Int. Cuando se informe de que el tipo de algo es numero, se esta diciendo que su tipo es un Int. Esto es util por tema limpieza de código. Ej: typealias MiTipo = SplashViewController
    
    //En este caco hemos hecho un Completion que va a ser una función que devuelva Void
    typealias Completion = (State) -> Void //Con lo realizado antes al meterle genérico <State> a la clase, ya se le puede meter el tipo State al Completion
    
    var completion: Completion? //generamos una variable a la que llamamos completion que es del tipo Completion (nuestro typealias). Es decir, es una variable de tipo State
    
    /* Función bind(Completion:)
     Esta función se usa para “enlazar” o “asignar” la función de Completion (una función que recibe un State) a la variable completion de la clase.
     La palabra clave @escaping significa que la función que se pasa como parámetro (completion) podría ser usada más tarde, después de que la función bind termine de ejecutarse.
     */
    func bind(completion: @escaping Completion) {
        self.completion = completion
    }
    
    /* Función update(newValue: State)
     Esta función es la que actualiza el estado con un nuevo valor (newValue) del tipo State.
     Dentro de esta función, se usa DispatchQueue.main.async para asegurarse de que cualquier cambio que se haga, se haga en el hilo principal. Esto es importante en aplicaciones móviles porque las actualizaciones de la interfaz de usuario deben hacerse en el hilo principal, y no en hilos de fondo que puedan estar ejecutándose en paralelo.
     El bloque de código dentro de DispatchQueue.main.async usa [weak self] para evitar que se cree un ciclo de retención en la memoria. Básicamente, esto es una forma de prevenir posibles fugas de memoria al hacer referencia a self dentro de un bloque de código que puede ejecutarse en el futuro.
     Finalmente, se ejecuta la función completion (si es que tiene algún valor), pasándole el nuevo valor newValue.
     */
    func update(newValue: State) {
        DispatchQueue.main.async { [weak self] in
            self?.completion?(newValue) //Cada vez que tenga un newValue, automáticamente me lo refresca por dentro
        }
    }
}

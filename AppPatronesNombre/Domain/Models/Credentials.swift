//Aqui vamos a establecer las credenciales. Muchos modelos los construimos como struct porque una vez construido no nos va a interesar mutarlo, entonces no nos interesa crearlo por referencia

//Ahora estas credenciales se las pasamos al caso de uso del Login como parámetro de su método
struct Credentials {
    let username: String
    let paswword: String
}

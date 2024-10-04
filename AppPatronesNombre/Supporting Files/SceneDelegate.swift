//
//  SceneDelegate.swift
//  AppPatronesNombre
//
//  Created by Jorge Navidad Espliego on 4/10/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let scene = (scene as? UIWindowScene) else { return }
        
        //Le metemos una scene a al window
        self.window = UIWindow(windowScene: scene)
        
        //y aqui a window le metemos nuestro controlador de splash
        //el rootViewController es el orgine sobre el que se extiende toda la navegación, es decir
        //es el punto sobre el que vamos a montar un arbol de navegación
        self.window?.rootViewController = SplashBuilder().build() //para no tener que pasarle todo el rato los argumentos y ya que vamos a pasar siempre el mismo objeto, vamos a generar el builder en este punto (despues de haber generado el viewModel)
        //Como la funcion .build() del (Splash)Builder retorna ya un SplashViewController con el SplashViewModel como pámetro, no hace falta más que llamar al Builder con su metodo .build() y por eso es "SplashBuilder().build()
        
        
        //con esto le decimos que es la pantalla que tiene que estar activa y visible
        self.window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}


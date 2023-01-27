//
//  SceneDelegate.swift
//  Converter
//
//  Created by johann casique on 25/1/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        
        window.rootViewController = AppRouter().presentMain()
        self.window = window
        window.makeKeyAndVisible()
    }
    
    
}

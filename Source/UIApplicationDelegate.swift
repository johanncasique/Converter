//
//  UIApplicationDelegate.swift
//  Converter
//
//  Created by johann casique on 30/6/22.
//

import Foundation
import UIKit


class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
//        Client()
//            .setEndpoint("https://localhost/v1") // Your API Endpoint
//            .setProject("5df5acd0d48c2") // Your project ID
//            .setSelfSigned(true) // For self signed certificates, only use for development
        
        return true
    }
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Defaul Configuration",
                                    sessionRole: connectingSceneSession.role)
    }
}

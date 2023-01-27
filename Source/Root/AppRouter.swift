//
//  AppRouter.swift
//  Converter
//
//  Created by johann casique on 25/1/23.
//

import UIKit

protocol AppRouterProtocol {
    func presentMain() -> UIViewController
}

class AppRouter: AppRouterProtocol {
    
    var navigationViewController: UINavigationController!
    
    func presentMain() -> UIViewController {
        let tabBar = UITabBarController()
        
        let homeConfigurator = HomeConfigurator()
        tabBar.viewControllers = [homeConfigurator.setup()]
        tabBar.tabBarItem = UITabBarItem(title: "Converter",
                                         image: .init(systemName: "plus.forwardslash.minus"),
                                         tag: 1)
        navigationViewController = .init(rootViewController: tabBar)
        return tabBar
    }
}

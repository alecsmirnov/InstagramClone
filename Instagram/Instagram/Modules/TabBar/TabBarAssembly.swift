//
//  TabBarAssembly.swift
//  Instagram
//
//  Created by Admin on 15.01.2021.
//

import UIKit

final class TabBarAssembly {
    // MARK: Properties
    
    private enum Constants {
        static let homeTabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)
    }
}

// MARK: - Public Methods

extension TabBarAssembly {
    static func createTabBarController() -> TabBarController {
        let homeTab = createNavigationController(viewController: HomeAssembly.createHomeViewController(),
                                                 tabBarItem: Constants.homeTabBarItem)
        
        let tabBarController = TabBarController(viewControllers: [homeTab])
        
        return tabBarController
    }
}

// MARK: - Private Methods

private extension TabBarAssembly {
    static func createNavigationController(
        viewController: UIViewController,
        tabBarItem: UITabBarItem
    ) -> UINavigationController {
        viewController.tabBarItem = tabBarItem
        
        return UINavigationController(rootViewController: viewController)
    }
}

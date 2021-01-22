//
//  TabBarAssembly.swift
//  Instagram
//
//  Created by Admin on 15.01.2021.
//

import UIKit

final class TabBarAssembly {
    // MARK: Constants
    
    private enum Colors {
        static let tint = UIColor.black
    }
    
    private enum TabBarItems {
        static let home = UITabBarItem(
            title: nil,
            image: AssetsImages.homeUnselected,
            selectedImage: AssetsImages.homeSelected)
        static let profile = UITabBarItem(
            title: nil,
            image: AssetsImages.profileUnselected,
            selectedImage: AssetsImages.profileSelected)
    }
}

// MARK: - Public Methods

extension TabBarAssembly {
    static func createTabBarController() -> UITabBarController {
        //let homeViewController = HomeAssembly.createHomeViewController()
        let profileViewController = ProfileAssembly.createProfileViewController()
        
        //let homeTab = createNavigationController(viewController: homeViewController, tabBarItem: TabBarItems.home)
        let profileTab = createNavigationController(
            viewController: profileViewController,
            tabBarItem: TabBarItems.profile)
        
        let tabBarController = UITabBarController()
        
        tabBarController.viewControllers = [profileTab]
        tabBarController.tabBar.tintColor = Colors.tint
        
        return tabBarController
    }
}

// MARK: - Private Methods

private extension TabBarAssembly {
    static func createNavigationController(
        viewController: UIViewController,
        tabBarItem: UITabBarItem
    ) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.tabBarItem = tabBarItem
        
        return navigationController
    }
}

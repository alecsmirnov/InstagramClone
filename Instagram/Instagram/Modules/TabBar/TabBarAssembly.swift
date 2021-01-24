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
    
    private enum Images {
        static let homeUnselected = UIImage(named: "home_unselected")
        static let homeSelected = UIImage(named: "home_selected")
        static let profileUnselected = UIImage(named: "profile_unselected")
        static let profileSelected = UIImage(named: "profile_selected")
    }
    
    private enum TabBarItems {
        static let home = UITabBarItem(
            title: nil,
            image: Images.homeUnselected,
            selectedImage: Images.homeSelected)
        static let profile = UITabBarItem(
            title: nil,
            image: Images.profileUnselected,
            selectedImage: Images.profileSelected)
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
        
        let registrationViewController = RegistrationAssembly.createRegistrationViewController()
        let registrationTab = createNavigationController(
            viewController: registrationViewController,
            tabBarItem: TabBarItems.home)
        
        let tabBarController = UITabBarController()
        
        tabBarController.viewControllers = [profileTab, registrationTab]
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

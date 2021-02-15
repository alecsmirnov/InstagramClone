//
//  TabBarAssembly.swift
//  Instagram
//
//  Created by Admin on 15.01.2021.
//

import UIKit

enum TabBarAssembly {
    // MARK: Constants
    
    private enum Metrics {
        static let tabBarImageVerticalInset: CGFloat = 5.5
    }
    
    private enum Colors {
        static let tint = UIColor.black
    }
    
    private enum Images {
        static let homeUnselected = UIImage(named: "home_unselected")
        static let homeSelected = UIImage(named: "home_selected")
        
        static let searchUnselected = UIImage(named: "search_unselected")
        static let searchSelected = UIImage(named: "search_selected")
        
        static let plusUnselected = UIImage(named: "plus_unselected")
        
        static let likeUnselected = UIImage(named: "like_unselected")
        static let likeSelected = UIImage(named: "like_selected")
        
        static let profileUnselected = UIImage(named: "profile_unselected")
        static let profileSelected = UIImage(named: "profile_selected")
    }
    
    private enum TabBarItems {
        static let home = UITabBarItem(title: nil, image: Images.homeUnselected, selectedImage: Images.homeSelected)
        
        static let search = UITabBarItem(title: nil,
            image: Images.searchUnselected,
            selectedImage: Images.searchSelected)
        
        static let plus = UITabBarItem(title: nil, image: Images.plusUnselected, selectedImage: nil)
        static let like = UITabBarItem(title: nil, image: Images.likeUnselected, selectedImage: Images.likeSelected)
        
        static let profile = UITabBarItem(title: nil,
            image: Images.profileUnselected,
            selectedImage: Images.profileSelected)
    }
    
    private enum TabBarItemIndex: Int {
        case home
        case search
        case plus
        case like
        case profile
    }
}

// MARK: - Public Methods

extension TabBarAssembly {
    static func createTabBarController() -> UITabBarController {
        let homeViewController = HomeAssembly.createHomeViewController()
        let homeTab = createNavigationController(viewController: homeViewController, tabBarItem: TabBarItems.home)
        
        let searchViewController = SearchAssembly.createSearchViewController()
        let searchTab = createNavigationController(viewController: searchViewController, tabBarItem: TabBarItems.search)
        
        let plusTab = createNavigationController(viewController: UIViewController(), tabBarItem: TabBarItems.plus)
        
        let likeTab = createNavigationController(viewController: UIViewController(), tabBarItem: TabBarItems.like)
        
        let profileViewController = ProfileAssembly.createProfileViewController()
        let profileTab = createNavigationController(
            viewController: profileViewController,
            tabBarItem: TabBarItems.profile)
        
        let tabBarController = TabBarController()
        
        tabBarController.tabBar.tintColor = Colors.tint
        tabBarController.viewControllers = [homeTab, searchTab, plusTab, likeTab, profileTab]
        
        tabBarController.shouldSelectViewController = { tabBarController, viewController in
            guard let index = tabBarController.viewControllers?.firstIndex(of: viewController) else { return true }
            
            if TabBarItemIndex(rawValue: index) == .plus {
                let newPostViewController = NewPostAssembly.createNewPostNavigationController()
                
                newPostViewController.modalPresentationStyle = .fullScreen

                tabBarController.present(newPostViewController, animated: true)

                return false
            }
            
            return true
        }
        
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
        navigationController.tabBarItem.imageInsets = UIEdgeInsets(
            top: Metrics.tabBarImageVerticalInset,
            left: 0,
            bottom: -Metrics.tabBarImageVerticalInset,
            right: 0)
        
        return navigationController
    }
}

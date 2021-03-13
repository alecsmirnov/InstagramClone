//
//  MainCoordinator.swift
//  Instagram
//
//  Created by Admin on 12.03.2021.
//

import UIKit

protocol TabBarCoordinatorProtocol: AnyObject {
    func showNewPostViewController()
}

final class MainCoordinator: Coordinator {
    // MARK: Properties
    
    var childCoordinators: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    // MARK: Lifecycle
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}

// MARK: - Interface

extension MainCoordinator {
    func start() {
        showMainTabBarController()
    }
}

// MARK: - Private Methods

private extension MainCoordinator {
    func showMainTabBarController() {
        let homeCoordinator = HomeCoordinator()
        let searchCoordinator = SearchCoordinator()
        let profileCoordinator = ProfileCoordinator()
        
        homeCoordinator.start()
        searchCoordinator.start()
        profileCoordinator.start()
  
        appendChildCoordinator(homeCoordinator)
        appendChildCoordinator(searchCoordinator)
        appendChildCoordinator(profileCoordinator)
        
        let mainTabBarController = MainTabBarController()
        
        mainTabBarController.appendNavigationController(homeCoordinator.navigationController, item: .home)
        mainTabBarController.appendNavigationController(searchCoordinator.navigationController, item: .search)
        mainTabBarController.appendNavigationController(UINavigationController(), item: .plus)
        mainTabBarController.appendNavigationController(UINavigationController(), item: .like)
        mainTabBarController.appendNavigationController(profileCoordinator.navigationController, item: .profile)
        
        mainTabBarController.didSelectPlusTabItem = { [weak self] in
            let newPostCoordinator = NewPostCoordinator(tabBarController: mainTabBarController)
            
            newPostCoordinator.start()
            
            self?.appendChildCoordinator(newPostCoordinator)
        }
        
        navigationController.pushViewController(mainTabBarController, animated: true)
    }
}

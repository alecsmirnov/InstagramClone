//
//  NewPostCoordinator.swift
//  Instagram
//
//  Created by Admin on 13.03.2021.
//

import UIKit

protocol NewPostCoordinatorProtocol: AnyObject {
    
}

final class NewPostCoordinator: Coordinator {
    // MARK: Properties
    
    var childCoordinators: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    private var tabBarController: UITabBarController?
    
    // MARK: Lifecycle
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    convenience init(tabBarController: UITabBarController?) {
        self.init(navigationController: UINavigationController())
        
        self.tabBarController = tabBarController
    }
}

// MARK: - Interface

extension NewPostCoordinator {
    func start() {
        let newPostViewController = NewPostAssembly.createNewPostNavigationController(coordinator: self)
        
        newPostViewController.modalPresentationStyle = .fullScreen

        tabBarController?.present(newPostViewController, animated: true)
    }
}

// MARK: - NewPostCoordinatorProtocol

extension NewPostCoordinator: NewPostCoordinatorProtocol {
    
}

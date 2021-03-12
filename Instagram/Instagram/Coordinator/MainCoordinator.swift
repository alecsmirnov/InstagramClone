//
//  MainCoordinator.swift
//  Instagram
//
//  Created by Admin on 12.03.2021.
//

import UIKit

protocol HomeCoordinatorProtocol: AnyObject {
    func closeTabBarController()
}

final class MainCoordinator: Coordinator {
    // MARK: Properties
    
    weak var delegate: CoordinatorDelegate?
    
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
        let tabBarController = TabBarAssembly.createTabBarController(coordinator: self)
        
        navigationController.pushViewController(tabBarController, animated: true)
    }
}

extension MainCoordinator: HomeCoordinatorProtocol {
    func closeTabBarController() {
        finish()
    }
}

//
//  HomeCoordinator.swift
//  Instagram
//
//  Created by Admin on 13.03.2021.
//

import UIKit

protocol HomeCoordinatorProtocol: AnyObject {
    
}

final class HomeCoordinator: Coordinator {
    // MARK: Properties
    
    var childCoordinators: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    // MARK: Lifecycle
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    convenience init() {
        self.init(navigationController: UINavigationController())
    }
}

// MARK: - Interface

extension HomeCoordinator {
    func start() {
        let homeViewController = HomeAssembly.createHomeViewController(coordinator: self)
        
        navigationController.pushViewController(homeViewController, animated: false)
    }
}

// MARK: - HomeCoordinatorProtocol

extension HomeCoordinator: HomeCoordinatorProtocol {
    
}

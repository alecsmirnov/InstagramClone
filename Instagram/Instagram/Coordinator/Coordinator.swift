//
//  Coordinator.swift
//  Instagram
//
//  Created by Admin on 12.03.2021.
//

import UIKit

protocol Coordinator: AnyObject {
    // MARK: Properties
        
    var childCoordinators: [Coordinator] { get set }
    
    var navigationController: UINavigationController { get set }
    
    // MARK: Lifecycle
    
    init(navigationController: UINavigationController)
    
    // MARK: Methods
    
    func start()
    func finish()
    
    func appendChildCoordinator(_ coordinator: Coordinator)
    func removeChildCoordinator(_ coordinator: Coordinator)
}

extension Coordinator {
    func finish() {
        childCoordinators.removeAll()
    }
    
    func appendChildCoordinator(_ coordinator: Coordinator) {
        if childCoordinators.firstIndex(where: { $0 === coordinator }) == nil {
            childCoordinators.append(coordinator)
        }
    }
    
    func removeChildCoordinator(_ coordinator: Coordinator) {
        if let index = childCoordinators.firstIndex(where: { $0 === coordinator }) {
            childCoordinators.remove(at: index)
        }
    }
    
    func removeAllChildCoordinators() {
        childCoordinators.removeAll()
    }
}

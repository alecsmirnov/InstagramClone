//
//  CoordinatorProtocol.swift
//  Instagram
//
//  Created by Admin on 12.03.2021.
//

import UIKit

protocol CoordinatorProtocol: AnyObject {
    // MARK: Properties
        
    var navigationController: UINavigationController { get set }
    var childCoordinators: [CoordinatorProtocol] { get set }
    
    // MARK: Lifecycle
    
    init(navigationController: UINavigationController)
    
    // MARK: Methods
    
    func start()
    func finish()
    
    func appendChildCoordinator(_ coordinator: CoordinatorProtocol)
    func removeChildCoordinator(_ coordinator: CoordinatorProtocol)
}

extension CoordinatorProtocol {
    func finish() {
        childCoordinators.removeAll()
    }
    
    func appendChildCoordinator(_ coordinator: CoordinatorProtocol) {
        if childCoordinators.firstIndex(where: { $0 === coordinator }) == nil {
            childCoordinators.append(coordinator)
        }
    }
    
    func removeChildCoordinator(_ coordinator: CoordinatorProtocol) {
        if let index = childCoordinators.firstIndex(where: { $0 === coordinator }) {
            childCoordinators.remove(at: index)
        }
    }
    
    func removeAllChildCoordinators() {
        childCoordinators.removeAll()
    }
}

//
//  AppCoordinator.swift
//  Instagram
//
//  Created by Admin on 12.03.2021.
//

import UIKit

final class AppCoordinator: Coordinator {
    // MARK: Properties
    
    weak var delegate: CoordinatorDelegate?
    
    var childCoordinators: [Coordinator] = []

    var navigationController: UINavigationController
    
    // MARK: Lifecycle
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        
        navigationController.setNavigationBarHidden(true, animated: false)
    }
    
    convenience init() {
        self.init(navigationController: UINavigationController())
    }
}

// MARK: - Interface

extension AppCoordinator {
    func start() {
        startAuthFlow()
        
        if FirebaseAuthService.isUserSignedIn {
            startMainFlow()
        }
    }
}

// MARK: - Private Methods

private extension AppCoordinator {
    func startAuthFlow() {
        let authCoordinator = AuthCoordinator(navigationController: navigationController)
        
        authCoordinator.delegate = self
        authCoordinator.start()
        
        appendChildCoordinator(authCoordinator)
    }

    func startMainFlow() {
        let mainCoordinator = MainCoordinator(navigationController: navigationController)
        
        mainCoordinator.delegate = self
        mainCoordinator.start()
        
        appendChildCoordinator(mainCoordinator)
    }
}

// MARK: - CoordinatorDelegate

extension AppCoordinator: CoordinatorDelegate {
    func coordinatorDidFinish(_ coordinator: Coordinator) {
        navigationController.popToRootViewController(animated: true)
    }
}

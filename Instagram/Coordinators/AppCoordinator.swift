//
//  AppCoordinator.swift
//  Instagram
//
//  Created by Admin on 12.03.2021.
//

import UIKit

final class AppCoordinator: CoordinatorProtocol {
    // MARK: Properties
    
    var navigationController: UINavigationController
    var childCoordinators: [CoordinatorProtocol] = []
    
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
        if FirebaseAuthService.isUserSignedIn {
            startMainFlow()
        } else {
            startAuthFlow()
        }
    }
}

// MARK: - Private Methods

private extension AppCoordinator {
    func startAuthFlow() {
        let authCoordinator = AuthCoordinator(navigationController: navigationController, delegate: self)
        
        authCoordinator.start()
        
        appendChildCoordinator(authCoordinator)
    }

    func startMainFlow() {
        let mainCoordinator = MainCoordinator(navigationController: navigationController, delegate: self)
        
        mainCoordinator.start()
        
        appendChildCoordinator(mainCoordinator)
    }
    
    func backToAuthFlow(from currentViewController: UIViewController) {
        FirebaseAuthService.signOut()
        
        removeAllChildCoordinators()
        
        let authCoordinator = AuthCoordinator(navigationController: navigationController, delegate: self)
        let loginViewController = LoginAssembly.createLoginViewController(coordinator: authCoordinator)
        
        appendChildCoordinator(authCoordinator)
        
        navigationController.viewControllers = [loginViewController, currentViewController]
        navigationController.popToViewController(loginViewController, animated: true)
    }
}

// MARK: - AuthCoordinatorDelegate

extension AppCoordinator: AuthCoordinatorDelegate {
    func authCoordinatorDidFinishAuthentication(_ authCoordinator: AuthCoordinator) {
        removeAllChildCoordinators()
        
        startMainFlow()
    }
}

// MARK: - MainCoordinatorDelegate

extension AppCoordinator: MainCoordinatorDelegate {
    func mainCoordinatorDidFinishWork(_ profileCoordinator: MainCoordinator, currentViewController: UIViewController) {
        backToAuthFlow(from: currentViewController)
    }
}

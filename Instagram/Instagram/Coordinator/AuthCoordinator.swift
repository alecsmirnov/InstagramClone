//
//  LoginCoordinator.swift
//  Instagram
//
//  Created by Admin on 12.03.2021.
//

import UIKit

protocol LoginCoordinatorProtocol: AnyObject {
    func showRegistrationViewController()
    func showTabBarController()
}

protocol RegistrationCoordinatorProtocol: AnyObject {
    func closeRegistrationViewController()
    func showTabBarController()
}

final class AuthCoordinator: Coordinator {
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

extension AuthCoordinator {
    func start() {
        let loginViewController = LoginAssembly.createLoginViewController(coordinator: self)
        
        navigationController.pushViewController(loginViewController, animated: false)
    }
}

// MARK: - LoginCoordinatorProtocol

extension AuthCoordinator: LoginCoordinatorProtocol {
    func showRegistrationViewController() {
        let registrationViewController = RegistrationAssembly.createRegistrationViewController(coordinator: self)
        
        navigationController.pushViewController(registrationViewController, animated: true)
    }
    
    func showTabBarController() {
        let mainCoordinator = MainCoordinator(navigationController: navigationController)
        
        mainCoordinator.delegate = delegate
        mainCoordinator.start()
        
        appendChildCoordinator(mainCoordinator)
    }
}

// MARK: - RegistrationCoordinatorProtocol

extension AuthCoordinator: RegistrationCoordinatorProtocol {
    func closeRegistrationViewController() {
        navigationController.popViewController(animated: true)
    }
}

//
//  LoginCoordinator.swift
//  Instagram
//
//  Created by Admin on 12.03.2021.
//

import UIKit

protocol LoginCoordinatorProtocol: AnyObject {
    func showRegistrationViewController()
    func finishLogIn()
}

protocol RegistrationCoordinatorProtocol: AnyObject {
    func closeRegistrationViewController()
    func finishSignUp()
}

protocol AuthCoordinatorDelegate: AnyObject {
    func authCoordinatorDidFinishAuthentication(_ authCoordinator: AuthCoordinator)
}

final class AuthCoordinator: CoordinatorProtocol {
    // MARK: Properties
    
    var navigationController: UINavigationController
    var childCoordinators: [CoordinatorProtocol] = []
    
    private weak var delegate: AuthCoordinatorDelegate?
    
    // MARK: Lifecycle
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    convenience init(navigationController: UINavigationController, delegate: AuthCoordinatorDelegate?) {
        self.init(navigationController: navigationController)
        
        self.delegate = delegate
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
    
    func finishLogIn() {
        delegate?.authCoordinatorDidFinishAuthentication(self)
    }
}

// MARK: - RegistrationCoordinatorProtocol

extension AuthCoordinator: RegistrationCoordinatorProtocol {
    func closeRegistrationViewController() {
        navigationController.popViewController(animated: true)
    }
    
    func finishSignUp() {
        delegate?.authCoordinatorDidFinishAuthentication(self)
    }
}

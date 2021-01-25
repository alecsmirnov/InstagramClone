//
//  LoginRouter.swift
//  Instagram
//
//  Created by Admin on 24.01.2021.
//

protocol ILoginRouter {
    func showRegistrationViewController()
    func showTabBarController()
}

final class LoginRouter {
    private weak var viewController: LoginViewController?
    
    init(viewController: LoginViewController) {
        self.viewController = viewController
    }
}

// MARK: - ILoginRouter

extension LoginRouter: ILoginRouter {
    func showRegistrationViewController() {
        let registrationViewController = RegistrationAssembly.createRegistrationViewController()
        
        registrationViewController.modalPresentationStyle = .custom
        registrationViewController.modalTransitionStyle = .crossDissolve
        
        viewController?.present(registrationViewController, animated: true)
    }
    
    func showTabBarController() {
        let tabBarController = TabBarAssembly.createTabBarController()
        
        RootViewControllerSwitcher.setRootViewController(tabBarController)
    }
}

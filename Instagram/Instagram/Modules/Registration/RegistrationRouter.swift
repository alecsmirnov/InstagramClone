//
//  RegistrationRouter.swift
//  Instagram
//
//  Created by Admin on 17.01.2021.
//

protocol IRegistrationRouter {
    func closeRegistrationViewController()
    
    func showTabBarController()
}

final class RegistrationRouter {
    private weak var viewController: RegistrationViewController?
    
    init(viewController: RegistrationViewController) {
        self.viewController = viewController
    }
}

// MARK: - IRegistrationRouter

extension RegistrationRouter: IRegistrationRouter {
    func closeRegistrationViewController() {        
        viewController?.dismiss(animated: true)
    }
    
    func showTabBarController() {
        let tabBarController = TabBarAssembly.createTabBarController()
        
        RootViewControllerSwitcher.setRootViewController(tabBarController)
    }
}

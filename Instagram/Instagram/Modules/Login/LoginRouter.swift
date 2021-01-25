//
//  LoginRouter.swift
//  Instagram
//
//  Created by Admin on 24.01.2021.
//

protocol ILoginRouter {
    func openRegistrationViewController()
}

final class LoginRouter {
    private weak var viewController: LoginViewController?
    
    init(viewController: LoginViewController) {
        self.viewController = viewController
    }
}

// MARK: - ILoginRouter

extension LoginRouter: ILoginRouter {
    func openRegistrationViewController() {
        let registrationViewController = RegistrationAssembly.createRegistrationViewController()
        
        registrationViewController.modalPresentationStyle = .fullScreen
        
        viewController?.present(registrationViewController, animated: false)
    }
}

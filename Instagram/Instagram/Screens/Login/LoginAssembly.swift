//
//  LoginAssembly.swift
//  Instagram
//
//  Created by Admin on 24.01.2021.
//

enum LoginAssembly {
    static func createLoginViewController(coordinator: LoginCoordinatorProtocol? = nil) -> LoginViewController {
        let viewController = LoginViewController()
        let presenter = LoginPresenter()
        
        viewController.output = presenter
        presenter.view = viewController
        presenter.coordinator = coordinator
        
        presenter.loginService = LoginService()
        
        return viewController
    }
}

//
//  LoginRouter.swift
//  Instagram
//
//  Created by Admin on 24.01.2021.
//

protocol ILoginRouter {
    
}

final class LoginRouter {
    private weak var viewController: LoginViewController?
    
    init(viewController: LoginViewController) {
        self.viewController = viewController
    }
}

extension LoginRouter: ILoginRouter {
    
}

//
//  RegistrationRouter.swift
//  Instagram
//
//  Created by Admin on 17.01.2021.
//

protocol IRegistrationRouter {
    
}

final class RegistrationRouter {
    private weak var viewController: RegistrationViewController?
    
    init(viewController: RegistrationViewController) {
        self.viewController = viewController
    }
}

extension RegistrationRouter: IRegistrationRouter {
    
}

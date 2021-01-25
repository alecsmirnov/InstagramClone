//
//  RegistrationRouter.swift
//  Instagram
//
//  Created by Admin on 17.01.2021.
//

protocol IRegistrationRouter {
    func closeRegistrationRouter()
}

final class RegistrationRouter {
    private weak var viewController: RegistrationViewController?
    
    init(viewController: RegistrationViewController) {
        self.viewController = viewController
    }
}

// MARK: - IRegistrationRouter

extension RegistrationRouter: IRegistrationRouter {
    func closeRegistrationRouter() {
        viewController?.dismiss(animated: false)
    }
}

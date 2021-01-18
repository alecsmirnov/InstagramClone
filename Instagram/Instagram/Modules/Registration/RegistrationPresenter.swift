//
//  RegistrationPresenter.swift
//  Instagram
//
//  Created by Admin on 17.01.2021.
//

protocol IRegistrationPresenter {
    func didPressSignUpButton(email: String?, fullName: String?, username: String?, password: String?)
    func didPressSignInButton()
}

final class RegistrationPresenter {
    weak var viewController: IRegistrationViewController?
    var interactor: IRegistrationInteractor?
    var router: IRegistrationRouter?
}

// MARK: - IRegistrationPresenter

extension RegistrationPresenter: IRegistrationPresenter {
    func didPressSignUpButton(email: String?, fullName: String?, username: String?, password: String?) {
        guard let email = email, !email.isEmpty,
              let password = password, !password.isEmpty else {
            return
        }
        
        // TODO: Email validation
        if email.count < 8 {
            viewController?.showEmailAlert()
        }
        
        // TODO: Password validation
        if password.count < 8 {
            viewController?.showPasswordAlert()
        }
    }
    
    func didPressSignInButton() {
        
    }
}

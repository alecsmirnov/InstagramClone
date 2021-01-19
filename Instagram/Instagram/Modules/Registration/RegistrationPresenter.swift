//
//  RegistrationPresenter.swift
//  Instagram
//
//  Created by Admin on 17.01.2021.
//

protocol IRegistrationPresenter {
    func emailDidChange(_ email: String?)
    func usernameDidChange(_ username: String?)
    func passwordDidChange(_ password: String?)
    
    func didPressSignUpButton(email: String?, fullName: String?, username: String?, password: String?)
    func didPressSignInButton()
}

final class RegistrationPresenter {
    // MARK: Properties
    
    weak var viewController: IRegistrationViewController?
    var interactor: IRegistrationInteractor?
    var router: IRegistrationRouter?
    
    private var isValidEmail = false
    private var isValidUsername: Bool?
    private var isValidPassword = false
}

// MARK: - IRegistrationPresenter

extension RegistrationPresenter: IRegistrationPresenter {
    func emailDidChange(_ email: String?) {
        guard let email = email else { return }
        
        isValidEmail = InputValidation.isValidEmail(email)

        if isValidEmail || email.isEmpty {
            viewController?.hideEmailAlert()
        } else {
            viewController?.showInvalidEmailAlert()
        }
        
        validateInput()
    }
    
    func usernameDidChange(_ username: String?) {
        guard let username = username else { return }

        isValidUsername = InputValidation.isValidUsername(username)
        
        if isValidUsername ?? false || username.isEmpty {
            viewController?.hideUsernameAlert()
        } else {
            viewController?.showInvalidUsernameAlert()
        }
        
        validateInput()
    }
    
    func passwordDidChange(_ password: String?) {
        isValidPassword = !(password?.isEmpty ?? true)
        
        validateInput()
    }
    
    func didPressSignUpButton(email: String?, fullName: String?, username: String?, password: String?) {
        
    }
    
    func didPressSignInButton() {
        
    }
}

// MARK: - Private Methods

private extension RegistrationPresenter {
    func validateInput() {
        if isValidEmail && isValidUsername ?? true && isValidPassword {
            viewController?.enableSignUpButton()
        } else {
            viewController?.disableSignUpButton()
        }
    }
}

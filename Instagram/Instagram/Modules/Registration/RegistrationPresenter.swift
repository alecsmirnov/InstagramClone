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
    
    func didPressSignUpButton(withInfo info: RegistrationInfo)
    func didPressSignInButton()
}

final class RegistrationPresenter {
    // MARK: Properties
    
    weak var viewController: IRegistrationViewController?
    var interactor: IRegistrationInteractor?
    var router: IRegistrationRouter?
    
    private var isValidEmail = false
    private var isValidUsername = false
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
        
        if isValidEmail {
            isValidEmail = false
            
            interactor?.isUserExist(withEmail: email)
        }
        
        validateInput()
    }
    
    func usernameDidChange(_ username: String?) {
        guard let username = username else { return }

        isValidUsername = InputValidation.isValidUsername(username)
        
        if isValidUsername || username.isEmpty {
            viewController?.hideUsernameAlert()
        } else {
            viewController?.showInvalidUsernameAlert()
        }
        
        if isValidUsername {
            isValidUsername = false
            
            interactor?.isUserExist(withUsername: username)
        }
        
        validateInput()
    }
    
    func passwordDidChange(_ password: String?) {
        guard let password = password else { return }
        
        isValidPassword = InputValidation.passwordLengthMin <= password.count
        
        if isValidPassword || password.isEmpty {
            viewController?.hidePasswordAlert()
        } else {
            viewController?.showShortPasswordAlert()
        }
        
        validateInput()
    }
    
    func didPressSignUpButton(withInfo info: RegistrationInfo) {
        interactor?.signUp(withInfo: info)
    }
    
    func didPressSignInButton() {
        
    }
}

// MARK: - IRegistrationInteractorOutput

extension RegistrationPresenter: IRegistrationInteractorOutput {
    func isUserWithEmailExist() {
        isValidEmail = false
        
        viewController?.showAlreadyInUseEmailAlert()
        
        validateInput()
    }
    
    func isUserWithEmailNotExist() {
        isValidEmail = true
        
        viewController?.hideEmailAlert()
        
        validateInput()
    }
    
    func isUserWithUsernameExist() {
        isValidUsername = false
        
        viewController?.showAlreadyInUseUsernameAlert()
        
        validateInput()
    }
    
    func isUserWithUsernameNotExist() {
        isValidUsername = true
        
        viewController?.hideUsernameAlert()
        
        validateInput()
    }
    
    func signUpSuccess() {
        
    }
    
    func signUpFailure() {
        
    }
}

// MARK: - Private Methods

private extension RegistrationPresenter {
    func validateInput() {
        if isValidEmail && isValidUsername && isValidPassword {
            viewController?.enableSignUpButton()
        } else {
            viewController?.disableSignUpButton()
        }
    }
}

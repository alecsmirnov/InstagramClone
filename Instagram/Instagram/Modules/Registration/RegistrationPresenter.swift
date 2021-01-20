//
//  RegistrationPresenter.swift
//  Instagram
//
//  Created by Admin on 17.01.2021.
//

protocol IRegistrationPresenter {
    func emailDidChange(_ email: String)
    func usernameDidChange(_ username: String)
    func passwordDidChange(_ password: String)
    
    func didPressSignUpButton(withInfo info: RegistrationInfo)
    func didPressSignInButton()
}

final class RegistrationPresenter {
    // MARK: Properties
    
    weak var viewController: IRegistrationViewController?
    var interactor: IRegistrationInteractor?
    var router: IRegistrationRouter?
    
    private var isEmailChecked = false
    private var isUsernameChecked = false
    private var isPasswordChecked = false
}

// MARK: - IRegistrationPresenter

extension RegistrationPresenter: IRegistrationPresenter {
    func emailDidChange(_ email: String) {
        interactor?.checkEmail(email)
    }
    
    func usernameDidChange(_ username: String) {
        interactor?.checkUsername(username)
    }
    
    func passwordDidChange(_ password: String) {
        interactor?.checkPassword(password)
    }
    
    func didPressSignUpButton(withInfo info: RegistrationInfo) {
        interactor?.signUp(withInfo: info)
    }
    
    func didPressSignInButton() {
        
    }
}

// MARK: - IRegistrationInteractorOutput

extension RegistrationPresenter: IRegistrationInteractorOutput {
    func isValidEmail() {
        isEmailChecked = true
        
        viewController?.hideEmailAlert()
        
        validateInput()
    }
    
    func isInvalidEmail() {
        isEmailChecked = false
        
        viewController?.showInvalidEmailAlert()
        
        validateInput()
    }
    
    func isUserWithEmailExist() {
        isEmailChecked = false
        
        viewController?.showAlreadyInUseEmailAlert()
        
        validateInput()
    }
    
    func isEmptyEmail() {
        isEmailChecked = false
        
        viewController?.hideEmailAlert()
        
        validateInput()
    }
    
    func isValidUsername() {
        isUsernameChecked = true
        
        viewController?.hideUsernameAlert()
        
        validateInput()
    }
    
    func isInvalidUsername() {
        isUsernameChecked = false
        
        viewController?.showInvalidUsernameAlert()
        
        validateInput()
    }
    
    func isUserWithUsernameExist() {
        isUsernameChecked = false
        
        viewController?.showAlreadyInUseUsernameAlert()
        
        validateInput()
    }
    
    func isEmptyUsername() {
        isUsernameChecked = false
        
        viewController?.hideUsernameAlert()
        
        validateInput()
    }
    
    func isValidPassword() {
        isPasswordChecked = true
        
        viewController?.hidePasswordAlert()
        
        validateInput()
    }
    
    func isInvalidPassword() {
        isPasswordChecked = false
        
        viewController?.showShortPasswordAlert()
        
        validateInput()
    }
    
    func isEmptyPassword() {
        isPasswordChecked = false
        
        viewController?.hidePasswordAlert()
        
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
        if isEmailChecked && isUsernameChecked && isPasswordChecked {
            viewController?.enableSignUpButton()
        } else {
            viewController?.disableSignUpButton()
        }
    }
}

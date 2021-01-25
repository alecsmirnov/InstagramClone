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
    
    func didPressSignUpButton(withInfo info: Registration)
    func didPressLogInButton()
}

final class RegistrationPresenter {
    // MARK: Properties
    
    weak var viewController: IRegistrationViewController?
    var interactor: IRegistrationInteractor?
    var router: IRegistrationRouter?
    
    private var isEmailChecked = false {
        didSet { validateInput() }
    }
    
    private var isUsernameChecked = false {
        didSet { validateInput() }
    }
    
    private var isPasswordChecked = false {
        didSet { validateInput() }
    }
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
    
    func didPressSignUpButton(withInfo info: Registration) {
        interactor?.signUp(withInfo: info)
    }
    
    func didPressLogInButton() {
        router?.closeRegistrationViewController()
    }
}

// MARK: - IRegistrationInteractorOutput

extension RegistrationPresenter: IRegistrationInteractorOutput {
    func isValidEmail() {
        isEmailChecked = true
        
        viewController?.hideEmailAlert()
    }
    
    func isInvalidEmail() {
        isEmailChecked = false
        
        viewController?.showInvalidEmailAlert()
    }
    
    func isUserWithEmailExist() {
        isEmailChecked = false
        
        viewController?.showAlreadyInUseEmailAlert()
    }
    
    func isEmptyEmail() {
        isEmailChecked = false
        
        viewController?.hideEmailAlert()
    }
    
    func isValidUsername() {
        isUsernameChecked = true
        
        viewController?.hideUsernameAlert()
    }
    
    func isInvalidUsername() {
        isUsernameChecked = false
        
        viewController?.showInvalidUsernameAlert()
    }
    
    func isUserWithUsernameExist() {
        isUsernameChecked = false
        
        viewController?.showAlreadyInUseUsernameAlert()
    }
    
    func isEmptyUsername() {
        isUsernameChecked = false
        
        viewController?.hideUsernameAlert()
    }
    
    func isValidPassword() {
        isPasswordChecked = true
        
        viewController?.hidePasswordAlert()
    }
    
    func isInvalidPassword(lengthMin: Int) {
        isPasswordChecked = false
        
        viewController?.showShortPasswordAlert(lengthMin: lengthMin)
    }
    
    func isEmptyPassword() {
        isPasswordChecked = false
        
        viewController?.hidePasswordAlert()
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

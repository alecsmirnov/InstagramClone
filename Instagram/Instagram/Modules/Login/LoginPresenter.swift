//
//  LoginPresenter.swift
//  Instagram
//
//  Created by Admin on 24.01.2021.
//

protocol ILoginPresenter {
    func didPressLogInButton(withEmail email: String, password: String)
    func didPressSignUpButton()
    
    func emailDidChange(_ email: String)
    func passwordDidChange(_ password: String)
}

final class LoginPresenter {
    // MARK: Properties
    
    weak var viewController: ILoginViewController?
    var interactor: ILoginInteractor?
    var router: ILoginRouter?
    
    private var isEmailChecked = false {
        didSet { validateInput() }
    }
    
    private var isPasswordChecked = false {
        didSet { validateInput() }
    }
}

// MARK: - ILoginPresenter

extension LoginPresenter: ILoginPresenter {
    func didPressLogInButton(withEmail email: String, password: String) {
        interactor?.signIn(withEmail: email, password: password)
    }
    
    func didPressSignUpButton() {
        router?.showRegistrationViewController()
    }
    
    func emailDidChange(_ email: String) {
        interactor?.checkEmail(email)
    }
    
    func passwordDidChange(_ password: String) {
        interactor?.checkPassword(password)
    }
}

// MARK: - ILoginInteractorOutput

extension LoginPresenter: ILoginInteractorOutput {
    func isValidEmail() {
        isEmailChecked = true
        
        viewController?.hideEmailAlert()
    }
    
    func isInvalidEmail() {
        isEmailChecked = false
        
        viewController?.showInvalidEmailAlert()
    }

    func isEmptyEmail() {
        isEmailChecked = false
        
        viewController?.hideEmailAlert()
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
    
    func signInSuccess() {
        router?.showTabBarController()
    }
    
    func signInIncorrectUserFailure() {
        viewController?.showIncorrectUserAlert()
    }
    
    func signInIncorrectPasswordFailure() {
        viewController?.showIncorrectPasswordAlert()
    }
}

// MARK: - Private Methods

private extension LoginPresenter {
    func validateInput() {
        if isEmailChecked && isPasswordChecked {
            viewController?.enableLogInButton()
        } else {
            viewController?.disableLogInButton()
        }
    }
}

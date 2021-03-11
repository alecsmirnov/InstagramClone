//
//  LoginPresenter.swift
//  Instagram
//
//  Created by Admin on 24.01.2021.
//

final class LoginPresenter {
    // MARK: Properties
    
    weak var view: ILoginView?
    var interactor: ILoginInteractor?
    var router: ILoginRouter?
    
    private var isEmailChecked = false {
        didSet { validateInput() }
    }
    
    private var isPasswordChecked = false {
        didSet { validateInput() }
    }
}

// MARK: - ILoginViewOutput

extension LoginPresenter: ILoginViewOutput {
    func viewDidLoad() {
        view?.disableLogInButton()
    }
    
    func didPressLogInButton(withEmail email: String, password: String) {
        view?.isUserInteractionEnabled = false
        view?.disableLogInButton()
        view?.startAnimatingLogInButton()
        
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
        
        view?.hideEmailWarning()
    }
    
    func isInvalidEmail() {
        isEmailChecked = false
        
        view?.showInvalidEmailWarning()
    }

    func isEmptyEmail() {
        isEmailChecked = false
        
        view?.hideEmailWarning()
    }
    
    func isValidPassword() {
        isPasswordChecked = true
        
        view?.hidePasswordWarning()
    }
    
    func isInvalidPassword(lengthMin: Int) {
        isPasswordChecked = false
        
        view?.showShortPasswordWarning(lengthMin: lengthMin)
    }
    
    func isEmptyPassword() {
        isPasswordChecked = false
        
        view?.hidePasswordWarning()
    }
    
    func signInSuccess() {
        router?.showTabBarController()
    }
    
    func signInIncorrectUserFailure() {
        view?.stopAnimatingLogInButton()
        view?.isUserInteractionEnabled = true
        view?.showIncorrectUserAlert()
    }
    
    func signInIncorrectPasswordFailure() {
        view?.stopAnimatingLogInButton()
        view?.isUserInteractionEnabled = true
        view?.showIncorrectPasswordAlert()
    }
}

// MARK: - Private Methods

private extension LoginPresenter {
    func validateInput() {
        if isEmailChecked && isPasswordChecked {
            view?.enableLogInButton()
        } else {
            view?.disableLogInButton()
        }
    }
}

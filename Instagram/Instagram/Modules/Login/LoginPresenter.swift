//
//  LoginPresenter.swift
//  Instagram
//
//  Created by Admin on 24.01.2021.
//

final class LoginPresenter {
    weak var view: LoginViewControllerProtocol?
    weak var coordinator: LoginCoordinatorProtocol?
    
    var loginService: LoginServiceProtocol?
    
    private var isEmailChecked = false {
        didSet {
            validateInput()
        }
    }
    
    private var isPasswordChecked = false {
        didSet {
            validateInput()
        }
    }
}

// MARK: - LoginView Output

extension LoginPresenter: LoginViewControllerOutputProtocol {
    func viewDidLoad() {
        view?.disableLogInButton()
    }
    
    func didPressLogInButton(withEmail email: String, password: String) {
        view?.isUserInteractionEnabled = false
        view?.disableLogInButton()
        view?.startAnimatingLogInButton()
        
        loginService?.signIn(withEmail: email, password: password) { [weak self] error in
            if let error = error {
                self?.view?.stopAnimatingLogInButton()
                self?.view?.isUserInteractionEnabled = true
                
                switch error {
                case .userNotFound:
                    self?.view?.showIncorrectUserAlert()
                case .wrongPassword:
                    self?.view?.showIncorrectPasswordAlert()
                }
            } else {
                self?.coordinator?.showTabBarController()
            }
        }
    }
    
    func didPressSignUpButton() {
        coordinator?.showRegistrationViewController()
    }
    
    func emailDidChange(_ email: String) {
        loginService?.checkEmail(email) { [weak self] error in
            if let error = error {
                self?.isEmailChecked = false
                
                switch error {
                case .empty:
                    self?.view?.hideEmailWarning()
                case .invalid:
                    self?.view?.showInvalidEmailWarning()
                }
            } else {
                self?.isEmailChecked = true
                
                self?.view?.hideEmailWarning()
            }
        }
    }
    
    func passwordDidChange(_ password: String) {
        loginService?.checkPassword(password) { [weak self] error in
            if let error = error {
                self?.isPasswordChecked = false
                
                switch error {
                case .empty:
                    self?.view?.hidePasswordWarning()
                case .invalid(let lengthMin):
                    self?.view?.showShortPasswordWarning(lengthMin: lengthMin)
                }
            } else {
                self?.isPasswordChecked = true
                
                self?.view?.hidePasswordWarning()
            }
        }
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

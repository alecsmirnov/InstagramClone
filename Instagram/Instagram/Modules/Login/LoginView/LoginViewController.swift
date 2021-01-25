//
//  LoginViewController.swift
//  Instagram
//
//  Created by Admin on 24.01.2021.
//

import UIKit

protocol ILoginViewController: AnyObject {
    func showInvalidEmailAlert()
    func hideEmailAlert()
    
    func showShortPasswordAlert(lengthMin: Int)
    func hidePasswordAlert()
    
    func showIncorrectUserAlert()
    func showIncorrectPasswordAlert()
    
    func enableLogInButton()
    func disableLogInButton()
}

final class LoginViewController: CustomViewController<LoginView> {
    // MARK: Properties
    
    var presenter: ILoginPresenter?
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customView?.delegate = self
    }
}

// MARK: - ILoginViewController

extension LoginViewController: ILoginViewController {
    func showInvalidEmailAlert() {
        customView?.showEmailAlertLabel(text: "Invalid Email address")
    }
    
    func hideEmailAlert() {
        customView?.hideEmailAlertLabel()
    }
    
    func showShortPasswordAlert(lengthMin: Int) {
        customView?.showPasswordAlertLabel(text: "Password must be \(lengthMin) or more characters")
    }
    
    func hidePasswordAlert() {
        customView?.hidePasswordAlertLabel()
    }
    
    func showIncorrectUserAlert() {
        customView?.showSimpleAlert(
            title: "Incorrect User",
            text: "The email you entered doesn't belong to an account. Please check your email and try again")
    }
    
    func showIncorrectPasswordAlert() {
        customView?.showSimpleAlert(
            title: "Incorrect Password",
            text: "Sorry, your password was incorrect. Please double-check your password and try again")
    }
    
    func enableLogInButton() {
        customView?.enableLogInButton()
    }
    
    func disableLogInButton() {
        customView?.disableLogInButton()
    }
}

// MARK: - LoginViewDelegate

extension LoginViewController: LoginViewDelegate {
    func loginViewDidPressLogInButton(_ registrationView: LoginView, withEmail email: String, password: String) {
        presenter?.didPressLogInButton(withEmail: email, password: password)
    }
    
    func loginViewDidPressSignUpButton(_ registrationView: LoginView) {
        presenter?.didPressSignUpButton()
    }
    
    func loginViewEmailDidChange(_ registrationView: LoginView, email: String) {
        presenter?.emailDidChange(email)
    }
    
    func loginViewPasswordDidChange(_ registrationView: LoginView, password: String) {
        presenter?.passwordDidChange(password)
    }
}

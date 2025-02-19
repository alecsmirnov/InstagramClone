//
//  LoginViewController.swift
//  Instagram
//
//  Created by Admin on 24.01.2021.
//

import UIKit

protocol LoginViewControllerProtocol: AnyObject {
    var isUserInteractionEnabled: Bool { get set }
    
    func showInvalidEmailWarning()
    func hideEmailWarning()
    
    func showShortPasswordWarning(lengthMin: Int)
    func hidePasswordWarning()
    
    func showIncorrectUserAlert()
    func showIncorrectPasswordAlert()
    
    func enableLogInButton()
    func disableLogInButton()
    
    func startAnimatingLogInButton()
    func stopAnimatingLogInButton()
}

protocol LoginViewControllerOutputProtocol: AnyObject {
    func viewDidLoad()
    
    func didPressLogInButton(withEmail email: String, password: String)
    func didPressSignUpButton()
    
    func emailDidChange(_ email: String)
    func passwordDidChange(_ password: String)
}

final class LoginViewController: CustomViewController<LoginView> {
    // MARK: Properties
    
    var output: LoginViewControllerOutputProtocol?
    
    private lazy var alertController = SimpleAlert(presentationController: self)
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customView?.output = self
        output?.viewDidLoad()
    }
}

// MARK: - LoginViewController Interface

extension LoginViewController: LoginViewControllerProtocol {
    var isUserInteractionEnabled: Bool {
        get {
            return customView?.isUserInteractionEnabled ?? false
        }
        set {
            customView?.isUserInteractionEnabled = newValue
        }
    }
    
    func showInvalidEmailWarning() {
        customView?.showEmailWarning(text: "Invalid Email address")
    }
    
    func hideEmailWarning() {
        customView?.hideEmailWarning()
    }
    
    func showShortPasswordWarning(lengthMin: Int) {
        customView?.showPasswordWarning(text: "Password must be \(lengthMin) or more characters")
    }
    
    func hidePasswordWarning() {
        customView?.hidePasswordWarning()
    }
    
    func showIncorrectUserAlert() {
        alertController.showAlert(
            title: "Incorrect User",
            message: "The email you entered doesn't belong to an account. Please check your email and try again")
    }
    
    func showIncorrectPasswordAlert() {
        alertController.showAlert(
            title: "Incorrect Password",
            message: "Sorry, your password was incorrect. Please double-check your password and try again")
    }
    
    func enableLogInButton() {
        customView?.enableLogInButton()
    }
    
    func disableLogInButton() {
        customView?.disableLogInButton()
    }
    
    func startAnimatingLogInButton() {
        customView?.startAnimatingLogInButton()
    }
    
    func stopAnimatingLogInButton() {
        customView?.stopAnimatingLogInButton()
    }
}

// MARK: - LoginView Output

extension LoginViewController: LoginViewOutputProtocol {
    func didTapLogInButton(withEmail email: String, password: String) {
        output?.didPressLogInButton(withEmail: email, password: password)
    }
    
    func didTapSignUpButton() {
        output?.didPressSignUpButton()
    }
    
    func emailDidChange(_ email: String) {
        output?.emailDidChange(email)
    }
    
    func passwordDidChange(_ password: String) {
        output?.passwordDidChange(password)
    }
}

//
//  LoginViewController.swift
//  Instagram
//
//  Created by Admin on 24.01.2021.
//

import UIKit

protocol ILoginView: AnyObject {
    var isUserInteractionEnabled: Bool { get set }
    
    func showInvalidEmailAlert()
    func hideEmailAlert()
    
    func showShortPasswordAlert(lengthMin: Int)
    func hidePasswordAlert()
    
    func showIncorrectUserAlert()
    func showIncorrectPasswordAlert()
    
    func enableLogInButton()
    func disableLogInButton()
    
    func startAnimatingLogInButton()
    func stopAnimatingLogInButton()
}

protocol ILoginViewOutput: AnyObject {
    func viewDidLoad()
    
    func didPressLogInButton(withEmail email: String, password: String)
    func didPressSignUpButton()
    
    func emailDidChange(_ email: String)
    func passwordDidChange(_ password: String)
}

final class LoginViewController: CustomViewController<LoginView> {
    // MARK: Properties
    
    var output: ILoginViewOutput?
    
    private lazy var alertController = SimpleAlert(presentationController: self)
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customView?.output = self
        output?.viewDidLoad()
    }
}

// MARK: - Custom View Output

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

// MARK: - Login View Input

extension LoginViewController: ILoginView {
    var isUserInteractionEnabled: Bool {
        get {
            return customView?.isUserInteractionEnabled ?? false
        }
        set {
            customView?.isUserInteractionEnabled = newValue
        }
    }
    
    func showInvalidEmailAlert() {
        customView?.showEmailWarning(text: "Invalid Email address")
    }
    
    func hideEmailAlert() {
        customView?.hideEmailWarning()
    }
    
    func showShortPasswordAlert(lengthMin: Int) {
        customView?.showPasswordWarning(text: "Password must be \(lengthMin) or more characters")
    }
    
    func hidePasswordAlert() {
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

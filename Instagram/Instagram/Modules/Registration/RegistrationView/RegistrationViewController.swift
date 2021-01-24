//
//  RegistrationViewController.swift
//  Instagram
//
//  Created by Admin on 17.01.2021.
//

import UIKit

protocol IRegistrationViewController: AnyObject {
    func showInvalidEmailAlert()
    func showAlreadyInUseEmailAlert()
    func hideEmailAlert()
    
    func showInvalidUsernameAlert()
    func showAlreadyInUseUsernameAlert()
    func hideUsernameAlert()
    
    func showShortPasswordAlert(lengthMin: Int)
    func hidePasswordAlert()
    
    func enableSignUpButton()
    func disableSignUpButton()
}

final class RegistrationViewController: CustomViewController<RegistrationView> {
    // MARK: Properties
    
    var presenter: IRegistrationPresenter?
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customView?.delegate = self
    }
}

// MARK: - IRegistrationViewController

extension RegistrationViewController: IRegistrationViewController {
    func showInvalidEmailAlert() {
        customView?.showEmailAlertLabel(text: "Invalid Email address")
    }
    
    func showAlreadyInUseEmailAlert() {
        customView?.showEmailAlertLabel(text: "Email address already in use")
    }
    
    func hideEmailAlert() {
        customView?.hideEmailAlertLabel()
    }
    
    func showInvalidUsernameAlert() {
        customView?.showUsernameAlertLabel(text: "Invalid Username")
    }
    
    func showAlreadyInUseUsernameAlert() {
        customView?.showUsernameAlertLabel(text: "Username already in use")
    }
    
    func hideUsernameAlert() {
        customView?.hideUsernameAlertLabel()
    }
    
    func showShortPasswordAlert(lengthMin: Int) {
        customView?.showPasswordAlertLabel(text: "Password must be \(lengthMin) or more characters")
    }
    
    func hidePasswordAlert() {
        customView?.hidePasswordAlertLabel()
    }
    
    func enableSignUpButton() {
        customView?.enableSignUpButton()
    }
    
    func disableSignUpButton() {
        customView?.disableSignUpButton()
    }
}

// MARK: - RegistrationViewDelegate

extension RegistrationViewController: RegistrationViewDelegate {    
    func registrationViewDidPressSignUpButton(_ registrationView: RegistrationView, withInfo info: Registration) {
        presenter?.didPressSignUpButton(withInfo: info)
    }
    
    func registrationViewDidPressSignInButton(_ registrationView: RegistrationView) {
        presenter?.didPressSignInButton()
    }
    
    func registrationViewEmailDidChange(_ registrationView: RegistrationView, email: String) {
        presenter?.emailDidChange(email)
    }
    
    func registrationViewUsernameDidChange(_ registrationView: RegistrationView, username: String) {
        presenter?.usernameDidChange(username)
    }
    
    func registrationViewPasswordDidChange(_ registrationView: RegistrationView, password: String) {
        presenter?.passwordDidChange(password)
    }
}

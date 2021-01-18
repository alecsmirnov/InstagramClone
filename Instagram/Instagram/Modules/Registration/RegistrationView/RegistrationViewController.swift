//
//  RegistrationViewController.swift
//  Instagram
//
//  Created by Admin on 17.01.2021.
//

import UIKit

protocol IRegistrationViewController: AnyObject {
    func showEmailAlert()
    func showPasswordAlert()
}

final class RegistrationViewController: CustomViewController<RegistrationView> {
    // MARK: Properties
    
    var presenter: IRegistrationPresenter?
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewDelegates()
    }
}

// MARK: - Private Methods

private extension RegistrationViewController {
    func setupViewDelegates() {
        customView?.delegate = self
    }
}

// MARK: - IRegistrationViewController

extension RegistrationViewController: IRegistrationViewController {
    func showEmailAlert() {
        customView?.showEmailAlertLabel(text: "Invalid email address")
    }
    
    func showPasswordAlert() {
        customView?.showPasswordAlertLabel(text: "Short password")
    }
}

// MARK: - RegistrationViewDelegate

extension RegistrationViewController: RegistrationViewDelegate {
    func registrationViewDidPressSignUpButton(_ registrationView: RegistrationView) {
        presenter?.didPressSignUpButton(email: registrationView.email,
                                        fullName: registrationView.fullName,
                                        username: registrationView.username,
                                        password: registrationView.password)
    }
    
    func registrationViewDidPressSignInButton(_ registrationView: RegistrationView) {
        presenter?.didPressSignInButton()
    }
}

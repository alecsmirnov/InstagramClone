//
//  LoginViewController.swift
//  Instagram
//
//  Created by Admin on 24.01.2021.
//

import UIKit

protocol ILoginViewController: AnyObject {
    
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
    
}

// MARK: - LoginViewDelegate

extension LoginViewController: LoginViewDelegate {
    func loginViewDidPressLogInButton(_ registrationView: LoginView, withEmail email: String, password: String) {
        
    }
    
    func loginViewDidPressSignUpButton(_ registrationView: LoginView) {
        presenter?.didPressSignUpButton()
    }
    
    func loginViewEmailDidChange(_ registrationView: LoginView, email: String) {
        
    }
    
    func loginViewPasswordDidChange(_ registrationView: LoginView, password: String) {
        
    }
}

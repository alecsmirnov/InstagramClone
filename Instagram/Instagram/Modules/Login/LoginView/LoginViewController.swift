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
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - ILoginViewController

extension LoginViewController: ILoginViewController {
    
}

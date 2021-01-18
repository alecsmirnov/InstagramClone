//
//  RegistrationViewController.swift
//  Instagram
//
//  Created by Admin on 17.01.2021.
//

import UIKit

protocol IRegistrationViewController: AnyObject {
    
}

final class RegistrationViewController: CustomViewController<RegistrationView> {
    // MARK: Properties
    
    var odd = true
    
    var presenter: IRegistrationPresenter?
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customView?.delegate = self
    }
}

// MARK: - IRegistrationViewController

extension RegistrationViewController: IRegistrationViewController {
    
}

// MARK: - RegistrationViewDelegate

extension RegistrationViewController: RegistrationViewDelegate {
    func registrationViewDidPressSignUpButton(_ registrationView: RegistrationView) {
        if odd {
            registrationView.showEmailAlertLabel(text: "This is my error!")
        } else {
            registrationView.hideEmailAlertLabel()
        }
        
        odd.toggle()
    }
    
    func registrationViewDidPressSignInButton(_ registrationView: RegistrationView) {
        
    }
}

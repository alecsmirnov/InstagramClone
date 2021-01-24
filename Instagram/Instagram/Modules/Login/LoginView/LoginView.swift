//
//  LoginView.swift
//  Instagram
//
//  Created by Admin on 24.01.2021.
//

import UIKit

protocol LoginViewDelegate: AnyObject {
    
}

final class LoginView: UIView {
    // MARK: Properties
    
    weak var delegate: LoginViewDelegate?
    
    // MARK: Initialization
    
    init() {
        super.init(frame: .zero)
        
        setupAppearance()
        setupLayout()
//        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Appearance

private extension LoginView {
    func setupAppearance() {
        backgroundColor = .systemBackground
    }
}

// MARK: - Layout

private extension LoginView {
    func setupLayout() {
        
    }
}

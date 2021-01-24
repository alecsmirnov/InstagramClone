//
//  LoginView.swift
//  Instagram
//
//  Created by Admin on 24.01.2021.
//

import UIKit

protocol LoginViewDelegate: AnyObject {
    func registrationViewDidPressSignInButton(_ registrationView: RegistrationView, withInfo info: String)
    func registrationViewDidPressSignUpButton(_ registrationView: RegistrationView)
}

final class LoginView: UIView {
    // MARK: Properties
    
    weak var delegate: LoginViewDelegate?
    
    // MARK: Subviews
    
    private let scrollView = UIScrollView()
    private let screenView = UIView()
    
    private let logoImageView = UIImageView()
    private let stackView = UIStackView()
    private let emailTextField = UITextField()
    private let passwordTextField = UITextField()
    private let signInButton = UIButton(type: .system)
    
    private lazy var emailAlertLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: LoginRegistrationConstants.Metrics.alertFontSize)
        label.textColor = LoginRegistrationConstants.Colors.alert
        
        return label
    }()
    
    private let passwordAlertLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: LoginRegistrationConstants.Metrics.alertFontSize)
        label.textColor = LoginRegistrationConstants.Colors.alert
        
        return label
    }()
    
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

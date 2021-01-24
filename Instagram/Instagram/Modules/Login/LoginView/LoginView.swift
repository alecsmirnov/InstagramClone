//
//  LoginView.swift
//  Instagram
//
//  Created by Admin on 24.01.2021.
//

import UIKit

protocol LoginViewDelegate: AnyObject {
    func registrationViewDidPressSignInButton(
        _ registrationView: RegistrationView,
        withEmail email: String,
        password: String)
    func registrationViewDidPressSignUpButton(_ registrationView: RegistrationView)
    
    func registrationViewEmailDidChange(_ registrationView: RegistrationView, email: String)
    func registrationViewPasswordDidChange(_ registrationView: RegistrationView, password: String)
}

final class LoginView: UIView {
    // MARK: Properties
    
    weak var delegate: LoginViewDelegate?
    
    // MARK: Subviews
    
    private let scrollView = UIScrollView()
    private let screenView = UIView()
    
    private let contentView = UIView()
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
        
        setupScrollViewAppearance()
        setupLogoImageViewAppearance()
        setupStackViewAppearance()
    }
    
    func setupScrollViewAppearance() {
        scrollView.delaysContentTouches = false
    }
    
    func setupLogoImageViewAppearance() {
        logoImageView.image = LoginRegistrationConstants.Images.logoBlack
        logoImageView.contentMode = .scaleAspectFit
    }
    
    func setupStackViewAppearance() {
        stackView.axis = .vertical
        stackView.alignment = .fill
        
        LoginView.setupStackViewTextFieldAppearance(
            emailTextField,
            placeholder: LoginRegistrationConstants.TextFieldPlaceholders.email)
        LoginView.setupStackViewTextFieldAppearance(
            passwordTextField,
            placeholder: LoginRegistrationConstants.TextFieldPlaceholders.password)
        
        setupStackViewSignUpButtonAppearance()
    }
    
    func setupStackViewSignUpButtonAppearance() {
        signInButton.setTitle(LoginRegistrationConstants.ButtonTitles.signIn, for: .normal)
        signInButton.setTitleColor(LoginRegistrationConstants.Colors.mainButtonTitle, for: .normal)
        signInButton.titleLabel?.font = .boldSystemFont(ofSize: LoginRegistrationConstants.Metrics.fontSize)
        signInButton.backgroundColor = LoginRegistrationConstants.Colors.mainButtonBackground
        signInButton.layer.cornerRadius = LoginRegistrationConstants.Metrics.mainButtonCornerRadius
        
        //disableSignInButton()
    }
}

// MARK: - Appearance Helpers

private extension LoginView {
    static func setupStackViewTextFieldAppearance(_ textField: UITextField, placeholder: String) {
        textField.placeholder = placeholder
        textField.borderStyle = .roundedRect
        textField.backgroundColor = LoginRegistrationConstants.Colors.textFieldBackground
        textField.font = .systemFont(ofSize: LoginRegistrationConstants.Metrics.fontSize)
        textField.clearButtonMode = .whileEditing
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
    }
}

// MARK: - Layout

private extension LoginView {
    func setupLayout() {
        setupSubviews()
        
        setupScrollViewLayout()
        setupScreenViewLayout()
        setupContentViewLayout()
        setupLogoImageViewLayout()
        setupStackViewLayout()
    }
    
    func setupSubviews() {
        addSubview(scrollView)
        
        scrollView.addSubview(screenView)
        screenView.addSubview(contentView)
        
        contentView.addSubview(logoImageView)
        contentView.addSubview(stackView)
        
        stackView.addArrangedSubview(emailTextField)
        stackView.addArrangedSubview(passwordTextField)
        stackView.addArrangedSubview(signInButton)
    }
    
    func setupScrollViewLayout() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
    func setupScreenViewLayout() {
        screenView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            screenView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            screenView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            screenView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            screenView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            screenView.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor),
        ])
    }
    
    func setupContentViewLayout() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentView.centerYAnchor.constraint(
                equalTo: screenView.centerYAnchor,
                constant: -LoginRegistrationConstants.Metrics.profileImageButtonSize / 2),
            contentView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
    func setupLogoImageViewLayout() {
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            logoImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalTo: stackView.widthAnchor),
        ])
    }
    
    func setupStackViewLayout() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(
                equalTo: logoImageView.bottomAnchor,
                constant: LoginRegistrationConstants.Metrics.stackViewTopSpace),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            stackView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: LoginRegistrationConstants.Metrics.stackViewHorizontalSpace),
            stackView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -LoginRegistrationConstants.Metrics.stackViewHorizontalSpace),
        ])
        
        stackView.spacing = LoginRegistrationConstants.Metrics.stackViewSpace
        stackView.setCustomSpacing(
            LoginRegistrationConstants.Metrics.stackViewPasswordTextFieldSpace,
            after: passwordTextField)
        
        let stackViewSubviewHeight = LoginRegistrationConstants.Metrics.stackViewSubviewHeight
        
        LoginView.setupStackViewSubviewLayout(emailTextField, height: stackViewSubviewHeight)
        LoginView.setupStackViewSubviewLayout(passwordTextField, height: stackViewSubviewHeight)
        LoginView.setupStackViewSubviewLayout(signInButton, height: stackViewSubviewHeight)
        
        passwordTextField.isSecureTextEntry = true
    }
}

// MARK: - Layout Helpers

private extension LoginView {
    static func setupStackViewSubviewLayout(_ subview: UIView, height: CGFloat) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        
        subview.heightAnchor.constraint(equalToConstant: height).isActive = true
    }
}

//
//  LoginView.swift
//  Instagram
//
//  Created by Admin on 24.01.2021.
//

import UIKit

protocol LoginViewDelegate: AnyObject {
    func loginViewDidPressLogInButton(_ registrationView: LoginView, withEmail email: String, password: String)
    func loginViewDidPressSignUpButton(_ registrationView: LoginView)
    
    func loginViewEmailDidChange(_ registrationView: LoginView, email: String)
    func loginViewPasswordDidChange(_ registrationView: LoginView, password: String)
}

final class LoginView: LoginRegistrationBaseView {
    // MARK: Properties
    
    weak var delegate: LoginViewDelegate? {
        didSet {
            guard let presentationController = delegate as? UIViewController else { return }
            
            simpleAlert = SimpleAlert(presentationController: presentationController)
        }
    }
    
    private var simpleAlert: SimpleAlert?
    
    // MARK: Subviews
    
    private let scrollView = UIScrollView()
    private let screenView = UIView()
    
    private let contentView = UIView()
    private let logoImageView = UIImageView()
    private let stackView = UIStackView()
    private let emailTextField = SecureTextField()
    private let passwordTextField = SecureTextField(isSecurityControlHidden: false, isSecureTextEntry: true)
    private let logInButton = UIButton(type: .system)
    
    private let separatorView = UIView()
    private let signUpButton = TwoPartsButton()
    
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
    
    override init() {
        super.init()
        
        setupAppearance()
        setupLayout()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public Methods

extension LoginView {
    func showEmailAlertLabel(text: String) {
        LoginRegistrationBaseView.insertSubviewToStackView(emailAlertLabel, stackView: stackView, below: emailTextField)
        
        emailAlertLabel.text = text
    }
    
    func hideEmailAlertLabel() {
        LoginRegistrationBaseView.removeSubviewFromStackView(emailAlertLabel, stackView: stackView)
    }
    
    func showPasswordAlertLabel(text: String) {
        LoginRegistrationBaseView.insertSubviewToStackView(
            passwordAlertLabel,
            stackView: stackView,
            below: passwordTextField)
        
        stackView.setCustomSpacing(LoginRegistrationConstants.Metrics.stackViewSpace, after: passwordTextField)
        stackView.setCustomSpacing(
            LoginRegistrationConstants.Metrics.stackViewPasswordTextFieldSpace,
            after: passwordAlertLabel)
        
        passwordAlertLabel.text = text
    }
    
    func hidePasswordAlertLabel() {
        LoginRegistrationBaseView.removeSubviewFromStackView(passwordAlertLabel, stackView: stackView)
        
        stackView.setCustomSpacing(
            LoginRegistrationConstants.Metrics.stackViewPasswordTextFieldSpace,
            after: passwordTextField)
    }
    
    func showSimpleAlert(title: String, text: String) {
        simpleAlert?.showAlert(title: title, message: text)
    }
    
    func enableLogInButton() {
        logInButton.isEnabled = true
        logInButton.alpha = LoginRegistrationConstants.Constants.mainButtonEnableAlpha
    }
    
    func disableLogInButton() {
        logInButton.isEnabled = false
        logInButton.alpha = LoginRegistrationConstants.Constants.mainButtonDisableAlpha
    }
}

// MARK: - Appearance

private extension LoginView {
    func setupAppearance() {
        backgroundColor = .systemBackground
        
        setupScrollViewAppearance()
        setupLogoImageViewAppearance()
        setupStackViewAppearance()
        setupLogInButtonAppearance()
        setupSeparatorViewAppearance()
        setupSignUpButtonAppearance()
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
        
        LoginRegistrationBaseView.setupStackViewTextFieldAppearance(
            emailTextField,
            placeholder: LoginRegistrationConstants.TextFieldPlaceholders.email)
        LoginRegistrationBaseView.setupStackViewTextFieldAppearance(
            passwordTextField,
            placeholder: LoginRegistrationConstants.TextFieldPlaceholders.password)
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        emailTextField.returnKeyType = .continue
        passwordTextField.returnKeyType = .done
    }
    
    func setupLogInButtonAppearance() {
        logInButton.setTitle(LoginRegistrationConstants.ButtonTitles.logInMain, for: .normal)
        logInButton.setTitleColor(LoginRegistrationConstants.Colors.mainButtonTitle, for: .normal)
        logInButton.titleLabel?.font = .boldSystemFont(ofSize: LoginRegistrationConstants.Metrics.fontSize)
        logInButton.backgroundColor = LoginRegistrationConstants.Colors.mainButtonBackground
        logInButton.layer.cornerRadius = LoginRegistrationConstants.Metrics.mainButtonCornerRadius
        
        disableLogInButton()
    }
    
    func setupSeparatorViewAppearance() {
        separatorView.backgroundColor = LoginRegistrationConstants.Colors.separatorView
    }
    
    func setupSignUpButtonAppearance() {
        signUpButton.firstPartText = LoginRegistrationConstants.ButtonTitles.signUpExtraFirstPart
        signUpButton.secondPartText = LoginRegistrationConstants.ButtonTitles.signUpExtraSecondPart
        
        signUpButton.firstPartFont = .systemFont(ofSize: LoginRegistrationConstants.Metrics.fontSize)
        signUpButton.secondPartFont = .boldSystemFont(ofSize: LoginRegistrationConstants.Metrics.fontSize)
        
        signUpButton.firstPartColor = LoginRegistrationConstants.Colors.extendButtonFirstPart
        signUpButton.secondPartColor = LoginRegistrationConstants.Colors.extendButtonSecondPart
        
        signUpButton.titleLabel?.adjustsFontSizeToFitWidth = true
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
        setupSeparatorViewLayout()
        setupSignUpButtonLayout()
    }
    
    func setupSubviews() {
        addSubview(scrollView)
        
        scrollView.addSubview(screenView)
        screenView.addSubview(contentView)
        screenView.addSubview(separatorView)
        screenView.addSubview(signUpButton)
        
        contentView.addSubview(logoImageView)
        contentView.addSubview(stackView)
        
        stackView.addArrangedSubview(emailTextField)
        stackView.addArrangedSubview(passwordTextField)
        stackView.addArrangedSubview(logInButton)
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
        
        LoginRegistrationBaseView.setupStackViewSubviewLayout(emailTextField, height: stackViewSubviewHeight)
        LoginRegistrationBaseView.setupStackViewSubviewLayout(passwordTextField, height: stackViewSubviewHeight)
        LoginRegistrationBaseView.setupStackViewSubviewLayout(logInButton, height: stackViewSubviewHeight)
    }
    
    func setupSeparatorViewLayout() {
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            separatorView.bottomAnchor.constraint(
                equalTo: signUpButton.topAnchor,
                constant: -LoginRegistrationConstants.Metrics.extraButtonVerticalSpace),
            separatorView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            separatorView.heightAnchor.constraint(
                equalToConstant: LoginRegistrationConstants.Metrics.separatorViewWidth),
        ])
    }
    
    func setupSignUpButtonLayout() {
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            signUpButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            signUpButton.bottomAnchor.constraint(
                equalTo: screenView.bottomAnchor,
                constant: -LoginRegistrationConstants.Metrics.extraButtonVerticalSpace),
        ])
    }
}

// MARK: - Actions

private extension LoginView {
    func setupActions() {
        emailTextField.addTarget(self, action: #selector(textFieldDidChangeWithDelay(_:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChangeWithDelay(_:)), for: .editingChanged)
        
        logInButton.addTarget(self, action: #selector(didPressLogInButton), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(didPressSignUpButton), for: .touchUpInside)
    }
    
    @objc func textFieldDidChangeWithDelay(_ textField: UITextField) {
        NSObject.cancelPreviousPerformRequests(
            withTarget: self,
            selector: #selector(textFieldDidChange(_:)),
            object: textField)
        
        perform(
            #selector(textFieldDidChange(_:)),
            with: textField,
            afterDelay: LoginRegistrationConstants.Constants.textFieldInputDelay)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        switch textField {
        case emailTextField:
            delegate?.loginViewEmailDidChange(self, email: emailTextField.text ?? "")
        case passwordTextField:
            delegate?.loginViewPasswordDidChange(self, password: passwordTextField.text ?? "")
        default:
            break
        }
    }
    
    @objc func didPressLogInButton() {
        delegate?.loginViewDidPressLogInButton(
            self,
            withEmail: emailTextField.text ?? "",
            password: passwordTextField.text ?? "")
        
        endEditing(true)
    }
    
    @objc func didPressSignUpButton() {
        delegate?.loginViewDidPressSignUpButton(self)
    }
}

// MARK: - UITextFieldDelegate

extension LoginView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailTextField:
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            if logInButton.isEnabled {
                didPressLogInButton()
            }
        default:
            break
        }
        
        return true
    }
}

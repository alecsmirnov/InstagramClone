//
//  LoginView.swift
//  Instagram
//
//  Created by Admin on 24.01.2021.
//

import UIKit

protocol LoginViewProtocol: UIView {
    var isUserInteractionEnabled: Bool { get set }
    
    func showEmailWarning(text: String)
    func hideEmailWarning()
    
    func showPasswordWarning(text: String)
    func hidePasswordWarning()
    
    func enableLogInButton()
    func disableLogInButton()
    
    func startAnimatingLogInButton()
    func stopAnimatingLogInButton()
}

protocol LoginViewOutputProtocol: AnyObject {
    func didTapLogInButton(withEmail email: String, password: String)
    func didTapSignUpButton()
    
    func emailDidChange(_ email: String)
    func passwordDidChange(_ password: String)
}

final class LoginView: UIView {
    // MARK: Properties
    
    weak var output: LoginViewOutputProtocol?
    
    private lazy var keyboardAppearanceListener = KeyboardAppearanceListener(delegate: self)
    
    private var emailTextFieldTopConstraint: NSLayoutConstraint?
    private var emailWarningLabelTopConstraint: NSLayoutConstraint?
    private var passwordWarningLabelTopConstraint: NSLayoutConstraint?
    private var screenViewHeightConstraint: NSLayoutConstraint?
    
    // MARK: Subviews
    
    private let scrollView = UIScrollView()
    private let screenView = UIView()
    private let containerView = UIView()
    private let logoImageView = UIImageView()
    private let emailTextField = UITextField()
    private let emailWarningLabel = UILabel()
    private let passwordTextField = SecureTextField()
    private let passwordWarningLabel = UILabel()
    private let logInButton = SpinnerButton(type: .system)
    private let separatorView = UIView()
    private let signUpButton = UIButton()
    
    // MARK: Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupAppearance()
        setupLayout()
        setupButtonActions()
        setupTextFieldActions()
        setupEndEditingGesture()
        keyboardAppearanceListener.setupKeyboardObservers()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Interface

extension LoginView: LoginViewProtocol {
    func showEmailWarning(text: String) {
        emailWarningLabel.text = text
        emailWarningLabelTopConstraint?.constant = LoginRegistrationConstants.Metrics.inputItemTopSpace
    }
    
    func hideEmailWarning() {
        emailWarningLabel.text = nil
        emailWarningLabelTopConstraint?.constant = 0
    }
    
    func showPasswordWarning(text: String) {
        passwordWarningLabel.text = text
        passwordWarningLabelTopConstraint?.constant = LoginRegistrationConstants.Metrics.inputItemTopSpace
    }
    
    func hidePasswordWarning() {
        passwordWarningLabel.text = nil
        passwordWarningLabelTopConstraint?.constant = 0
    }
    
    func enableLogInButton() {
        logInButton.enable()
    }
    
    func disableLogInButton() {
        logInButton.disable()
    }
    
    func startAnimatingLogInButton() {
        logInButton.startAnimatingActivityIndicator()
    }
    
    func stopAnimatingLogInButton() {
        logInButton.stopAnimatingActivityIndicator()
    }
}

// MARK: - Appearance

private extension LoginView {
    func setupAppearance() {
        backgroundColor = .systemBackground
        
        setupScrollViewAppearance()
        setupLogoImageViewAppearance()
        setupEmailTextFieldAppearance()
        setupEmailWarningLabelAppearance()
        setupPasswordTextFieldAppearance()
        setupPasswordWarningLabelAppearance()
        setupLogInButtonAppearance()
        setupSeparatorViewAppearance()
        setupSignUpButtonAppearance()
    }
    
    func setupScrollViewAppearance() {
        scrollView.delaysContentTouches = false
    }
    
    func setupLogoImageViewAppearance() {
        logoImageView.image = UIImage(named: "instagram_logo_black")
        logoImageView.contentMode = .scaleAspectFit
    }
    
    func setupEmailTextFieldAppearance() {
        emailTextField.inputStyle(placeholder: "Email", returnKeyType: .continue)
        emailTextField.delegate = self
    }
    
    func setupEmailWarningLabelAppearance() {
        emailWarningLabel.warningStyle()
    }
    
    func setupPasswordTextFieldAppearance() {
        passwordTextField.inputStyle(placeholder: "Password", returnKeyType: .done)
        passwordTextField.delegate = self
    }
    
    func setupPasswordWarningLabelAppearance() {
        passwordWarningLabel.warningStyle()
    }
    
    func setupLogInButtonAppearance() {
        logInButton.mainStyle(title: "Log In")
        logInButton.activityIndicatorColor = .white
    }
    
    func setupSeparatorViewAppearance() {
        separatorView.backgroundColor = LoginRegistrationConstants.Colors.separatorViewBackground
    }
    
    func setupSignUpButtonAppearance() {
        signUpButton.extraStyle(firstTitle: "Don't have an account?", secondTitle: "Sign Up")        
        signUpButton.titleLabel?.adjustsFontSizeToFitWidth = true
    }
}

// MARK: - Layout

private extension LoginView {
    func setupLayout() {
        setupSubviews()
        
        setupScrollViewLayout()
        setupScreenViewLayout()
        setupContainerViewLayout()
        setupLogoImageViewLayout()
        setupEmailTextFieldLayout()
        setupEmailWarningLabelLayout()
        setupPasswordTextFieldLayout()
        setupPasswordWarningLabelLayout()
        setupLogInButtonLayout()
        setupSeparatorViewLayout()
        setupSignUpButtonLayout()
    }
    
    func setupSubviews() {
        addSubview(scrollView)
        
        scrollView.addSubview(screenView)
        
        screenView.addSubview(containerView)
        screenView.addSubview(separatorView)
        screenView.addSubview(signUpButton)
        
        containerView.addSubview(logoImageView)
        containerView.addSubview(emailTextField)
        containerView.addSubview(emailWarningLabel)
        containerView.addSubview(passwordTextField)
        containerView.addSubview(passwordWarningLabel)
        containerView.addSubview(logInButton)
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
        ])
        
        screenViewHeightConstraint = screenView.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor)
        screenViewHeightConstraint?.isActive = true
    }
    
    func setupContainerViewLayout() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(
                equalTo: screenView.leadingAnchor,
                constant: LoginRegistrationConstants.Metrics.containerViewHorizontalSpace),
            containerView.trailingAnchor.constraint(
                equalTo: screenView.trailingAnchor,
                constant: -LoginRegistrationConstants.Metrics.containerViewHorizontalSpace),
        ])
    }
    
    func setupLogoImageViewLayout() {
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            logoImageView.bottomAnchor.constraint(
                equalTo: emailTextField.topAnchor,
                constant: -LoginRegistrationConstants.Metrics.logoImageViewBottomSpace),
            logoImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            logoImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
        ])
    }
    
    func setupEmailTextFieldLayout() {
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
//            emailTextField.topAnchor.constraint(
//                equalTo: screenView.centerYAnchor,
//                constant: -LoginRegistrationConstants.Metrics.containerViewNegativeTopSpace),
            emailTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            emailTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            emailTextField.heightAnchor.constraint(equalToConstant: LoginRegistrationConstants.Metrics.inputItemHeight),
        ])
        
        emailTextFieldTopConstraint = emailTextField.topAnchor.constraint(
            equalTo: screenView.centerYAnchor,
            constant: -LoginRegistrationConstants.Metrics.containerViewNegativeTopSpace)
        emailTextFieldTopConstraint?.isActive = true
    }
    
    func setupEmailWarningLabelLayout() {
        emailWarningLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            emailWarningLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            emailWarningLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
        ])
        
        emailWarningLabelTopConstraint = emailWarningLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor)
        emailWarningLabelTopConstraint?.isActive = true
    }
    
    func setupPasswordTextFieldLayout() {
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            passwordTextField.topAnchor.constraint(
                equalTo: emailWarningLabel.bottomAnchor,
                constant: LoginRegistrationConstants.Metrics.inputItemTopSpace),
            passwordTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            passwordTextField.heightAnchor.constraint(
                equalToConstant: LoginRegistrationConstants.Metrics.inputItemHeight),
        ])
    }
    
    func setupPasswordWarningLabelLayout() {
        passwordWarningLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            passwordWarningLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            passwordWarningLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
        ])
        
        passwordWarningLabelTopConstraint = passwordWarningLabel.topAnchor.constraint(
            equalTo: passwordTextField.bottomAnchor)
        passwordWarningLabelTopConstraint?.isActive = true
    }
    
    func setupLogInButtonLayout() {
        logInButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            logInButton.topAnchor.constraint(
                equalTo: passwordWarningLabel.bottomAnchor,
                constant: LoginRegistrationConstants.Metrics.mainButtonTopSpace),
            logInButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            logInButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            logInButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            logInButton.heightAnchor.constraint(
                equalToConstant: LoginRegistrationConstants.Metrics.inputItemHeight),
        ])
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

// MARK: - Button Actions

private extension LoginView {
    func setupButtonActions() {
        logInButton.addTarget(self, action: #selector(didTapLogInButton), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(didTapSignUpButton), for: .touchUpInside)
    }
    
    @objc func didTapLogInButton() {
        endEditing(true)
        
        output?.didTapLogInButton(withEmail: emailTextField.text ?? "", password: passwordTextField.text ?? "")
    }
    
    @objc func didTapSignUpButton() {
        endEditing(true)
        
        output?.didTapSignUpButton()
    }
}

// MARK: - TextField Actions

extension LoginView {
    func setupTextFieldActions() {
        emailTextField.addTarget(self, action: #selector(textFieldDidChangeWithDelay(_:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChangeWithDelay(_:)), for: .editingChanged)
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
            output?.emailDidChange(emailTextField.text ?? "")
        case passwordTextField:
            output?.passwordDidChange(passwordTextField.text ?? "")
        default:
            break
        }
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
                didTapLogInButton()
            }
        default:
            break
        }
        
        return true
    }
}

// MARK: - KeyboardAppearanceListenerDelegate

extension LoginView: KeyboardAppearanceListenerDelegate {
    func keyboardAppearanceListener(
        _ listener: KeyboardAppearanceListener,
        keyboardWillShowWith notification: Notification
    ) {
        guard
            let userInfo = notification.userInfo,
            let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        else {
            return
        }
        
        changeScrollViewAndHeight(bottomInset: keyboardSize.cgRectValue.height)
    }
    
    func keyboardAppearanceListener(
        _ listener: KeyboardAppearanceListener,
        keyboardWillHideWith notification: Notification
    ) {
        
        changeScrollViewAndHeight(bottomInset: 0)
    }
    
    private func changeScrollViewAndHeight(bottomInset: CGFloat) {
        scrollView.contentInset.bottom = bottomInset
        scrollView.verticalScrollIndicatorInsets.bottom = bottomInset
        
        let insetSqueezeCoefficient: CGFloat = 1.5
        let bottomOffset = bottomInset / insetSqueezeCoefficient
        let topOffset = -LoginRegistrationConstants.Metrics.containerViewNegativeTopSpace + bottomOffset / 2
        
        screenViewHeightConstraint?.constant = -bottomOffset
        emailTextFieldTopConstraint?.constant = topOffset
        
        layoutIfNeeded()
        
        UIView.animate(withDuration: LoginRegistrationConstants.Constants.scrollViewAnimationDuration) {
            self.layoutIfNeeded()
        }
    }
}

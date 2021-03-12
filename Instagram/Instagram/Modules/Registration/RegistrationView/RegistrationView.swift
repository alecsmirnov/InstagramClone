//
//  RegistrationView.swift
//  Instagram
//
//  Created by Admin on 17.01.2021.
//

import UIKit

protocol RegistrationViewProtocol: UIView {
    var isUserInteractionEnabled: Bool { get set }
    
    func setProfileImage(_ image: UIImage?)
    
    func showEmailWarning(text: String)
    func hideEmailWarning()
    
    func showUsernameWarning(text: String)
    func hideUsernameWarning()
    
    func showPasswordWarning(text: String)
    func hidePasswordWarning()
    
    func enableSignUpButton()
    func disableSignUpButton()
}

protocol RegistrationViewOutputProtocol: AnyObject {
    func emailDidChange(_ email: String)
    func usernameDidChange(_ username: String)
    func passwordDidChange(_ password: String)
    
    func didTapProfileImageButton()
    func didTapSignUpButton(
        withEmail email: String,
        fullName: String,
        username: String,
        password: String,
        profileImage: UIImage?)
    func didTapLogInButton()
}

final class RegistrationView: UIView {
    // MARK: Properties
    
    weak var output: RegistrationViewOutputProtocol?
    
    private lazy var keyboardAppearanceListener = KeyboardAppearanceListener(delegate: self)
    
    private var emailWarningLabelTopConstraint: NSLayoutConstraint?
    private var usernameWarningLabelTopConstraint: NSLayoutConstraint?
    private var passwordWarningLabelTopConstraint: NSLayoutConstraint?
    private var screenViewHeightConstraint: NSLayoutConstraint?
    
    // MARK: Subviews
    
    private let scrollView = UIScrollView()
    private let screenView = UIView()
    private let containerView = UIView()
    private let profileImageButton = UIButton(type: .system)
    private let emailTextField = UITextField()
    private let emailWarningLabel = UILabel()
    private let fullNameTextField = UITextField()
    private let usernameTextField = UITextField()
    private let usernameWarningLabel = UILabel()
    private let passwordTextField = SecureTextField()
    private let passwordWarningLabel = UILabel()
    private let signUpButton = SpinnerButton(type: .system)
    private let separatorView = UIView()
    private let logInButton = UIButton()
    
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

extension RegistrationView: RegistrationViewProtocol {
    func setProfileImage(_ image: UIImage?) {
        let profileImage = (image != nil ) ? image : LoginRegistrationConstants.Images.profileDefault
        
        profileImageButton.setImage(profileImage?.withRenderingMode(.alwaysOriginal), for: .normal)
    }
    
    func showEmailWarning(text: String) {
        emailWarningLabel.text = text
        emailWarningLabelTopConstraint?.constant = LoginRegistrationConstants.Metrics.inputItemTopSpace
    }
    
    func hideEmailWarning() {
        emailWarningLabel.text = nil
        emailWarningLabelTopConstraint?.constant = 0
    }
    
    func showUsernameWarning(text: String) {
        usernameWarningLabel.text = text
        usernameWarningLabelTopConstraint?.constant = LoginRegistrationConstants.Metrics.inputItemTopSpace
    }
    
    func hideUsernameWarning() {
        usernameWarningLabel.text = nil
        usernameWarningLabelTopConstraint?.constant = 0
    }
    
    func showPasswordWarning(text: String) {
        passwordWarningLabel.text = text
        passwordWarningLabelTopConstraint?.constant = LoginRegistrationConstants.Metrics.inputItemTopSpace
    }
    
    func hidePasswordWarning() {
        passwordWarningLabel.text = nil
        passwordWarningLabelTopConstraint?.constant = 0
    }
    
    func enableSignUpButton() {
        signUpButton.enable()
    }
    
    func disableSignUpButton() {
        signUpButton.disable()
    }
    
    func startAnimatingSignUpButton() {
        signUpButton.startAnimatingActivityIndicator()
    }
    
    func stopAnimatingSignUpButton() {
        signUpButton.stopAnimatingActivityIndicator()
    }
}

// MARK: - Appearance

private extension RegistrationView {
    func setupAppearance() {
        backgroundColor = .systemBackground
        
        setupScrollViewAppearance()
        setupProfileImageButtonAppearance()
        setupEmailTextFieldAppearance()
        setupEmailWarningLabelAppearance()
        setupFullNameTextFieldAppearance()
        setupUsernameTextFieldAppearance()
        setupUsernameWarningLabelAppearance()
        setupPasswordTextFieldAppearance()
        setupPasswordWarningLabelAppearance()
        setupSignUpButtonAppearance()
        setupSeparatorViewAppearance()
        setupLogInButtonAppearance()
    }
    
    func setupScrollViewAppearance() {
        scrollView.delaysContentTouches = false
    }
    
    func setupProfileImageButtonAppearance() {
        profileImageButton.largeProfileImageStyle()
    }
    
    func setupEmailTextFieldAppearance() {
        emailTextField.inputStyle(placeholder: "Email", returnKeyType: .continue)
        emailTextField.delegate = self
    }
    
    func setupEmailWarningLabelAppearance() {
        emailWarningLabel.warningStyle()
    }
    
    func setupFullNameTextFieldAppearance() {
        fullNameTextField.inputStyle(placeholder: "Full Name", returnKeyType: .continue)
        fullNameTextField.delegate = self
    }
    
    func setupUsernameTextFieldAppearance() {
        usernameTextField.inputStyle(placeholder: "Username", returnKeyType: .continue)
        usernameTextField.delegate = self
    }
    
    func setupUsernameWarningLabelAppearance() {
        usernameWarningLabel.warningStyle()
    }
    
    func setupPasswordTextFieldAppearance() {
        passwordTextField.inputStyle(placeholder: "Password", returnKeyType: .done)
        passwordTextField.delegate = self
    }
    
    func setupPasswordWarningLabelAppearance() {
        passwordWarningLabel.warningStyle()
    }
    
    func setupSignUpButtonAppearance() {
        signUpButton.mainStyle(title: "Sign Up", fontSize: LoginRegistrationConstants.Metrics.mainButtonFontSize)
    }
    
    func setupSeparatorViewAppearance() {
        separatorView.backgroundColor = LoginRegistrationConstants.Colors.separatorViewBackground
    }
    
    func setupLogInButtonAppearance() {
        logInButton.extraStyle(firstTitle: "Already have an account?", secondTitle: "Log In")
        logInButton.titleLabel?.adjustsFontSizeToFitWidth = true
    }
}

// MARK: - Layout

private extension RegistrationView {
    func setupLayout() {
        setupSubviews()
        
        setupScrollViewLayout()
        setupScreenViewLayout()
        setupContainerViewLayout()
        setupProfileImageButtonLayout()
        setupEmailTextFieldLayout()
        setupEmailWarningLabelLayout()
        setupFullNameTextFieldLayout()
        setupUsernameTextFieldLayout()
        setupUsernameWarningLabelLayout()
        setupPasswordTextFieldLayout()
        setupPasswordWarningLabelLayout()
        setupSignUpButtonLayout()
        setupSeparatorViewLayout()
        setupLogInButtonLayout()
    }
    
    func setupSubviews() {
        addSubview(scrollView)
        
        scrollView.addSubview(screenView)
        
        screenView.addSubview(containerView)
        screenView.addSubview(separatorView)
        screenView.addSubview(logInButton)

        containerView.addSubview(profileImageButton)
        containerView.addSubview(emailTextField)
        containerView.addSubview(emailWarningLabel)
        containerView.addSubview(fullNameTextField)
        containerView.addSubview(usernameTextField)
        containerView.addSubview(usernameWarningLabel)
        containerView.addSubview(passwordTextField)
        containerView.addSubview(passwordWarningLabel)
        containerView.addSubview(signUpButton)
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
    
    func setupProfileImageButtonLayout() {
        profileImageButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            profileImageButton.topAnchor.constraint(equalTo: containerView.topAnchor),
            profileImageButton.bottomAnchor.constraint(
                equalTo: emailTextField.topAnchor,
                constant: -LoginRegistrationConstants.Metrics.logoImageViewBottomSpace),
            profileImageButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            profileImageButton.heightAnchor.constraint(
                equalToConstant: LoginRegistrationConstants.Metrics.profileImageButtonSize),
            profileImageButton.widthAnchor.constraint(
                equalToConstant: LoginRegistrationConstants.Metrics.profileImageButtonSize),
        ])
    }
    
    func setupEmailTextFieldLayout() {
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            emailTextField.topAnchor.constraint(
                equalTo: screenView.centerYAnchor,
                constant: -LoginRegistrationConstants.Metrics.containerViewNegativeTopSpace),
            emailTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            emailTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            emailTextField.heightAnchor.constraint(equalToConstant: LoginRegistrationConstants.Metrics.inputItemHeight),
        ])
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
    
    func setupFullNameTextFieldLayout() {
        fullNameTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            fullNameTextField.topAnchor.constraint(
                equalTo: emailWarningLabel.bottomAnchor,
                constant: LoginRegistrationConstants.Metrics.inputItemTopSpace),
            fullNameTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            fullNameTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            fullNameTextField.heightAnchor.constraint(
                equalToConstant: LoginRegistrationConstants.Metrics.inputItemHeight),
        ])
    }
    
    func setupUsernameTextFieldLayout() {
        usernameTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            usernameTextField.topAnchor.constraint(
                equalTo: fullNameTextField.bottomAnchor,
                constant: LoginRegistrationConstants.Metrics.inputItemTopSpace),
            usernameTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            usernameTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            usernameTextField.heightAnchor.constraint(
                equalToConstant: LoginRegistrationConstants.Metrics.inputItemHeight),
        ])
    }
    
    func setupUsernameWarningLabelLayout() {
        usernameWarningLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            usernameWarningLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            usernameWarningLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
        ])
        
        usernameWarningLabelTopConstraint = usernameWarningLabel.topAnchor.constraint(
            equalTo: usernameTextField.bottomAnchor)
        usernameWarningLabelTopConstraint?.isActive = true
    }
    
    func setupPasswordTextFieldLayout() {
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            passwordTextField.topAnchor.constraint(
                equalTo: usernameWarningLabel.bottomAnchor,
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
    
    func setupSignUpButtonLayout() {
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            signUpButton.topAnchor.constraint(
                equalTo: passwordWarningLabel.bottomAnchor,
                constant: LoginRegistrationConstants.Metrics.mainButtonTopSpace),
            signUpButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            signUpButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            signUpButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            signUpButton.heightAnchor.constraint(
                equalToConstant: LoginRegistrationConstants.Metrics.inputItemHeight),
        ])
    }
    
    func setupSeparatorViewLayout() {
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            separatorView.bottomAnchor.constraint(
                equalTo: logInButton.topAnchor,
                constant: -LoginRegistrationConstants.Metrics.extraButtonVerticalSpace),
            separatorView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            separatorView.heightAnchor.constraint(
                equalToConstant: LoginRegistrationConstants.Metrics.separatorViewWidth),
        ])
    }
    
    func setupLogInButtonLayout() {
        logInButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            logInButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            logInButton.bottomAnchor.constraint(
                equalTo: screenView.bottomAnchor,
                constant: -LoginRegistrationConstants.Metrics.extraButtonVerticalSpace),
        ])
    }
}

// MARK: - Button Actions

private extension RegistrationView {
    func setupButtonActions() {
        profileImageButton.addTarget(self, action: #selector(didTapProfileImageButton), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(didTapSignUpButton), for: .touchUpInside)
        logInButton.addTarget(self, action: #selector(didTapLogInButton), for: .touchUpInside)
    }
    
    @objc func didTapProfileImageButton() {
        output?.didTapProfileImageButton()
    }
    
    @objc func didTapSignUpButton() {
        endEditing(true)
        
        let isDefaultProfileImage = profileImageButton.currentImage == LoginRegistrationConstants.Images.profileDefault
        let profileImage = isDefaultProfileImage ? nil : profileImageButton.currentImage
        
        output?.didTapSignUpButton(
            withEmail: emailTextField.text ?? "",
            fullName: fullNameTextField.text ?? "",
            username: usernameTextField.text ?? "",
            password: usernameTextField.text ?? "",
            profileImage: profileImage)
    }
    
    @objc func didTapLogInButton() {
        endEditing(true)
        
        output?.didTapLogInButton()
    }
}

// MARK: - TextField Actions

private extension RegistrationView {
    func setupTextFieldActions() {
        emailTextField.addTarget(self, action: #selector(textFieldDidChangeWithDelay(_:)), for: .editingChanged)
        usernameTextField.addTarget(self, action: #selector(textFieldDidChangeWithDelay(_:)), for: .editingChanged)
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
        case usernameTextField:
            output?.usernameDidChange(usernameTextField.text ?? "")
        case passwordTextField:
            output?.passwordDidChange(passwordTextField.text ?? "")
        default:
            break
        }
    }
}

// MARK: - UITextFieldDelegate

extension RegistrationView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailTextField:
            fullNameTextField.becomeFirstResponder()
        case fullNameTextField:
            usernameTextField.becomeFirstResponder()
        case usernameTextField:
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            if signUpButton.isEnabled {
                didTapSignUpButton()
            }
        default:
            break
        }
        
        return true
    }
}

// MARK: - KeyboardAppearanceListenerDelegate

extension RegistrationView: KeyboardAppearanceListenerDelegate {
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
        
       changeScrollViewInsetAndHeight(bottomInset: keyboardSize.cgRectValue.height)
    }
    
    func keyboardAppearanceListener(
        _ listener: KeyboardAppearanceListener,
        keyboardWillHideWith notification: Notification
    ) {
        changeScrollViewInsetAndHeight(bottomInset: 0)
    }
    
    private func changeScrollViewInsetAndHeight(bottomInset: CGFloat) {
        scrollView.contentInset.bottom = bottomInset
        scrollView.verticalScrollIndicatorInsets.bottom = bottomInset
        
        let insetSqueezeCoefficient = LoginRegistrationConstants.Constants.loginKeyboardInsetSqueezeCoefficient
        screenViewHeightConstraint?.constant = -bottomInset / insetSqueezeCoefficient
        
        layoutIfNeeded()
        
        UIView.animate(withDuration: LoginRegistrationConstants.Constants.scrollViewAnimationDuration) {
            self.layoutIfNeeded()
        }
    }
}

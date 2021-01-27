//
//  RegistrationView.swift
//  Instagram
//
//  Created by Admin on 17.01.2021.
//

import UIKit

protocol RegistrationViewDelegate: AnyObject {
    func registrationViewDidPressSignUpButton(_ registrationView: RegistrationView, withInfo info: Registration)
    func registrationViewDidPressLogInButton(_ registrationView: RegistrationView)
    
    func registrationViewEmailDidChange(_ registrationView: RegistrationView, email: String)
    func registrationViewUsernameDidChange(_ registrationView: RegistrationView, username: String)
    func registrationViewPasswordDidChange(_ registrationView: RegistrationView, password: String)
}

final class RegistrationView: LoginRegistrationBaseView {
    // MARK: Properties
    
    weak var delegate: RegistrationViewDelegate? {
        didSet {
            guard let presentationController = delegate as? UIViewController else { return }
            
            imagePicker = ImagePicker(presentationController: presentationController, delegate: self)
            keyboardAppearanceListener = KeyboardAppearanceListener(delegate: self)
        }
    }
    
    private var imagePicker: ImagePicker?
    private var keyboardAppearanceListener: KeyboardAppearanceListener?
    
    // MARK: Subviews
    
    private let scrollView = UIScrollView()
    private let screenView = UIView()
    
    private let contentView = UIView()
    private let profileImageButton = UIButton(type: .system)
    private let stackView = UIStackView()
    private let emailTextField = SecureTextField()
    private let fullNameTextField = SecureTextField()
    private let usernameTextField = SecureTextField()
    private let passwordTextField = SecureTextField(isSecurityControlHidden: false, isSecureTextEntry: true)
    private let signUpButton = UIButton(type: .system)
    
    private let separatorView = UIView()
    private let logInButton = TwoPartsButton()
    
    private lazy var emailAlertLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: LoginRegistrationConstants.Metrics.alertFontSize)
        label.textColor = LoginRegistrationConstants.Colors.alert
        
        return label
    }()
    
    private let usernameAlertLabel: UILabel = {
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

extension RegistrationView {
    func showEmailAlertLabel(text: String) {
        LoginRegistrationBaseView.insertSubviewToStackView(emailAlertLabel, stackView: stackView, below: emailTextField)
        
        emailAlertLabel.text = text
    }
    
    func hideEmailAlertLabel() {
        LoginRegistrationBaseView.removeSubviewFromStackView(emailAlertLabel, stackView: stackView)
    }
    
    func showUsernameAlertLabel(text: String) {
        LoginRegistrationBaseView.insertSubviewToStackView(
            usernameAlertLabel,
            stackView: stackView,
            below: usernameTextField)
        
        usernameAlertLabel.text = text
    }
    
    func hideUsernameAlertLabel() {
        LoginRegistrationBaseView.removeSubviewFromStackView(usernameAlertLabel, stackView: stackView)
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
    
    func enableSignUpButton() {
        signUpButton.isEnabled = true
        signUpButton.alpha = LoginRegistrationConstants.Constants.mainButtonEnableAlpha
    }
    
    func disableSignUpButton() {
        signUpButton.isEnabled = false
        signUpButton.alpha = LoginRegistrationConstants.Constants.mainButtonDisableAlpha
    }
}

// MARK: - Appearance

private extension RegistrationView {
    func setupAppearance() {
        backgroundColor = .systemBackground
        
        setupScrollViewAppearance()
        setupProfileImageButtonAppearance()
        setupStackViewAppearance()
        setupSignUpButtonAppearance()
        setupSeparatorViewAppearance()
        setupLogInButtonAppearance()
    }
    
    func setupScrollViewAppearance() {
        scrollView.delaysContentTouches = false
    }
    
    func setupProfileImageButtonAppearance() {
        profileImageButton.setImage(LoginRegistrationConstants.Images.profile, for: .normal)
        profileImageButton.tintColor = LoginRegistrationConstants.Colors.profileImageButtonTint
        profileImageButton.layer.cornerRadius = LoginRegistrationConstants.Metrics.profileImageButtonSize / 2
        profileImageButton.layer.masksToBounds = true
        profileImageButton.layer.borderColor = LoginRegistrationConstants.Colors.profileImageButtonBorder.cgColor
        profileImageButton.layer.borderWidth = LoginRegistrationConstants.Metrics.profileImageButtonBorderWidth
    }
    
    func setupStackViewAppearance() {
        stackView.axis = .vertical
        stackView.alignment = .fill
        
        LoginRegistrationBaseView.setupStackViewTextFieldAppearance(
            emailTextField,
            placeholder: LoginRegistrationConstants.TextFieldPlaceholders.email)
        LoginRegistrationBaseView.setupStackViewTextFieldAppearance(
            fullNameTextField,
            placeholder: LoginRegistrationConstants.TextFieldPlaceholders.fullName)
        LoginRegistrationBaseView.setupStackViewTextFieldAppearance(
            usernameTextField,
            placeholder: LoginRegistrationConstants.TextFieldPlaceholders.username)
        LoginRegistrationBaseView.setupStackViewTextFieldAppearance(
            passwordTextField,
            placeholder: LoginRegistrationConstants.TextFieldPlaceholders.password)
        
        emailTextField.delegate = self
        fullNameTextField.delegate = self
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        
        emailTextField.returnKeyType = .continue
        fullNameTextField.returnKeyType = .continue
        usernameTextField.returnKeyType = .continue
        passwordTextField.returnKeyType = .done
    }
    
    func setupSignUpButtonAppearance() {
        signUpButton.setTitle(LoginRegistrationConstants.ButtonTitles.signUpMain, for: .normal)
        signUpButton.setTitleColor(LoginRegistrationConstants.Colors.mainButtonTitle, for: .normal)
        signUpButton.titleLabel?.font = .boldSystemFont(ofSize: LoginRegistrationConstants.Metrics.fontSize)
        signUpButton.backgroundColor = LoginRegistrationConstants.Colors.mainButtonBackground
        signUpButton.layer.cornerRadius = LoginRegistrationConstants.Metrics.mainButtonCornerRadius
        
        disableSignUpButton()
    }
    
    func setupSeparatorViewAppearance() {
        separatorView.backgroundColor = LoginRegistrationConstants.Colors.separatorView
    }
    
    func setupLogInButtonAppearance() {
        logInButton.firstPartText = LoginRegistrationConstants.ButtonTitles.logInExtraFirstPart
        logInButton.secondPartText = LoginRegistrationConstants.ButtonTitles.logInExtraSecondPart
        
        logInButton.firstPartFont = .systemFont(ofSize: LoginRegistrationConstants.Metrics.fontSize)
        logInButton.secondPartFont = .boldSystemFont(ofSize: LoginRegistrationConstants.Metrics.fontSize)
        
        logInButton.firstPartColor = LoginRegistrationConstants.Colors.extendButtonFirstPart
        logInButton.secondPartColor = LoginRegistrationConstants.Colors.extendButtonSecondPart
        
        logInButton.titleLabel?.adjustsFontSizeToFitWidth = true
    }
}

// MARK: - Layout

private extension RegistrationView {
    func setupLayout() {
        setupSubviews()
        
        setupScrollViewLayout()
        setupScreenViewLayout()
        setupContentViewLayout()
        setupProfileImageButtonLayout()
        setupStackViewLayout()
        setupSeparatorViewLayout()
        setupLogInButtonLayout()
    }
    
    func setupSubviews() {
        addSubview(scrollView)
        
        scrollView.addSubview(screenView)
        screenView.addSubview(contentView)
        screenView.addSubview(separatorView)
        screenView.addSubview(logInButton)
        
        contentView.addSubview(profileImageButton)
        contentView.addSubview(stackView)
        
        stackView.addArrangedSubview(emailTextField)
        stackView.addArrangedSubview(fullNameTextField)
        stackView.addArrangedSubview(usernameTextField)
        stackView.addArrangedSubview(passwordTextField)
        stackView.addArrangedSubview(signUpButton)
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
    
    func setupProfileImageButtonLayout() {
        profileImageButton.translatesAutoresizingMaskIntoConstraints = false
        
        let profileImageButtonSize = LoginRegistrationConstants.Metrics.profileImageButtonSize
        
        NSLayoutConstraint.activate([
            profileImageButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            profileImageButton.centerXAnchor.constraint(equalTo: screenView.centerXAnchor),
            profileImageButton.heightAnchor.constraint(equalToConstant: profileImageButtonSize),
            profileImageButton.widthAnchor.constraint(equalToConstant: profileImageButtonSize),
        ])
    }
    
    func setupStackViewLayout() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(
                equalTo: profileImageButton.bottomAnchor,
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
        LoginRegistrationBaseView.setupStackViewSubviewLayout(fullNameTextField, height: stackViewSubviewHeight)
        LoginRegistrationBaseView.setupStackViewSubviewLayout(usernameTextField, height: stackViewSubviewHeight)
        LoginRegistrationBaseView.setupStackViewSubviewLayout(passwordTextField, height: stackViewSubviewHeight)
        LoginRegistrationBaseView.setupStackViewSubviewLayout(signUpButton, height: stackViewSubviewHeight)
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

// MARK: - Actions

private extension RegistrationView {
    func setupActions() {
        profileImageButton.addTarget(self, action: #selector(didPressProfileImageButton), for: .touchUpInside)
        
        emailTextField.addTarget(self, action: #selector(textFieldDidChangeWithDelay(_:)), for: .editingChanged)
        usernameTextField.addTarget(self, action: #selector(textFieldDidChangeWithDelay(_:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChangeWithDelay(_:)), for: .editingChanged)
        
        signUpButton.addTarget(self, action: #selector(didPressSignUpButton), for: .touchUpInside)
        logInButton.addTarget(self, action: #selector(didPressLogInButton), for: .touchUpInside)
    }
    
    @objc func didPressProfileImageButton() {
        imagePicker?.takePhoto()
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
            delegate?.registrationViewEmailDidChange(self, email: emailTextField.text ?? "")
        case usernameTextField:
            delegate?.registrationViewUsernameDidChange(self, username: usernameTextField.text ?? "")
        case passwordTextField:
            delegate?.registrationViewPasswordDidChange(self, password: passwordTextField.text ?? "")
        default:
            break
        }
    }
    
    @objc func didPressSignUpButton() {
        let isDefaultProfileImage = profileImageButton.currentImage == LoginRegistrationConstants.Images.profile
        let profileImage = isDefaultProfileImage ? nil : profileImageButton.currentImage
        
        let info = Registration(
            profileImage: profileImage,
            email: emailTextField.text ?? "",
            fullName: fullNameTextField.text ?? "",
            username: usernameTextField.text ?? "",
            password: passwordTextField.text ?? "")
        
        delegate?.registrationViewDidPressSignUpButton(self, withInfo: info)
        
        endEditing(true)
    }
    
    @objc func didPressLogInButton() {
        delegate?.registrationViewDidPressLogInButton(self)
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
                didPressSignUpButton()
            }
        default:
            break
        }
        
        return true
    }
}

// MARK: - ImagePickerDelegate

extension RegistrationView: ImagePickerDelegate {
    func imagePicker(_ imagePicker: ImagePicker, didSelectImage image: UIImage?) {
        profileImageButton.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
    }
}

// MARK: - KeyboardAppearanceListenerDelegate

extension RegistrationView: KeyboardAppearanceListenerDelegate {
    func keyboardAppearanceListener(
        _ listener: KeyboardAppearanceListener,
        keyboardWillShowWith notification: NSNotification
    ) {        
        guard
            let userInfo = notification.userInfo,
            let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        else {
            return
        }
        
        scrollView.contentInset.bottom = keyboardSize.cgRectValue.height
        scrollView.verticalScrollIndicatorInsets.bottom = scrollView.contentInset.bottom
    }
    
    func keyboardAppearanceListener(
        _ listener: KeyboardAppearanceListener,
        keyboardWillHideWith notification: NSNotification
    ) {
        scrollView.contentInset.bottom = 0
        scrollView.verticalScrollIndicatorInsets.bottom = scrollView.contentInset.bottom
    }
}

//
//  RegistrationView.swift
//  Instagram
//
//  Created by Admin on 17.01.2021.
//

import UIKit

protocol RegistrationViewDelegate: AnyObject {
    func registrationViewDidPressProfileImageButton(_ registrationView: RegistrationView)
    
    func registrationViewDidPressSignUpButton(_ registrationView: RegistrationView, withInfo info: RegistrationInfo)
    func registrationViewDidPressSignInButton(_ registrationView: RegistrationView)
    
    func registrationViewEmailDidChange(_ registrationView: RegistrationView, email: String)
    func registrationViewUsernameDidChange(_ registrationView: RegistrationView, username: String)
    func registrationViewPasswordDidChange(_ registrationView: RegistrationView, password: String)
}

final class RegistrationView: UIView {
    // MARK: Properties
    
    weak var delegate: RegistrationViewDelegate?
    
    // MARK: Constants
    
    private enum Metrics {
        static let profileImageButtonTopSpace: CGFloat = 40
        static let profileImageButtonBottomSpace: CGFloat = 20
        static let profileImageButtonSize: CGFloat = 110
        
        static let stackViewHorizontalSpace: CGFloat = 20
        static let stackViewSpace: CGFloat = 6
        static let stackViewPasswordTextFieldSpace: CGFloat = 16
        static let stackViewSubviewHeight: CGFloat = 40
    }
    
    private enum TextFieldPlaceholders {
        static let email = "Email"
        static let fullName = "Full Name"
        static let username = "Username"
        static let password = "Password"
    }
    
    private enum ButtonTitles {
        static let signUp = "Sign Up"
        static let signIn = "Sign In"
    }
    
    private enum Colors {
        static let profileImageButtonTintColor = UIColor(white: 0, alpha: 0.9)
        static let textFieldBackground = UIColor(white: 0, alpha: 0.02)
        static let signUpButtonTitle = UIColor.white
        static let signUpButtonBackground = UIColor(red: 0.25, green: 0.36, blue: 0.9, alpha: 1)
        
        static let alert = UIColor(red: 0.99, green: 0.11, blue: 0.11, alpha: 1)
    }
    
    private enum Constants {
        static let fontSize: CGFloat = 14
        static let alertFontSize: CGFloat = 12
        
        static let profileImageButtonBorderWidth: CGFloat = 1
        
        static let signUpButtonCornerRadius: CGFloat = 4
        static let signUpButtonEnableAlpha: CGFloat = 1
        static let signUpButtonDisableAlpha: CGFloat = 0.4
        
        static let textFieldInputDelay = 0.6
    }
    
    // MARK: Subviews
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let stackView = UIStackView()
    
    private let profileImageButton = UIButton(type: .system)
    private let emailTextField = UITextField()
    private let fullNameTextField = UITextField()
    private let usernameTextField = UITextField()
    private let passwordTextField = UITextField()
    private let signUpButton = UIButton(type: .system)
    
    private lazy var emailAlertLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: Constants.alertFontSize)
        label.textColor = Colors.alert
        
        return label
    }()
    
    private let usernameAlertLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: Constants.alertFontSize)
        label.textColor = Colors.alert
        
        return label
    }()
    
    private let passwordAlertLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: Constants.alertFontSize)
        label.textColor = Colors.alert
        
        return label
    }()
    
    // MARK: Initialization
    
    init() {
        super.init(frame: .zero)
        
        setupAppearance()
        setupLayout()
        setupActions()
        setupGestures()
        setupKeyboardEvents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        removeKeyboardEvents()
    }
}

// MARK: - Public Methods

extension RegistrationView {
    func setProfileImage(_ image: UIImage?) {
        profileImageButton.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
    }
    
    func showEmailAlertLabel(text: String) {
        insertSubviewToStackView(emailAlertLabel, below: emailTextField)
        
        emailAlertLabel.text = text
    }
    
    func hideEmailAlertLabel() {
        removeSubviewFromStackView(emailAlertLabel)
    }
    
    func showUsernameAlertLabel(text: String) {
        insertSubviewToStackView(usernameAlertLabel, below: usernameTextField)
        
        usernameAlertLabel.text = text
    }
    
    func hideUsernameAlertLabel() {
        removeSubviewFromStackView(usernameAlertLabel)
    }
    
    func showPasswordAlertLabel(text: String) {
        insertSubviewToStackView(passwordAlertLabel, below: passwordTextField)
        
        stackView.setCustomSpacing(Metrics.stackViewSpace, after: passwordTextField)
        stackView.setCustomSpacing(Metrics.stackViewPasswordTextFieldSpace, after: passwordAlertLabel)
        
        passwordAlertLabel.text = text
    }
    
    func hidePasswordAlertLabel() {
        removeSubviewFromStackView(passwordAlertLabel)
        
        stackView.setCustomSpacing(Metrics.stackViewPasswordTextFieldSpace, after: passwordTextField)
    }
    
    func enableSignUpButton() {
        signUpButton.isEnabled = true
        signUpButton.alpha = Constants.signUpButtonEnableAlpha
    }
    
    func disableSignUpButton() {
        signUpButton.isEnabled = false
        signUpButton.alpha = Constants.signUpButtonDisableAlpha
    }
}

// MARK: - Private Methods

private extension RegistrationView {
    func insertSubviewToStackView(_ subview: UIView, below view: UIView) {
        if let index = stackView.arrangedSubviews.firstIndex(of: view) {
            stackView.insertArrangedSubview(subview, at: index + 1)
        }
    }
    
    func removeSubviewFromStackView(_ subview: UIView) {
        stackView.removeArrangedSubview(subview)
        subview.removeFromSuperview()
    }
}

// MARK: - Appearance

private extension RegistrationView {
    func setupAppearance() {
        backgroundColor = .systemBackground
        
        setupScrollViewAppearance()
        setupStackViewAppearance()
        
        setupProfileImageButtonAppearance()
        setupEmailTextFieldAppearance()
        setupFullNameTextFieldAppearance()
        setupUsernameTextFieldAppearance()
        setupPasswordTextFieldAppearance()
        setupSignUpButtonAppearance()
    }
    
    func setupScrollViewAppearance() {
        scrollView.delaysContentTouches = false
    }
    
    func setupStackViewAppearance() {
        stackView.axis = .vertical
        stackView.alignment = .fill
    }
    
    func setupProfileImageButtonAppearance() {
        profileImageButton.setImage(AssetsImages.profileImage, for: .normal)
        profileImageButton.tintColor = Colors.profileImageButtonTintColor
        profileImageButton.layer.cornerRadius = Metrics.profileImageButtonSize / 2
        profileImageButton.layer.masksToBounds = true
        profileImageButton.layer.borderColor = Colors.profileImageButtonTintColor.cgColor
        profileImageButton.layer.borderWidth = Constants.profileImageButtonBorderWidth
    }
    
    func setupEmailTextFieldAppearance() {
        RegistrationView.setupTextFieldAppearance(emailTextField, placeholder: TextFieldPlaceholders.email)
    }
    
    func setupFullNameTextFieldAppearance() {
        RegistrationView.setupTextFieldAppearance(fullNameTextField, placeholder: TextFieldPlaceholders.fullName)
    }
    
    func setupUsernameTextFieldAppearance() {
        RegistrationView.setupTextFieldAppearance(usernameTextField, placeholder: TextFieldPlaceholders.username)
    }
    
    func setupPasswordTextFieldAppearance() {
        RegistrationView.setupTextFieldAppearance(passwordTextField, placeholder: TextFieldPlaceholders.password)
    }
    
    func setupSignUpButtonAppearance() {
        signUpButton.setTitle(ButtonTitles.signUp, for: .normal)
        signUpButton.setTitleColor(Colors.signUpButtonTitle, for: .normal)
        signUpButton.titleLabel?.font = .boldSystemFont(ofSize: Constants.fontSize)
        signUpButton.backgroundColor = Colors.signUpButtonBackground
        signUpButton.layer.cornerRadius = Constants.signUpButtonCornerRadius
        
        disableSignUpButton()
    }
}

// MARK: - Appearance Helpers

private extension RegistrationView {
    static func setupTextFieldAppearance(_ textField: UITextField, placeholder: String) {
        textField.placeholder = placeholder
        textField.borderStyle = .roundedRect
        textField.backgroundColor = Colors.textFieldBackground
        textField.font = .systemFont(ofSize: Constants.fontSize)
        textField.clearButtonMode = .whileEditing
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
    }
}

// MARK: - Layout

private extension RegistrationView {
    func setupLayout() {
        setupSubviews()
        
        setupScrollViewLayout()
        setupContentViewLayout()
        setupStackViewLayout()
        
        setupProfileImageButtonLayout()
        setupEmailTextFieldLayout()
        setupFullNameTextFieldLayout()
        setupUsernameTextFieldLayout()
        setupPasswordTextFieldLayout()
        setupSignUpButtonLayout()
    }
    
    func setupSubviews() {
        addSubview(scrollView)
        
        scrollView.addSubview(contentView)
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
    
    func setupContentViewLayout() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            contentView.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor),
        ])
    }
    
    func setupStackViewLayout() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: profileImageButton.bottomAnchor,
                                           constant: Metrics.profileImageButtonBottomSpace),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                               constant: Metrics.stackViewHorizontalSpace),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                constant: -Metrics.stackViewHorizontalSpace),
        ])
        
        stackView.spacing = Metrics.stackViewSpace
        stackView.setCustomSpacing(Metrics.stackViewPasswordTextFieldSpace, after: passwordTextField)
    }
    
    func setupProfileImageButtonLayout() {
        profileImageButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            profileImageButton.topAnchor.constraint(equalTo: contentView.topAnchor,
                                                    constant: Metrics.profileImageButtonTopSpace),
            profileImageButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            profileImageButton.heightAnchor.constraint(equalToConstant: Metrics.profileImageButtonSize),
            profileImageButton.widthAnchor.constraint(equalToConstant: Metrics.profileImageButtonSize),
        ])
    }
    
    func setupEmailTextFieldLayout() {
        RegistrationView.setupStackViewSubviewLayout(emailTextField, height: Metrics.stackViewSubviewHeight)
    }
    
    func setupFullNameTextFieldLayout() {
        RegistrationView.setupStackViewSubviewLayout(fullNameTextField, height: Metrics.stackViewSubviewHeight)
    }
    
    func setupUsernameTextFieldLayout() {
        RegistrationView.setupStackViewSubviewLayout(usernameTextField, height: Metrics.stackViewSubviewHeight)
    }
    
    func setupPasswordTextFieldLayout() {
        RegistrationView.setupStackViewSubviewLayout(passwordTextField, height: Metrics.stackViewSubviewHeight)
        
        passwordTextField.isSecureTextEntry = true
    }
    
    func setupSignUpButtonLayout() {
        RegistrationView.setupStackViewSubviewLayout(signUpButton, height: Metrics.stackViewSubviewHeight)
    }
}

// MARK: - Layout Helpers

private extension RegistrationView {
    static func setupStackViewSubviewLayout(_ subview: UIView, height: CGFloat) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        
        subview.heightAnchor.constraint(equalToConstant: height).isActive = true
    }
}

// MARK: - Actions

private extension RegistrationView {
    func setupActions() {
        profileImageButton.addTarget(self, action: #selector(didPressProfileImageButton), for: .touchUpInside)
        
        signUpButton.addTarget(self, action: #selector(didPressSignUpButton), for: .touchUpInside)
        
        emailTextField.addTarget(self, action: #selector(textFieldDidChangeWithDelay(_:)), for: .editingChanged)
        usernameTextField.addTarget(self, action: #selector(textFieldDidChangeWithDelay(_:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChangeWithDelay(_:)), for: .editingChanged)
    }
    
    @objc func didPressProfileImageButton() {
        delegate?.registrationViewDidPressProfileImageButton(self)
    }
    
    @objc func didPressSignUpButton() {
        let isDefaultProfileImage = profileImageButton.currentImage == AssetsImages.profileImage
        let profileImage = isDefaultProfileImage ? nil : profileImageButton.currentImage
        
        let info = RegistrationInfo(profileImage: profileImage,
                                    email: emailTextField.text,
                                    fullName: fullNameTextField.text,
                                    username: usernameTextField.text,
                                    password: passwordTextField.text)
        
        delegate?.registrationViewDidPressSignUpButton(self, withInfo: info)
    }
    
    @objc func textFieldDidChangeWithDelay(_ textField: UITextField) {
        NSObject.cancelPreviousPerformRequests(withTarget: self,
                                               selector: #selector(textFieldDidChange(_:)),
                                               object: textField)
        
        perform(#selector(textFieldDidChange(_:)), with: textField, afterDelay: Constants.textFieldInputDelay)
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
}

// MARK: - Gestures

private extension RegistrationView {
    func setupGestures() {
        setupKeyboardDismissGesture()
    }
    
    func setupKeyboardDismissGesture() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGestureRecognizer.cancelsTouchesInView = false
        
        addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func dismissKeyboard() {
        endEditing(true)
    }
}

// MARK: - Keyboard Events

private extension RegistrationView {
    func setupKeyboardEvents() {
        setupKeyboardObservers()
    }
    
    func removeKeyboardEvents() {
        removeKeyboardObservers()
    }
    
    func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func removeKeyboardObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        scrollView.contentInset.bottom = keyboardSize.cgRectValue.height
        scrollView.verticalScrollIndicatorInsets.bottom = scrollView.contentInset.bottom
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset.bottom = 0
        scrollView.verticalScrollIndicatorInsets.bottom = scrollView.contentInset.bottom
    }
}

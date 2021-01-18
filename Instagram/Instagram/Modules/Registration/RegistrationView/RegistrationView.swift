//
//  RegistrationView.swift
//  Instagram
//
//  Created by Admin on 17.01.2021.
//

import UIKit

protocol RegistrationViewDelegate: AnyObject {
    func registrationViewDidPressSignUpButton(_ registrationView: RegistrationView)
    func registrationViewDidPressSignInButton(_ registrationView: RegistrationView)
}

final class RegistrationView: UIView {
    // MARK: Properties
    
    weak var delegate: RegistrationViewDelegate?
    
    var email: String? {
        return emailTextField.text
    }
    
    var fullName: String? {
        return fullNameTextField.text
    }
    
    var username: String? {
        return usernameTextField.text
    }
    
    var password: String? {
        return passwordTextField.text
    }
    
    // MARK: Constants
    
    private enum Metrics {
        static let profileImageButtonTopSpace: CGFloat = 40
        static let profileImageButtonBottomSpace: CGFloat = 20
        static let profileImageButtonSize: CGFloat = 110
        
        static let textFieldBottomSpace: CGFloat = 6
        static let textFieldHorizontalSpace: CGFloat = 20
        static let textFieldHeight: CGFloat = 40
        
        static let signUpButtonTopSpace: CGFloat = 16
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
    }
    
    private enum Constants {
        static let fontSize: CGFloat = 14
        
        static let signUpButtonCornerRadius: CGFloat = 4
    }
    
    // MARK: Subviews
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let profileImageButton = UIButton(type: .system)
    private let emailTextField = UITextField()
    private let fullNameTextField = UITextField()
    private let usernameTextField = UITextField()
    private let passwordTextField = UITextField()
    private let signUpButton = UIButton(type: .system)
    
    private let emailAlertLabel = UILabel()
    private let passwordAlertLabel = UILabel()
    
    // MARK: Initialization
    
    init() {
        super.init(frame: .zero)
        
        setupAppearance()
        setupActions()
        setupLayout()
        setupKeyboardObservers()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        removeKeyboardObservers()
    }
}

// MARK: - Public Methods

extension RegistrationView {
    func showEmailAlertLabel() {
        
    }
    
    func hideEmailAlertLabel() {
        
    }
}

// MARK: - Appearance

private extension RegistrationView {
    func setupAppearance() {
        backgroundColor = .systemBackground
        
        setupProfileImageButtonAppearance()
        setupEmailTextFieldAppearance()
        setupFullNameTextFieldAppearance()
        setupUsernameTextFieldAppearance()
        setupPasswordTextFieldAppearance()
        setupSignUpButtonAppearance()
    }
    
    func setupProfileImageButtonAppearance() {
        profileImageButton.setImage(AssetsImages.profileImage, for: .normal)
        profileImageButton.tintColor = Colors.profileImageButtonTintColor
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
    }
}

// MARK: - Actions

private extension RegistrationView {
    func setupActions() {
        signUpButton.addTarget(self, action: #selector(didPressSignUpButton), for: .touchUpInside)
    }
    
    @objc func didPressSignUpButton() {
        delegate?.registrationViewDidPressSignUpButton(self)
    }
}

// MARK: - Layout

private extension RegistrationView {
    func setupLayout() {
        setupSubviews()
        
        setupScrollViewLayout()
        setupContentViewLayout()
        
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
        contentView.addSubview(emailTextField)
        contentView.addSubview(fullNameTextField)
        contentView.addSubview(usernameTextField)
        contentView.addSubview(passwordTextField)
        contentView.addSubview(signUpButton)
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
        RegistrationView.setupStackViewLayout(emailTextField,
                                              superview: contentView,
                                              topView: profileImageButton,
                                              verticalSpace: Metrics.profileImageButtonBottomSpace,
                                              horizontalSpace: Metrics.textFieldHorizontalSpace,
                                              height: Metrics.textFieldHeight)
    }
    
    func setupFullNameTextFieldLayout() {
        RegistrationView.setupStackViewLayout(fullNameTextField,
                                              superview: contentView,
                                              topView: emailTextField,
                                              verticalSpace: Metrics.textFieldBottomSpace,
                                              horizontalSpace: Metrics.textFieldHorizontalSpace,
                                              height: Metrics.textFieldHeight)
    }
    
    func setupUsernameTextFieldLayout() {
        RegistrationView.setupStackViewLayout(usernameTextField,
                                              superview: contentView,
                                              topView: fullNameTextField,
                                              verticalSpace: Metrics.textFieldBottomSpace,
                                              horizontalSpace: Metrics.textFieldHorizontalSpace,
                                              height: Metrics.textFieldHeight)
    }
    
    func setupPasswordTextFieldLayout() {
        RegistrationView.setupStackViewLayout(passwordTextField,
                                              superview: contentView,
                                              topView: usernameTextField,
                                              verticalSpace: Metrics.textFieldBottomSpace,
                                              horizontalSpace: Metrics.textFieldHorizontalSpace,
                                              height: Metrics.textFieldHeight)
    }
    
    func setupSignUpButtonLayout() {
        RegistrationView.setupStackViewLayout(signUpButton,
                                              superview: contentView,
                                              topView: passwordTextField,
                                              verticalSpace: Metrics.signUpButtonTopSpace,
                                              horizontalSpace: Metrics.textFieldHorizontalSpace,
                                              height: Metrics.textFieldHeight)
    }
}

// MARK: - Layout Helpers

private extension RegistrationView {
    static func setupStackViewLayout(
        _ view: UIView,
        superview: UIView,
        topView: UIView,
        verticalSpace: CGFloat,
        horizontalSpace: CGFloat,
        height: CGFloat
    ) {
        view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: verticalSpace),
            view.leftAnchor.constraint(equalTo: superview.leftAnchor, constant: horizontalSpace),
            view.rightAnchor.constraint(equalTo: superview.rightAnchor, constant: -horizontalSpace),
            view.heightAnchor.constraint(equalToConstant: height),
        ])
    }
}

// MARK: - Keyboard Events

private extension RegistrationView {
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

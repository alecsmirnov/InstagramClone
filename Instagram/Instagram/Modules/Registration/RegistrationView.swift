//
//  RegistrationView.swift
//  Instagram
//
//  Created by Admin on 17.01.2021.
//

import UIKit

final class RegistrationView: UIView {
    // MARK: Properties
    
    private enum Metrics {
        static let profileImageButtonTopSpace: CGFloat = 40
        static let profileImageButtonBottomSpace: CGFloat = 20
        static let profileImageButtonSize: CGFloat = 110
        
        static let textFieldBottomSpace: CGFloat = 10
        static let textFieldHorizontalSpace: CGFloat = 40
        static let textFieldHeight: CGFloat = 40
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
        static let textFieldBackground = UIColor(white: 0, alpha: 0.01)
        static let signUpButtonTitle = UIColor.white
        static let signUpButtonBackground = UIColor(red: 0.58, green: 0.8, blue: 0.95, alpha: 1)
    }
    
    private enum Constants {
        static let fontSize: CGFloat = 14
        
        static let signUpButtonCornerRadius: CGFloat = 4
    }
    
    // MARK: Subviews
    
    private let profileImageButton = UIButton(type: .system)
    private let emailTextField = UITextField()
    private let fullNameTextField = UITextField()
    private let usernameTextField = UITextField()
    private let passwordTextField = UITextField()
    private let signUpButton = UIButton(type: .system)
    
    // MARK: Initialization
    
    init() {
        super.init(frame: .zero)
        
        setupAppearance()
//        setupActions()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    }
}

// MARK: - Layout

private extension RegistrationView {
    func setupLayout() {
        setupSubviews()
        
        setupProfileImageButtonLayout()
        setupEmailTextFieldLayout()
        setupFullNameTextFieldLayout()
        setupUsernameTextFieldLayout()
        setupPasswordTextFieldLayout()
        setupSignUpButtonLayout()
    }
    
    func setupSubviews() {
        addSubview(profileImageButton)
        addSubview(emailTextField)
        addSubview(fullNameTextField)
        addSubview(usernameTextField)
        addSubview(passwordTextField)
        addSubview(signUpButton)
    }
    
    func setupProfileImageButtonLayout() {
        profileImageButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            profileImageButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor,
                                                    constant: Metrics.profileImageButtonTopSpace),
            profileImageButton.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            profileImageButton.heightAnchor.constraint(equalToConstant: Metrics.profileImageButtonSize),
            profileImageButton.widthAnchor.constraint(equalToConstant: Metrics.profileImageButtonSize),
        ])
    }
    
    func setupEmailTextFieldLayout() {
        RegistrationView.setupStackViewLayout(emailTextField,
                                              superview: self,
                                              topView: profileImageButton,
                                              verticalSpace: Metrics.profileImageButtonBottomSpace,
                                              horizontalSpace: Metrics.textFieldHorizontalSpace,
                                              height: Metrics.textFieldHeight)
    }
    
    func setupFullNameTextFieldLayout() {
        RegistrationView.setupStackViewLayout(fullNameTextField,
                                              superview: self,
                                              topView: emailTextField,
                                              verticalSpace: Metrics.textFieldBottomSpace,
                                              horizontalSpace: Metrics.textFieldHorizontalSpace,
                                              height: Metrics.textFieldHeight)
    }
    
    func setupUsernameTextFieldLayout() {
        RegistrationView.setupStackViewLayout(usernameTextField,
                                              superview: self,
                                              topView: fullNameTextField,
                                              verticalSpace: Metrics.textFieldBottomSpace,
                                              horizontalSpace: Metrics.textFieldHorizontalSpace,
                                              height: Metrics.textFieldHeight)
    }
    
    func setupPasswordTextFieldLayout() {
        RegistrationView.setupStackViewLayout(passwordTextField,
                                              superview: self,
                                              topView: usernameTextField,
                                              verticalSpace: Metrics.textFieldBottomSpace,
                                              horizontalSpace: Metrics.textFieldHorizontalSpace,
                                              height: Metrics.textFieldHeight)
    }
    
    func setupSignUpButtonLayout() {
        RegistrationView.setupStackViewLayout(signUpButton,
                                              superview: self,
                                              topView: passwordTextField,
                                              verticalSpace: Metrics.textFieldBottomSpace,
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

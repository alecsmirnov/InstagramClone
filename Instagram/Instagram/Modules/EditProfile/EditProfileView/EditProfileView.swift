//
//  EditProfileView.swift
//  Instagram
//
//  Created by Admin on 06.03.2021.
//

import UIKit

final class EditProfileView: UIView {
    // MARK: Properties
    
    var keyboardAppearanceListener: KeyboardAppearanceListener?
    
    // MARK: Subviews
    
    private let scrollView = UIScrollView()
    private let screenView = UIView()
    
    private let profileImageButton = UIButton(type: .system)
    private let changeProfileImageButton = UIButton(type: .system)
    
    private let nameTextField = MaterialTextField()
    private let usernameTextField = MaterialTextField()
    private let websiteTextField = MaterialTextField()
    private let bioTextField = MaterialTextField()
    
    // MARK: Initialization
    
    init() {
        super.init(frame: .zero)
        
        setupAppearance()
        setupLayout()
        
        keyboardAppearanceListener = KeyboardAppearanceListener(delegate: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public Methods

extension EditProfileView {
    func setUser(_ user: User) {
        nameTextField.text = user.fullName
        usernameTextField.text = user.username
        websiteTextField.text = user.website
        bioTextField.text = user.bio
    }
}

// MARK: - Appearance

private extension EditProfileView {
    func setupAppearance() {
        backgroundColor = .systemBackground
        
        setupScrollViewAppearance()
        setupProfileImageButtonAppearance()
        setupChangeProfileImageButtonAppearance()
        setupNameTextFieldAppearance()
        setupUsernameTextFieldAppearance()
        setupWebsiteTextFieldAppearance()
        setupBioTextFieldAppearance()
    }
    
    func setupScrollViewAppearance() {
        scrollView.delaysContentTouches = false
    }
    
    func setupProfileImageButtonAppearance() {
        profileImageButton.setImage(LoginRegistrationConstants.Images.profile, for: .normal)
        profileImageButton.tintColor = LoginRegistrationConstants.Colors.profileImageButtonTint
        profileImageButton.layer.cornerRadius = 80 / 2
        profileImageButton.layer.masksToBounds = true
        profileImageButton.layer.borderColor = LoginRegistrationConstants.Colors.profileImageButtonBorder.cgColor
        profileImageButton.layer.borderWidth = LoginRegistrationConstants.Metrics.profileImageButtonBorderWidth
    }
    
    func setupChangeProfileImageButtonAppearance() {
        changeProfileImageButton.setTitle("Change profile photo", for: .normal)
    }
    
    func setupNameTextFieldAppearance() {
        nameTextField.placeholder = "Name"
        nameTextField.font = .systemFont(ofSize: 15)
    }
    
    func setupUsernameTextFieldAppearance() {
        usernameTextField.placeholder = "Username"
        usernameTextField.font = .systemFont(ofSize: 15)
    }
    
    func setupWebsiteTextFieldAppearance() {
        websiteTextField.placeholder = "Website"
        websiteTextField.font = .systemFont(ofSize: 15)
    }
    
    func setupBioTextFieldAppearance() {
        bioTextField.placeholder = "Bio"
        bioTextField.font = .systemFont(ofSize: 15)
    }
}

// MARK: - Layout

private extension EditProfileView {
    func setupLayout() {
        setupSubviews()
        
        setupScrollViewLayout()
        setupScreenViewLayout()
        setupProfileImageButtonLayout()
        setupChangeProfileImageButtonLayout()
        setupNameTextFieldLayout()
        setupUsernameTextFieldLayout()
        setupWebsiteTextFieldLayout()
        setupBioTextFieldLayout()
    }
    
    func setupSubviews() {
        addSubview(scrollView)
        
        scrollView.addSubview(screenView)
        
        screenView.addSubview(profileImageButton)
        screenView.addSubview(changeProfileImageButton)
        scrollView.addSubview(nameTextField)
        scrollView.addSubview(usernameTextField)
        scrollView.addSubview(websiteTextField)
        scrollView.addSubview(bioTextField)
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
    
    func setupProfileImageButtonLayout() {
        profileImageButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            profileImageButton.topAnchor.constraint(equalTo: screenView.topAnchor, constant: 50),
            profileImageButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            profileImageButton.heightAnchor.constraint(equalToConstant: 80),
            profileImageButton.widthAnchor.constraint(equalToConstant: 80),
        ])
    }
    
    func setupChangeProfileImageButtonLayout() {
        changeProfileImageButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            changeProfileImageButton.topAnchor.constraint(equalTo: profileImageButton.bottomAnchor, constant: 8),
            changeProfileImageButton.centerXAnchor.constraint(equalTo: profileImageButton.centerXAnchor),
        ])
    }
    
    func setupNameTextFieldLayout() {
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: changeProfileImageButton.bottomAnchor, constant: 16),
            nameTextField.leadingAnchor.constraint(equalTo: screenView.leadingAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(equalTo: screenView.trailingAnchor, constant: -16),
        ])
    }
    
    func setupUsernameTextFieldLayout() {
        usernameTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            usernameTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 16),
            usernameTextField.leadingAnchor.constraint(equalTo: screenView.leadingAnchor, constant: 16),
            usernameTextField.trailingAnchor.constraint(equalTo: screenView.trailingAnchor, constant: -16),
        ])
    }
    
    func setupWebsiteTextFieldLayout() {
        websiteTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            websiteTextField.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 16),
            websiteTextField.leadingAnchor.constraint(equalTo: screenView.leadingAnchor, constant: 16),
            websiteTextField.trailingAnchor.constraint(equalTo: screenView.trailingAnchor, constant: -16),
        ])
    }
    
    func setupBioTextFieldLayout() {
        bioTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            bioTextField.topAnchor.constraint(equalTo: websiteTextField.bottomAnchor, constant: 16),
            bioTextField.leadingAnchor.constraint(equalTo: screenView.leadingAnchor, constant: 16),
            bioTextField.trailingAnchor.constraint(equalTo: screenView.trailingAnchor, constant: -16),
        ])
    }
}

// MARK: - KeyboardAppearanceListenerDelegate

extension EditProfileView: KeyboardAppearanceListenerDelegate {
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
        
        scrollView.contentInset.bottom = keyboardSize.cgRectValue.height
        scrollView.verticalScrollIndicatorInsets.bottom = scrollView.contentInset.bottom
    }
    
    func keyboardAppearanceListener(
        _ listener: KeyboardAppearanceListener,
        keyboardWillHideWith notification: Notification
    ) {
        scrollView.contentInset.bottom = 0
        scrollView.verticalScrollIndicatorInsets.bottom = scrollView.contentInset.bottom
    }
}

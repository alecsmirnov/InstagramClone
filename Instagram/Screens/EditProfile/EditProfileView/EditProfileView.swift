//
//  EditProfileView.swift
//  Instagram
//
//  Created by Admin on 06.03.2021.
//

import UIKit

protocol EditProfileViewDelegate: AnyObject {
    func editProfileViewDidPressUsernameTextField(_ editProfileView: EditProfileView)
    func editProfileViewDidPressBioTextField(_ editProfileView: EditProfileView)
}

protocol EditProfileViewProtocol: UIView {
    var user: User? { get set }
    var profileImage: UIImage? { get set }
    var name: String? { get }
    var username: String? { get }
    var website: String? { get }
    var bio: String? { get }
}

protocol EditProfileViewOutputProtocol: AnyObject {
    func didTapProfileImageButton()
    func didTapUsernameTextField()
    func didTapBioTextField()
}

final class EditProfileView: UIView {
    // MARK: Properties
    
    weak var output: EditProfileViewOutputProtocol?
    
    var user: User? {
        didSet {
            guard let user = user else { return }
            
            if let profileImageURL = user.profileImageURL {
                profileImageButton.downloadImage(urlString: profileImageURL)
            }
            
            nameTextField.text = user.fullName
            usernameTextField.text = user.username
            websiteTextField.text = user.website
            bioTextField.text = user.bio
        }
    }
    
    var profileImage: UIImage? {
        get {
            return profileImageButton.image(for: .normal)
        }
        set {
            profileImageButton.setImage(newValue?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
    }
    
    var name: String? {
        return nameTextField.text
    }
    
    var username: String? {
        return usernameTextField.text
    }
    
    var website: String? {
        return websiteTextField.text
    }
    
    var bio: String? {
        return bioTextField.text
    }
    
    private lazy var keyboardAppearanceListener = KeyboardAppearanceListener(delegate: self)
    
    // MARK: Constants
    
    private enum Metrics {
        static let profileImageButtonTopSpace: CGFloat = 30
        static let profileImageButtonSize: CGFloat = 100
        
        static let changeProfileImageButtonTopSpace: CGFloat = 8
        
        static let textFieldTopSpace: CGFloat = 16
        static let textFieldHorizontalSpace: CGFloat = 16
        static let textFieldFontSize: CGFloat = 15
    }
    
    // MARK: Subviews
    
    private let scrollView = UIScrollView()
    private let screenView = UIView()
    
    private let profileImageButton = UIButton(type: .system)
    private let changeProfileImageButton = UIButton(type: .system)
    
    private let nameTextField = MaterialTextField()
    private let usernameTextField = MaterialTextField()
    private let websiteTextField = MaterialTextField()
    private let bioTextField = MaterialTextField()
    
    // MARK: Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupAppearance()
        setupLayout()
        setupActions()
        setupEndEditingGesture()
        keyboardAppearanceListener.setupKeyboardObservers()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        profileImageButton.largeProfileImageStyle()
    }
    
    func setupChangeProfileImageButtonAppearance() {
        changeProfileImageButton.setTitle("Change profile photo", for: .normal)
    }
    
    func setupNameTextFieldAppearance() {
        nameTextField.placeholder = "Name"
        nameTextField.font = .systemFont(ofSize: Metrics.textFieldFontSize)
    }
    
    func setupUsernameTextFieldAppearance() {
        usernameTextField.placeholder = "Username"
        usernameTextField.font = .systemFont(ofSize: Metrics.textFieldFontSize)
    }
    
    func setupWebsiteTextFieldAppearance() {
        websiteTextField.placeholder = "Website"
        websiteTextField.font = .systemFont(ofSize: Metrics.textFieldFontSize)
        websiteTextField.autocapitalizationType = .none
    }
    
    func setupBioTextFieldAppearance() {
        bioTextField.placeholder = "Bio"
        bioTextField.font = .systemFont(ofSize: Metrics.textFieldFontSize)
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
            profileImageButton.topAnchor.constraint(
                equalTo: screenView.topAnchor,
                constant: Metrics.profileImageButtonTopSpace),
            profileImageButton.centerXAnchor.constraint(equalTo: screenView.centerXAnchor),
            profileImageButton.heightAnchor.constraint(equalToConstant: Metrics.profileImageButtonSize),
            profileImageButton.widthAnchor.constraint(equalToConstant: Metrics.profileImageButtonSize),
        ])
    }
    
    func setupChangeProfileImageButtonLayout() {
        changeProfileImageButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            changeProfileImageButton.topAnchor.constraint(
                equalTo: profileImageButton.bottomAnchor,
                constant: Metrics.changeProfileImageButtonTopSpace),
            changeProfileImageButton.centerXAnchor.constraint(equalTo: profileImageButton.centerXAnchor),
        ])
    }
    
    func setupNameTextFieldLayout() {
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(
                equalTo: changeProfileImageButton.bottomAnchor,
                constant: Metrics.textFieldTopSpace),
            nameTextField.leadingAnchor.constraint(
                equalTo: screenView.leadingAnchor,
                constant: Metrics.textFieldHorizontalSpace),
            nameTextField.trailingAnchor.constraint(
                equalTo: screenView.trailingAnchor,
                constant: -Metrics.textFieldHorizontalSpace),
        ])
    }
    
    func setupUsernameTextFieldLayout() {
        usernameTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            usernameTextField.topAnchor.constraint(
                equalTo: nameTextField.bottomAnchor,
                constant: Metrics.textFieldTopSpace),
            usernameTextField.leadingAnchor.constraint(
                equalTo: screenView.leadingAnchor,
                constant: Metrics.textFieldHorizontalSpace),
            usernameTextField.trailingAnchor.constraint(
                equalTo: screenView.trailingAnchor,
                constant: -Metrics.textFieldHorizontalSpace),
        ])
    }
    
    func setupWebsiteTextFieldLayout() {
        websiteTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            websiteTextField.topAnchor.constraint(
                equalTo: usernameTextField.bottomAnchor,
                constant: Metrics.textFieldTopSpace),
            websiteTextField.leadingAnchor.constraint(
                equalTo: screenView.leadingAnchor,
                constant: Metrics.textFieldHorizontalSpace),
            websiteTextField.trailingAnchor.constraint(
                equalTo: screenView.trailingAnchor,
                constant: -Metrics.textFieldHorizontalSpace),
        ])
    }
    
    func setupBioTextFieldLayout() {
        bioTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            bioTextField.topAnchor.constraint(
                equalTo: websiteTextField.bottomAnchor,
                constant: Metrics.textFieldTopSpace),
            bioTextField.leadingAnchor.constraint(
                equalTo: screenView.leadingAnchor,
                constant: Metrics.textFieldHorizontalSpace),
            bioTextField.trailingAnchor.constraint(
                equalTo: screenView.trailingAnchor,
                constant: -Metrics.textFieldHorizontalSpace),
        ])
    }
}

// MARK: - Button and TextField Actions

private extension EditProfileView {
    func setupActions() {
        profileImageButton.addTarget(self, action: #selector(didTapProfileImageButton), for: .touchUpInside)
        changeProfileImageButton.addTarget(self, action: #selector(didTapProfileImageButton), for: .touchUpInside)
        
        usernameTextField.addTarget(self, action: #selector(didTapUsernameTextField), for: .touchDown)
        bioTextField.addTarget(self, action: #selector(didTapBioTextField), for: .touchDown)
    }
    
    @objc func didTapProfileImageButton() {
        output?.didTapProfileImageButton()
    }
    
    @objc func didTapUsernameTextField() {
        endEditing(true)
        
        output?.didTapUsernameTextField()
    }
    
    @objc func didTapBioTextField() {
        endEditing(true)
        
        output?.didTapBioTextField()
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
        
        let keyboardHeight = keyboardSize.cgRectValue.height
        
        scrollView.contentInset.bottom = keyboardHeight
        scrollView.verticalScrollIndicatorInsets.bottom = keyboardHeight
    }
    
    func keyboardAppearanceListener(
        _ listener: KeyboardAppearanceListener,
        keyboardWillHideWith notification: Notification
    ) {
        scrollView.contentInset.bottom = 0
        scrollView.verticalScrollIndicatorInsets.bottom = 0
    }
}

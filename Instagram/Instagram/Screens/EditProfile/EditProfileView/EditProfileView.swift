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

final class EditProfileView: UIView {
    // MARK: Properties
    
    weak var delegate: EditProfileViewDelegate? {
        didSet {
            guard let presentationController = delegate as? UIViewController else { return }
            
            imagePicker = ImagePicker(presentationController: presentationController, delegate: self)
            keyboardAppearanceListener = KeyboardAppearanceListener(delegate: self)
        }
    }
    
    var profileImage: UIImage? {
        return profileImageButton.image(for: .normal)
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
    
    private var imagePicker: ImagePicker?
    private var keyboardAppearanceListener: KeyboardAppearanceListener?
    
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
    
    private let errorLabel = UILabel()
    private let counterLabel = UILabel()
    
    // MARK: Initialization
    
    init() {
        super.init(frame: .zero)
        
        setupAppearance()
        setupLayout()
        setupGestures()
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
        
        profileImageButton.addTarget(self, action: #selector(didPressProfileImageButton), for: .touchUpInside)
    }
    
    func setupChangeProfileImageButtonAppearance() {
        changeProfileImageButton.setTitle("Change profile photo", for: .normal)
        
        changeProfileImageButton.addTarget(self, action: #selector(didPressProfileImageButton), for: .touchUpInside)
    }
    
    @objc func didPressProfileImageButton() {
        imagePicker?.takePhoto()
    }
    
    func setupNameTextFieldAppearance() {
        nameTextField.placeholder = "Name"
        nameTextField.font = .systemFont(ofSize: Metrics.textFieldFontSize)
    }
    
    func setupUsernameTextFieldAppearance() {
        usernameTextField.placeholder = "Username"
        usernameTextField.font = .systemFont(ofSize: Metrics.textFieldFontSize)
        
        usernameTextField.addTarget(self, action: #selector(didPressUsernameTextField), for: .touchDown)
    }
    
    @objc func didPressUsernameTextField() {
        endEditing(true)
        
        delegate?.editProfileViewDidPressUsernameTextField(self)
    }
    
    func setupWebsiteTextFieldAppearance() {
        websiteTextField.placeholder = "Website"
        websiteTextField.font = .systemFont(ofSize: Metrics.textFieldFontSize)
        websiteTextField.autocapitalizationType = .none
    }
    
    func setupBioTextFieldAppearance() {
        bioTextField.placeholder = "Bio"
        bioTextField.font = .systemFont(ofSize: Metrics.textFieldFontSize)
        
        bioTextField.addTarget(self, action: #selector(didPressBioTextField), for: .touchDown)
    }
    
    @objc func didPressBioTextField() {
        endEditing(true)
        
        delegate?.editProfileViewDidPressBioTextField(self)
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

// MARK: - Gestures

private extension EditProfileView {
    func setupGestures() {
//        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
//        
//        addGestureRecognizer(tapGestureRecognizer)
    }
    
//    @objc func dismissKeyboard() {
//        endEditing(true)
//    }
}

// MARK: - ImagePickerDelegate

extension EditProfileView: ImagePickerDelegate {
    func imagePicker(_ imagePicker: ImagePicker, didSelectImage image: UIImage?) {
        profileImageButton.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
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

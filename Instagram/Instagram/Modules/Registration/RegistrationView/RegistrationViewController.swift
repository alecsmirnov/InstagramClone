//
//  RegistrationViewController.swift
//  Instagram
//
//  Created by Admin on 17.01.2021.
//

import UIKit

protocol IRegistrationView: AnyObject {
    var isUserInteractionEnabled: Bool { get set }
    
    func showInvalidEmailWarning()
    func showAlreadyInUseEmailWarning()
    func hideEmailWarning()
    
    func showInvalidUsernameWarning()
    func showAlreadyInUseUsernameWarning()
    func hideUsernameWarning()
    
    func showShortPasswordWarning(lengthMin: Int)
    func hidePasswordWarning()
    
    func enableSignUpButton()
    func disableSignUpButton()
    
    func startAnimatingSignUpButton()
    func stopAnimatingSignUpButton()
}

protocol IRegistrationViewOutput: AnyObject {
    func viewDidLoad()
    
    func emailDidChange(_ email: String)
    func usernameDidChange(_ username: String)
    func passwordDidChange(_ password: String)
    
    func didPressSignUpButton(
        withEmail email: String,
        fullName: String,
        username: String,
        password: String,
        profileImage: UIImage?)
    func didPressLogInButton()
}

final class RegistrationViewController: CustomViewController<RegistrationView> {
    // MARK: Properties
    
    var output: IRegistrationViewOutput?
    
    private lazy var imagePicker = ImagePicker(presentationController: self, delegate: self)
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customView?.output = self
        output?.viewDidLoad()
    }
}

// MARK: - Registration View Input

extension RegistrationViewController: IRegistrationView {
    var isUserInteractionEnabled: Bool {
        get {
            return customView?.isUserInteractionEnabled ?? false
        }
        set {
            customView?.isUserInteractionEnabled = newValue
        }
    }
    
    func showInvalidEmailWarning() {
        customView?.showEmailWarning(text: "Invalid Email address")
    }
    
    func showAlreadyInUseEmailWarning() {
        customView?.showEmailWarning(text: "Email address already in use")
    }
    
    func hideEmailWarning() {
        customView?.hideEmailWarning()
    }
    
    func showInvalidUsernameWarning() {
        customView?.showUsernameWarning(text: "Invalid Username")
    }
    
    func showAlreadyInUseUsernameWarning() {
        customView?.showUsernameWarning(text: "Username already in use")
    }
    
    func hideUsernameWarning() {
        customView?.hideUsernameWarning()
    }
    
    func showShortPasswordWarning(lengthMin: Int) {
        customView?.showPasswordWarning(text: "Password must be \(lengthMin) or more characters")
    }
    
    func hidePasswordWarning() {
        customView?.hidePasswordWarning()
    }
    
    func enableSignUpButton() {
        customView?.enableSignUpButton()
    }
    
    func disableSignUpButton() {
        customView?.disableSignUpButton()
    }
    
    func startAnimatingSignUpButton() {
        customView?.startAnimatingSignUpButton()
    }
    
    func stopAnimatingSignUpButton() {
        customView?.stopAnimatingSignUpButton()
    }
}

// MARK: - Custom View Output

extension RegistrationViewController: RegistrationViewOutputProtocol {
    func emailDidChange(_ email: String) {
        output?.emailDidChange(email)
    }
    
    func usernameDidChange(_ username: String) {
        output?.usernameDidChange(username)
    }
    
    func passwordDidChange(_ password: String) {
        output?.passwordDidChange(password)
    }
    
    func didTapProfileImageButton() {
        imagePicker.takePhoto()
    }
    
    func didTapSignUpButton(
        withEmail email: String,
        fullName: String,
        username: String,
        password: String,
        profileImage: UIImage?
    ) {
        output?.didPressSignUpButton(
            withEmail: email,
            fullName: fullName,
            username: username,
            password: password,
            profileImage: profileImage)
    }
    
    func didTapLogInButton() {
        output?.didPressLogInButton()
    }
}

// MARK: - ImagePickerDelegate

extension RegistrationViewController: ImagePickerDelegate {
    func imagePicker(_ imagePicker: ImagePicker, didSelectImage image: UIImage?) {
        customView?.setProfileImage(image)
    }
}

//
//  RegistrationPresenter.swift
//  Instagram
//
//  Created by Admin on 17.01.2021.
//

import UIKit

final class RegistrationPresenter {
    weak var view: RegistrationViewControllerProtocol?
    weak var coordinator: RegistrationCoordinatorProtocol?
    
    var registrationService: RegistrationServiceProtocol?
    
    private var isEmailChecked = false {
        didSet {
            validateInput()
        }
    }
    
    private var isUsernameChecked = false {
        didSet {
            validateInput()
        }
    }
    
    private var isPasswordChecked = false {
        didSet {
            validateInput()
        }
    }
}

// MARK: - RegistrationView Output

extension RegistrationPresenter: RegistrationViewControllerOutputProtocol {
    func viewDidLoad() {
        view?.disableSignUpButton()
    }
    
    func emailDidChange(_ email: String) {
        registrationService?.checkEmail(email) { [weak self] error in
            if let error = error {
                self?.isEmailChecked = false
                
                switch error {
                case .empty:
                    self?.view?.hideEmailWarning()
                case .invalid:
                    self?.view?.showInvalidEmailWarning()
                case .exist:
                    self?.view?.showAlreadyInUseEmailWarning()
                }
            } else {
                self?.isEmailChecked = true
                
                self?.view?.hideEmailWarning()
            }
        }
    }
    
    func usernameDidChange(_ username: String) {
        registrationService?.checkUsername(username) { [weak self] error in
            if let error = error {
                self?.isUsernameChecked = false
                
                switch error {
                case .empty:
                    self?.view?.hideUsernameWarning()
                case .invalid:
                    self?.view?.showInvalidUsernameWarning()
                case .exist:
                    self?.view?.showAlreadyInUseUsernameWarning()
                }
            } else {
                self?.isUsernameChecked = true
                
                self?.view?.hideUsernameWarning()
            }
        }
    }
    
    func passwordDidChange(_ password: String) {
        registrationService?.checkPassword(password) { [weak self] error in
            if let error = error {
                self?.isPasswordChecked = false
                
                switch error {
                case .empty:
                    self?.view?.hidePasswordWarning()
                case .invalid(let lengthMin):
                    self?.view?.showShortPasswordWarning(lengthMin: lengthMin)
                }
            } else {
                self?.isPasswordChecked = true
                
                self?.view?.hidePasswordWarning()
            }
        }
    }
    
    func didPressSignUpButton(
        withEmail email: String,
        fullName: String?,
        username: String,
        password: String,
        profileImage: UIImage?
    ) {
        view?.isUserInteractionEnabled = false
        view?.disableSignUpButton()
        view?.startAnimatingSignUpButton()
        
        let imageSize = LoginRegistrationConstants.Metrics.profileImageButtonSize
        let profileImageData = profileImage?.resize(
            withWidth: imageSize,
            height: imageSize,
            contentMode: .aspectFill).jpegData(compressionQuality: 1)
        
        registrationService?.signUp(
            withEmail: email,
            fullName: fullName,
            username: username,
            password: password,
            profileImageData: profileImageData) { [weak self] error in
            guard error == nil else {
                self?.view?.showUnknownSignUpAlert()
                
                return
            }
            
            self?.coordinator?.finishSignUp()
        }
    }
    
    func didPressLogInButton() {
        coordinator?.closeRegistrationViewController()
    }
}

// MARK: - Private Methods

private extension RegistrationPresenter {
    func validateInput() {
        if isEmailChecked && isUsernameChecked && isPasswordChecked {
            view?.enableSignUpButton()
        } else {
            view?.disableSignUpButton()
        }
    }
}

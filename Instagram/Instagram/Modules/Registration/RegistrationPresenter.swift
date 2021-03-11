//
//  RegistrationPresenter.swift
//  Instagram
//
//  Created by Admin on 17.01.2021.
//

import UIKit

final class RegistrationPresenter {
    // MARK: Properties
    
    weak var view: IRegistrationView?
    var interactor: IRegistrationInteractor?
    var router: IRegistrationRouter?
    
    private var isEmailChecked = false {
        didSet { validateInput() }
    }
    
    private var isUsernameChecked = false {
        didSet { validateInput() }
    }
    
    private var isPasswordChecked = false {
        didSet { validateInput() }
    }
}

// MARK: - IRegistrationViewOutput

extension RegistrationPresenter: IRegistrationViewOutput {
    func viewDidLoad() {
        view?.disableSignUpButton()
    }
    
    func emailDidChange(_ email: String) {
        interactor?.checkEmail(email)
    }
    
    func usernameDidChange(_ username: String) {
        interactor?.checkUsername(username)
    }
    
    func passwordDidChange(_ password: String) {
        interactor?.checkPassword(password)
    }
    
    func didPressSignUpButton(
        withEmail email: String,
        fullName: String,
        username: String,
        password: String,
        profileImage: UIImage?
    ) {
        view?.isUserInteractionEnabled = false
        view?.disableSignUpButton()
        view?.startAnimatingSignUpButton()
        
        //interactor?.signUp(withInfo: info)
    }
    
    func didPressLogInButton() {
        router?.closeRegistrationViewController()
    }
}

// MARK: - IRegistrationInteractorOutput

extension RegistrationPresenter: IRegistrationInteractorOutput {
    func isValidEmail() {
        isEmailChecked = true
        
        view?.hideEmailWarning()
    }
    
    func isInvalidEmail() {
        isEmailChecked = false
        
        view?.showInvalidEmailWarning()
    }
    
    func isUserWithEmailExist() {
        isEmailChecked = false
        
        view?.showAlreadyInUseEmailWarning()
    }
    
    func isEmptyEmail() {
        isEmailChecked = false
        
        view?.hideEmailWarning()
    }
    
    func isValidUsername() {
        isUsernameChecked = true
        
        view?.hideUsernameWarning()
    }
    
    func isInvalidUsername() {
        isUsernameChecked = false
        
        view?.showInvalidUsernameWarning()
    }
    
    func isUserWithUsernameExist() {
        isUsernameChecked = false
        
        view?.showAlreadyInUseUsernameWarning()
    }
    
    func isEmptyUsername() {
        isUsernameChecked = false
        
        view?.hideUsernameWarning()
    }
    
    func isValidPassword() {
        isPasswordChecked = true
        
        view?.hidePasswordWarning()
    }
    
    func isInvalidPassword(lengthMin: Int) {
        isPasswordChecked = false
        
        view?.showShortPasswordWarning(lengthMin: lengthMin)
    }
    
    func isEmptyPassword() {
        isPasswordChecked = false
        
        view?.hidePasswordWarning()
    }
    
    func signUpSuccess() {
        router?.showTabBarController()
    }
    
    func signUpFailure() {
 
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

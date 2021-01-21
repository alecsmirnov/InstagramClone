//
//  RegistrationInteractor.swift
//  Instagram
//
//  Created by Admin on 17.01.2021.
//

protocol IRegistrationInteractor: AnyObject {
    func checkEmail(_ email: String)
    func checkUsername(_ username: String)
    func checkPassword(_ password: String)
    
    func signUp(withInfo info: Registration)
}

protocol IRegistrationInteractorOutput: AnyObject {
    func isValidEmail()
    func isInvalidEmail()
    func isUserWithEmailExist()
    func isEmptyEmail()
    
    func isValidUsername()
    func isInvalidUsername()
    func isUserWithUsernameExist()
    func isEmptyUsername()
    
    func isValidPassword()
    func isInvalidPassword(lengthMin: Int)
    func isEmptyPassword()
    
    func signUpSuccess()
    func signUpFailure()
}

final class RegistrationInteractor {
    weak var presenter: IRegistrationInteractorOutput?
}

// MARK: - IRegistrationInteractor

extension RegistrationInteractor: IRegistrationInteractor {
    func checkEmail(_ email: String) {
        guard !email.isEmpty else {
            presenter?.isEmptyEmail()
            
            return
        }
        
        guard InputValidation.isValidEmail(email) else {
            presenter?.isInvalidEmail()
            
            return
        }

        FirebaseUserService.isUserExist(withEmail: email) { [self] isExist in
            if isExist {
                presenter?.isUserWithEmailExist()
            } else {
                presenter?.isValidEmail()
            }
        }
    }
    
    func checkUsername(_ username: String) {
        guard !username.isEmpty else {
            presenter?.isEmptyUsername()
            
            return
        }
        
        guard InputValidation.isValidUsername(username) else {
            presenter?.isInvalidUsername()
            
            return
        }
        
        FirebaseUserService.isUserExist(withUsername: username) { [self] isExist in
            if isExist {
                presenter?.isUserWithUsernameExist()
            } else {
                presenter?.isValidUsername()
            }
        }
    }
    
    func checkPassword(_ password: String) {
        guard !password.isEmpty else {
            presenter?.isEmptyPassword()
            
            return
        }
        
        guard InputValidation.passwordLengthMin <= password.count else {
            presenter?.isInvalidPassword(lengthMin: InputValidation.passwordLengthMin)
            
            return
        }
        
        presenter?.isValidPassword()
    }
    
    func signUp(withInfo info: Registration) {
        guard !info.email.isEmpty, !info.username.isEmpty, !info.password.isEmpty else { return }
        
        let profileImageData = info.profileImage?.resize(withWidth: SharedMetrics.profileImageSize,
                                                         height: SharedMetrics.profileImageSize,
                                                         contentMode: .aspectFill).pngData()
        
        FirebaseUserService.createUser(withEmail: info.email,
                                       fullName: info.fullName.isEmpty ? nil : info.fullName,
                                       username: info.username,
                                       password: info.password,
                                       profileImageData: profileImageData) { [self] isUserCreated in
            if isUserCreated {
                presenter?.signUpSuccess()
            } else {
                presenter?.signUpFailure()
            }
        }
    }
}

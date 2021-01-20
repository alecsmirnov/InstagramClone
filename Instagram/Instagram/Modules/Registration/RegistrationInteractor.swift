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
    
    func signUp(withInfo info: RegistrationInfo)
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
    func isInvalidPassword()
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
            presenter?.isInvalidPassword()
            
            return
        }
        
        presenter?.isValidPassword()
    }
    
    func signUp(withInfo info: RegistrationInfo) {
        guard let email = info.email,
              let fullName = (info.fullName?.isEmpty ?? true) ? nil : info.fullName,
              let username = info.username,
              let password = info.password else { return }
        
        let compressedProfileImage = info.profileImage?.resize(withWidth: SharedMetrics.profileImageSize,
                                                               height: SharedMetrics.profileImageSize,
                                                               contentMode: .aspectFill)
        let profileImageData = compressedProfileImage?.pngData()
        
        FirebaseUserService.createUser(withEmail: email,
                                       fullName: fullName,
                                       username: username,
                                       password: password,
                                       profileImageData: profileImageData) { [self] isUserCreated in
            if isUserCreated {
                presenter?.signUpSuccess()
            } else {
                presenter?.signUpFailure()
            }
        }
    }
}

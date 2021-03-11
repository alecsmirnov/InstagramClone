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

        FirebaseAuthService.isUserExist(withEmail: email) { [self] result in
            switch result {
            case .success(let isUserExist):
                if isUserExist {
                    presenter?.isUserWithEmailExist()
                } else {
                    presenter?.isValidEmail()
                }
            case .failure(let error):
                print("Failed to fetch user email status: \(error.localizedDescription)")
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
        
        FirebaseDatabaseService.isUsernameExist(username) { [self] result in
            switch result {
            case .success(let isUsernameExist):
                if isUsernameExist {
                    presenter?.isUserWithUsernameExist()
                } else {
                    presenter?.isValidUsername()
                }
            case .failure(let error):
                print("Failed to fetch username status: \(error.localizedDescription)")
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
        
        let profileImageData = info.profileImage?.resize(
            withWidth: LoginRegistrationConstants.Metrics.profileImageButtonSize,
            height: LoginRegistrationConstants.Metrics.profileImageButtonSize,
            contentMode: .aspectFill).jpegData(compressionQuality: 1)
        
        FirebaseDatabaseService.createUser(
            withEmail: info.email,
            fullName: info.fullName.isEmpty ? nil : info.fullName,
            username: info.username,
            password: info.password,
            profileImageData: profileImageData) { [self] error in
            if let error = error {
                presenter?.signUpFailure()
                
                print("Failed to create user: \(error)")
            } else {
                presenter?.signUpSuccess()
                
                print("User successfully created")
            }
        }
    }
}

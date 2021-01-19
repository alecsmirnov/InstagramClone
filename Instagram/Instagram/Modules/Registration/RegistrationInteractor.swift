//
//  RegistrationInteractor.swift
//  Instagram
//
//  Created by Admin on 17.01.2021.
//

protocol IRegistrationInteractor: AnyObject {
    func isUserExist(withEmail email: String)
    func isUserExist(withUsername username: String)
    
    func signUp(withEmail email: String, fullName: String?, username: String, password: String)
}

protocol IRegistrationInteractorOutput: AnyObject {
    func isUserWithEmailExist()
    func isUserWithEmailNotExist()
    
    func isUserWithUsernameExist()
    func isUserWithUsernameNotExist()
    
    func signUpSuccess()
    func signUpFailure()
}

final class RegistrationInteractor {
    weak var presenter: IRegistrationInteractorOutput?
}

// MARK: - IRegistrationInteractor

extension RegistrationInteractor: IRegistrationInteractor {
    func isUserExist(withEmail email: String) {
        FirebaseUserService.isUserExist(withEmail: email) { [self] isExist in
            if isExist {
                presenter?.isUserWithEmailExist()
            } else {
                presenter?.isUserWithEmailNotExist()
            }
        }
    }
    
    func isUserExist(withUsername username: String) {
        FirebaseUserService.isUserExist(withUsername: username) { [self] isExist in
            if isExist {
                presenter?.isUserWithUsernameExist()
            } else {
                presenter?.isUserWithUsernameNotExist()
            }
        }
    }
    
    func signUp(withEmail email: String, fullName: String?, username: String, password: String) {
        FirebaseUserService.createUser(withEmail: email,
                                       fullName: fullName,
                                       username: username,
                                       password: password) { [self] isUserCreated in
            if isUserCreated {
                presenter?.signUpSuccess()
            } else {
                presenter?.signUpFailure()
            }
        }
    }
}

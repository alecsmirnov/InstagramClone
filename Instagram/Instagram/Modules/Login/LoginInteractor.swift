//
//  LoginInteractor.swift
//  Instagram
//
//  Created by Admin on 24.01.2021.
//

protocol ILoginInteractor: AnyObject {
    func checkEmail(_ email: String)
    func checkPassword(_ password: String)
    
    func signIn(withEmail email: String, password: String)
}

protocol ILoginInteractorOutput: AnyObject {
    func isValidEmail()
    func isInvalidEmail()
    func isEmptyEmail()
    
    func isValidPassword()
    func isInvalidPassword(lengthMin: Int)
    func isEmptyPassword()
    
    func signInSuccess()
    func signInIncorrectUserFailure()
    func signInIncorrectPasswordFailure()
}

final class LoginInteractor {
    weak var presenter: ILoginInteractorOutput?
}

// MARK: - ILoginInteractor

extension LoginInteractor: ILoginInteractor {
    func checkEmail(_ email: String) {
        guard !email.isEmpty else {
            presenter?.isEmptyEmail()
            
            return
        }
        
        guard InputValidation.isValidEmail(email) else {
            presenter?.isInvalidEmail()
            
            return
        }
        
        presenter?.isValidEmail()
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
    
    func signIn(withEmail email: String, password: String) {
        FirebaseAuthService.signIn(withEmail: email, password: password) { [self] result in
            switch result {
            case .success(let userIdentifier):
                presenter?.signInSuccess()
                
                print("User \(userIdentifier) is logged in")
            case .failure(let error):
                switch error {
                case .userNotFound:
                    presenter?.signInIncorrectUserFailure()
                case .wrongPassword:
                    presenter?.signInIncorrectPasswordFailure()
                case .undefined(let error):
                    print("Failed to sign in: \(error.localizedDescription)")
                }
            }
        }
    }
}

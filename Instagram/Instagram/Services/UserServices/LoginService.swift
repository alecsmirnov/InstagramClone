//
//  LoginServiceProtocol.swift
//  Instagram
//
//  Created by Admin on 12.03.2021.
//

struct LoginService {
    // MARK: Constants
    
    enum EmailError: Error {
        case empty
        case invalid
    }

    enum PasswordError: Error {
        case empty
        case invalid(Int)
    }

    enum SignInError: Error {
        case userNotFound
        case wrongPassword
    }
}

// MARK: - Public Methods

extension LoginService {
    func checkEmail(_ email: String, completion: @escaping (EmailError?) -> Void) {
        guard !email.isEmpty else {
            completion(.empty)
            
            return
        }
        
        guard ValidationService.isValidEmail(email) else {
            completion(.invalid)
            
            return
        }
        
        completion(nil)
    }
    
    func checkPassword(_ password: String, completion: @escaping (PasswordError?) -> Void) {
        guard !password.isEmpty else {
            completion(.empty)
            
            return
        }
        
        guard ValidationService.passwordLengthMin <= password.count else {
            completion(.invalid(ValidationService.passwordLengthMin))
            
            return
        }
        
        completion(nil)
    }
    
    func signIn(withEmail email: String, password: String, completion: @escaping (SignInError?) -> Void) {
        FirebaseAuthService.signIn(withEmail: email, password: password) { result in
            switch result {
            case .success(let userIdentifier):
                print("User \(userIdentifier) is logged in")
                
                completion(nil)
            case .failure(let error):
                switch error {
                case .userNotFound:
                    completion(.userNotFound)
                case .wrongPassword:
                    completion(.wrongPassword)
                case .undefined(let error):
                    print("Failed to sign in: \(error.localizedDescription)")
                }
            }
        }
    }
}

//
//  LoginServiceProtocol.swift
//  Instagram
//
//  Created by Admin on 12.03.2021.
//

protocol LoginServiceProtocol {
    func checkEmail(_ email: String, completion: @escaping (LoginServiceErrors.Email?) -> Void)
    func checkPassword(_ password: String, completion: @escaping (LoginServiceErrors.Password?) -> Void)
    func signIn(withEmail email: String, password: String, completion: @escaping (LoginServiceErrors.SignIn?) -> Void)
}

enum LoginServiceErrors {
    enum Email: Error {
        case empty
        case invalid
    }

    enum Password: Error {
        case empty
        case invalid(Int)
    }

    enum SignIn: Error {
        case userNotFound
        case wrongPassword
    }
}

struct LoginService: LoginServiceProtocol {
    func checkEmail(_ email: String, completion: @escaping (LoginServiceErrors.Email?) -> Void) {
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
    
    func checkPassword(_ password: String, completion: @escaping (LoginServiceErrors.Password?) -> Void) {
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
    
    func signIn(withEmail email: String, password: String, completion: @escaping (LoginServiceErrors.SignIn?) -> Void) {
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

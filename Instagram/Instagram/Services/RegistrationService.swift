//
//  RegistrationService.swift
//  Instagram
//
//  Created by Admin on 12.03.2021.
//

import Foundation

protocol RegistrationServiceProtocol {
    func checkEmail(_ email: String, completion: @escaping (RegistrationServiceErrors.Email?) -> Void)
    func checkUsername(_ username: String, completion: @escaping (RegistrationServiceErrors.Username?) -> Void)
    func checkPassword(_ password: String, completion: @escaping (RegistrationServiceErrors.Password?) -> Void)
    func signUp(
        withEmail email: String,
        fullName: String?,
        username: String,
        password: String,
        profileImageData: Data?,
        completion: @escaping (RegistrationServiceErrors.SignUp?) -> Void)
}

enum RegistrationServiceErrors {
    enum Email: Error {
        case empty
        case invalid
        case exist
    }
    
    enum Username: Error {
        case empty
        case invalid
        case exist
    }

    enum Password: Error {
        case empty
        case invalid(Int)
    }

    typealias SignUp = Error
}

struct RegistrationService: RegistrationServiceProtocol {
    func checkEmail(_ email: String, completion: @escaping (RegistrationServiceErrors.Email?) -> Void) {
        guard !email.isEmpty else {
            completion(.empty)
            
            return
        }
        
        guard InputValidation.isValidEmail(email) else {
            completion(.invalid)
            
            return
        }
        
        FirebaseAuthService.isUserExist(withEmail: email) { result in
            switch result {
            case .success(let isUserExist):
                completion(isUserExist ? .exist : nil)
            case .failure(let error):
                print("Failed to fetch user email status: \(error.localizedDescription)")
            }
        }
    }
    
    func checkUsername(_ username: String, completion: @escaping (RegistrationServiceErrors.Username?) -> Void) {
        guard !username.isEmpty else {
            completion(.empty)
            
            return
        }
        
        guard InputValidation.isValidUsername(username) else {
            completion(.invalid)
            
            return
        }
        
        FirebaseDatabaseService.isUsernameExist(username) { result in
            switch result {
            case .success(let isUsernameExist):
                completion(isUsernameExist ? .exist : nil)
            case .failure(let error):
                print("Failed to fetch username status: \(error.localizedDescription)")
            }
        }
    }
    
    func checkPassword(_ password: String, completion: @escaping (RegistrationServiceErrors.Password?) -> Void) {
        guard !password.isEmpty else {
            completion(.empty)
            
            return
        }
        
        guard InputValidation.passwordLengthMin <= password.count else {
            completion(.invalid(InputValidation.passwordLengthMin))
            
            return
        }
        
        completion(nil)
    }
    
    func signUp(
        withEmail email: String,
        fullName: String?,
        username: String,
        password: String,
        profileImageData: Data?,
        completion: @escaping (RegistrationServiceErrors.SignUp?) -> Void
    ) {
        FirebaseDatabaseService.createUser(
            withEmail: email,
            fullName: fullName,
            username: username,
            password: password,
            profileImageData: profileImageData) { error in
            if let error = error {
                print("Failed to create user: \(error)")
                
                completion(error)
            } else {
                print("User successfully created")
                
                completion(nil)
            }
        }
    }
}

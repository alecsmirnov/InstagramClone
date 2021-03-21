//
//  RegistrationService.swift
//  Instagram
//
//  Created by Admin on 12.03.2021.
//

import UIKit

final class RegistrationService: RegistrationServiceProtocol {
    func checkEmail(_ email: String, completion: @escaping (RegistrationServiceResult.CheckEmail?) -> Void) {
        guard !email.isEmpty else {
            completion(.empty)
            
            return
        }
        
        guard ValidationService.isValidEmail(email) else {
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
    
    func checkUsername(_ username: String, completion: @escaping (RegistrationServiceResult.CheckUsername?) -> Void) {
        guard !username.isEmpty else {
            completion(.empty)
            
            return
        }
        
        guard ValidationService.isValidUsername(username) else {
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
    
    func checkPassword(_ password: String, completion: @escaping (RegistrationServiceResult.CheckPassword?) -> Void) {
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
    
    func signUp(
        withEmail email: String,
        fullName: String?,
        username: String,
        password: String,
        profileImage: UIImage?,
        completion: @escaping (RegistrationServiceResult.SignUp?) -> Void
    ) {
        let imageSize = LoginRegistrationConstants.Metrics.profileImageButtonSize
        let profileImageData = profileImage?.resize(
            withWidth: imageSize,
            height: imageSize,
            contentMode: .aspectFill).jpegData(compressionQuality: 1)
        
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

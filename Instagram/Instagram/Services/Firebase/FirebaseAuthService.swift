//
//  FirebaseAuthService.swift
//  Instagram
//
//  Created by Admin on 17.01.2021.
//

import FirebaseAuth

enum FirebaseAuthService {
    // MARK: Errors
    
    enum CreateUserError: Error {
        case emailAlreadyInUse
        case undefined
    }
    
    // MARK: Properties
    
    private static let authReference = FirebaseAuth.Auth.auth()
}

// MARK: - Public Methods

extension FirebaseAuthService {
    static func createUser(
        withEmail email: String,
        password: String,
        completion: @escaping (NetworkResult<String, CreateUserError>) -> Void
    ) {
        authReference.createUser(withEmail: email, password: password) { authDataResult, error in
            guard let userIdentifier = authDataResult?.user.uid else {
                if let error = error as NSError?,
                   let errorCode = AuthErrorCode(rawValue: error.code) {
                    switch errorCode {
                    case .emailAlreadyInUse: completion(.failure(.emailAlreadyInUse))
                    default:                 completion(.failure(.undefined))
                    }
                }
                
                return
            }
            
            completion(.success(userIdentifier))
        }
    }
}

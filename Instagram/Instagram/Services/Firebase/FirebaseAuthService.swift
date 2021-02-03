//
//  FirebaseAuthService.swift
//  Instagram
//
//  Created by Admin on 03.02.2021.
//

import FirebaseAuth

enum FirebaseAuthService {
    // MARK: Properties
    
    static var isUserSignedIn: Bool {
        return authReference.currentUser != nil
    }
    
    static var currentUserIdentifier: String? {
        return authReference.currentUser?.uid
    }
    
    // MARK: Constants
    
    enum SignInError: Error {
        case userNotFound
        case wrongPassword
        case undefined(Error)
    }
    
    // MARK: Properties
    
    private static let authReference = FirebaseAuth.Auth.auth()
}

// MARK: - Public Methods

extension FirebaseAuthService {
    static func isUserExist(withEmail email: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        authReference.fetchSignInMethods(forEmail: email) { providers, error in
            if let error = error {
                completion(.failure(error))
                
                return
            }
        
            completion(.success(providers != nil))
        }
    }
    
    static func createUser(
        withEmail email: String,
        password: String,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        authReference.createUser(withEmail: email, password: password) { authDataResult, error in
            if let error = error {
                completion(.failure(error))
                
                return
            }
            
            if let userIdentifier = authDataResult?.user.uid {
                completion(.success(userIdentifier))
            }
        }
    }
    
    static func signIn(
        withEmail email: String,
        password: String,
        completion: @escaping (Result<String, SignInError>) -> Void
    ) {
        authReference.signIn(withEmail: email, password: password) { authResult, error in
            if let error = error as NSError? {
                switch error.code {
                case AuthErrorCode.userNotFound.rawValue:
                    completion(.failure(.userNotFound))
                case AuthErrorCode.wrongPassword.rawValue:
                    completion(.failure(.wrongPassword))
                default:
                    completion(.failure(.undefined(error)))
                }
                
                return
            }
            
            if let userIdentifier = authResult?.user.uid {
                completion(.success(userIdentifier))
            }
        }
    }
    
    static func signOut() {
        try? authReference.signOut()
    }
}

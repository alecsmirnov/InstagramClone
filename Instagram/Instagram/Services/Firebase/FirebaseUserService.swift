//
//  FirebaseUserService.swift
//  Instagram
//
//  Created by Admin on 19.01.2021.
//

import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

enum FirebaseUserService {
    // MARK: Properties
    
    private static let authReference = FirebaseAuth.Auth.auth()
    private static let databaseReference = Database.database().reference()
    private static let storageReference = Storage.storage().reference()
}

// MARK: - Public Methods

extension FirebaseUserService {
    static func isUserExist(withEmail email: String, completion: @escaping (Bool) -> Void) {
        authReference.fetchSignInMethods(forEmail: email) { providers, error in
            completion(providers != nil && error == nil)
        }
    }
    
    static func isUserExist(withUsername username: String, completion: @escaping (Bool) -> Void) {
        databaseReference.child(FirebaseTables.users)
                         .queryOrdered(byChild: UserNode.CodingKeys.username.rawValue)
                         .queryEqual(toValue: username)
                         .observeSingleEvent(of: .value) { snapshot in
            completion(snapshot.value as? [String: Any] != nil)
        }
    }
    
    static func createUser(
        withEmail email: String,
        fullName: String?,
        username: String,
        password: String,
        profileImageData: Data?,
        completion: @escaping (Bool) -> Void
    ) {
        createUserAccount(withEmail: email, password: password) { result in
            switch result {
            case .success(let identifier):
                createUserRecord(identifier: identifier,
                                 email: email,
                                 fullName: fullName,
                                 username: username) { error in
                    if let error = error {
                        assertionFailure(error.localizedDescription)
                        
                        completion(false)
                    } else {
                        guard let profileImageData = profileImageData else {
                            completion(true)
                            
                            return
                        }
                        
                        uploadUserProfilePNGImageData(profileImageData, identifier: identifier) { error in
                            if let error = error {
                                assertionFailure(error.localizedDescription)
                                
                                completion(false)
                            } else {
                                completion(true)
                            }
                        }
                    }
                }
            case .failure(let error):
                assertionFailure(error.localizedDescription)
                
                completion(false)
            }
        }
    }
}

// MARK: - Private Methods

private extension FirebaseUserService {
    static func createUserAccount(
        withEmail email: String,
        password: String,
        completion: @escaping (NetworkResult<String, Error>) -> Void
    ) {
        authReference.createUser(withEmail: email, password: password) { authDataResult, error in
            guard let userIdentifier = authDataResult?.user.uid else {
                if let error = error {
                    completion(.failure(error))
                }
                
                return
            }
            
            completion(.success(userIdentifier))
        }
    }
    
    static func createUserRecord(
        identifier: String,
        email: String,
        fullName: String?,
        username: String,
        completion: @escaping (Error?) -> Void
    ) {
        let userNode = UserNode(email: email, fullName: fullName, username: username)
        
        if let userDictionary = JSONCoding.toDictionary(userNode) {
            databaseReference.child(FirebaseTables.users)
                             .child(identifier)
                             .setValue(userDictionary) { error, _ in
                completion(error)
            }
        }
    }

    static func uploadUserProfilePNGImageData(_ data: Data,
                                              identifier: String,
                                              completion: @escaping (Error?) -> Void) {
        storageReference.child(FirebaseStorages.profileImages)
                        .child("\(identifier).png")
                        .putData(data, metadata: nil) { _, error in
            completion(error)
        }
    }
}

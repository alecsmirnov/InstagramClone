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
    
    static var currentUserIdentifier: String? {
        return authReference.currentUser?.uid
    }
    
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
                         .queryOrdered(byChild: User.CodingKeys.username.rawValue)
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
                if let profileImageData = profileImageData {
                    uploadUserProfilePNGImageData(profileImageData, identifier: identifier) { result in
                        switch result {
                        case .success(let profileImageURL):
                            createUserRecord(identifier: identifier,
                                             email: email,
                                             fullName: fullName,
                                             username: username,
                                             profileImageURL: profileImageURL) { error in
                                if let error = error {
                                    assertionFailure(error.localizedDescription)
                                }
                                
                                completion(error == nil)
                            }
                        case .failure(let error):
                            assertionFailure(error.localizedDescription)
                        }
                    }
                }
            case .failure(let error):
                assertionFailure(error.localizedDescription)
                
                completion(false)
            }
        }
    }
    
    static func fetchUser(withIdentifier identifier: String, completion: @escaping (User?) -> Void) {
        databaseReference.child(FirebaseTables.users)
                         .child(identifier)
                         .observeSingleEvent(of: .value) { snapshot in
            guard let value = snapshot.value as? [String: Any],
                  let user = JSONCoding.fromDictionary(value,type: User.self) else {
                completion(nil)
                
                return
            }
            
            completion(user)
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
        profileImageURL: String?,
        completion: @escaping (Error?) -> Void
    ) {
        let user = User(email: email, fullName: fullName, username: username, profileImageURL: profileImageURL)
        
        if let userDictionary = JSONCoding.toDictionary(user) {
            databaseReference.child(FirebaseTables.users)
                             .child(identifier)
                             .setValue(userDictionary) { error, _ in
                completion(error)
            }
        }
    }

    static func uploadUserProfilePNGImageData(_ data: Data,
                                              identifier: String,
                                              completion: @escaping (NetworkResult<String, Error>) -> Void) {
        let imageDataReference = storageReference.child(FirebaseStorages.profileImages).child("\(identifier).png")
        
        imageDataReference.putData(data, metadata: nil) { metadata, error in
            guard metadata != nil, error == nil else {
                if let error = error {
                    completion(.failure(error))
                }
                
                return
            }
            
            imageDataReference.downloadURL { url, error in
                guard let urlString = url?.absoluteString, error == nil else {
                    if let error = error {
                        completion(.failure(error))
                    }
                    
                    return
                }
                
                completion(.success(urlString))
            }
        }
    }
}

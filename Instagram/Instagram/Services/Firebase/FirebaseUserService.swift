//
//  FirebaseUserService.swift
//  Instagram
//
//  Created by Admin on 19.01.2021.
//

import FirebaseDatabase

enum FirebaseUserService {
    private static let databaseReference = Database.database().reference()
}

// MARK: - Public Methods

extension FirebaseUserService {
    static func isUsernameExist(_ username: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        databaseReference
            .child(FirebaseTables.users)
            .queryOrdered(byChild: User.CodingKeys.username.rawValue)
            .queryEqual(toValue: username)
            .observeSingleEvent(of: .value) { snapshot in
            let isUsernameExist = snapshot.value as? [String: Any] != nil
                
            completion(.success(isUsernameExist))
        } withCancel: { error in
            completion(.failure(error))
        }
    }
    
    static func createUser(
        withEmail email: String,
        fullName: String?,
        username: String,
        password: String,
        profileImageData: Data?,
        completion: @escaping (Error?) -> Void
    ) {
        FirebaseAuthService.createUser(withEmail: email, password: password) { result in
            switch result {
            case .success(let userIdentifier):
                if let profileImageData = profileImageData {
                    FirebaseStorageService.storeUserProfilePNGImageData(
                        profileImageData,
                        identifier: userIdentifier) { result in
                        switch result {
                        case .success(let profileImageURL):
                            createUserRecord(
                                identifier: userIdentifier,
                                email: email,
                                fullName: fullName,
                                username: username,
                                profileImageURL: profileImageURL) { error in
                                completion(error)
                            }
                        case .failure(let error):
                            completion(error)
                        }
                    }
                } else {
                    createUserRecord(
                        identifier: userIdentifier,
                        email: email,
                        fullName: fullName,
                        username: username,
                        profileImageURL: nil) { error in
                        completion(error)
                    }
                }
            case .failure(let error):
                completion(error)
            }
        }
    }
    
    static func fetchUser(withIdentifier identifier: String, completion: @escaping (Result<User, Error>) -> Void) {
        databaseReference
            .child(FirebaseTables.users)
            .child(identifier)
            .observeSingleEvent(of: .value) { snapshot in
            guard
                let value = snapshot.value as? [String: Any],
                let user = JSONCoding.fromDictionary(value, type: User.self)
            else {
                return
            }
            
            completion(.success(user))
        } withCancel: { error in
            completion(.failure(error))
        }
    }
}

// MARK: - Private Methods

private extension FirebaseUserService {    
    static func createUserRecord(
        identifier: String,
        email: String,
        fullName: String?,
        username: String,
        profileImageURL: String?,
        completion: @escaping (Error?) -> Void
    ) {
        let user = User(fullName: fullName, username: username, profileImageURL: profileImageURL)
        
        if let userDictionary = JSONCoding.toDictionary(user) {
            databaseReference
                .child(FirebaseTables.users)
                .child(identifier)
                .setValue(userDictionary) { error, _ in
                guard error == nil else {
                    completion(error)
                    
                    return
                }
                
                let userPrivateInfo = UserPrivateInfo(email: email, gender: nil, phone: nil)
                
                if let userPrivateInfoDictionary = JSONCoding.toDictionary(userPrivateInfo) {
                    databaseReference
                        .child(FirebaseTables.usersPrivateInfo)
                        .child(identifier)
                        .setValue(userPrivateInfoDictionary) { error, _ in
                        guard error == nil else {
                            databaseReference.child(FirebaseTables.users).child(identifier).removeValue()
                            
                            completion(error)
                            
                            return
                        }
                        
                        completion(nil)
                    }
                }
            }
        }
    }
}

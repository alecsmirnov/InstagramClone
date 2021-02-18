//
//  FirebaseUserService.swift
//  Instagram
//
//  Created by Admin on 19.01.2021.
//

import FirebaseDatabase

enum FirebaseUserService {
    // MARK: Constants
    
    private enum Values {
        static let anyCharacter = "\u{f8ff}"
    }
    
    // MARK: Properties
    
    private static let databaseReference = Database.database().reference()
}

// MARK: - Public Methods

extension FirebaseUserService {
    static func follow(userIdentifier: String, followingUserIdentifier: String) {
        databaseReference
            .child(FirebaseTables.following)
            .child(userIdentifier)
            .child(followingUserIdentifier)
            .setValue(0)
        
        databaseReference
            .child(FirebaseTables.followers)
            .child(followingUserIdentifier)
            .child(userIdentifier)
            .setValue(0)
    }
    
    static func followingCount(identifier: String) {
        databaseReference
            .child(FirebaseTables.following)
            .child(identifier)
            .observeSingleEvent(of: .value) { snapshot in
            print(snapshot.childrenCount)
        }
    }
}

extension FirebaseUserService {
    static func isUsernameExist(_ username: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        let lowercasedUsername = username.lowercased()
        
        databaseReference
            .child(FirebaseTables.users)
            .queryOrdered(byChild: User.CodingKeys.username.rawValue)
            .queryEqual(toValue: lowercasedUsername)
            .observeSingleEvent(of: .value) { snapshot in
            completion(.success(snapshot.exists()))
        } withCancel: { error in
            completion(.failure(error))
        }
    }
    
    static func isUsernamePrefixExist(_ usernamePrefix: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        let lowercasedUsername = usernamePrefix.lowercased()
        
        databaseReference
            .child(FirebaseTables.users)
            .queryOrdered(byChild: User.CodingKeys.username.rawValue)
            .queryStarting(atValue: lowercasedUsername)
            .queryEnding(atValue: lowercasedUsername + Values.anyCharacter)
            .observeSingleEvent(of: .value) { snapshot in
            completion(.success(snapshot.exists()))
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
                let lowercasedUsername = username.lowercased()
                
                if let profileImageData = profileImageData {
                    FirebaseStorageService.storeUserProfileImageData(
                        profileImageData,
                        identifier: userIdentifier) { result in
                        switch result {
                        case .success(let profileImageURL):
                            createUserRecord(
                                identifier: userIdentifier,
                                email: email,
                                fullName: fullName,
                                username: lowercasedUsername,
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
                        username: lowercasedUsername,
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
                var user = JSONCoding.fromDictionary(value, type: User.self)
            else {
                return
            }
            
            user.identifier = identifier
            
            completion(.success(user))
        } withCancel: { error in
            completion(.failure(error))
        }
    }
    
    static func fetchUsers(
        by username: String,
        completion: @escaping (Result<User, Error>) -> Void
    ) -> FirebaseObserver {
        let lowercasedUsername = username.lowercased()
        
        let usersReference = databaseReference.child(FirebaseTables.users)
        
        let userAddedHandle = usersReference
            .queryOrdered(byChild: User.CodingKeys.username.rawValue)
            .queryStarting(atValue: lowercasedUsername)
            .queryEnding(atValue: lowercasedUsername + Values.anyCharacter)
            .observe(.childAdded) { snapshot in
            guard
                let value = snapshot.value as? [String: Any],
                var user = JSONCoding.fromDictionary(value, type: User.self)
            else {
                return
            }
            
            let userIdentifier = snapshot.key
            user.identifier = userIdentifier
            
            completion(.success(user))
        } withCancel: { error in
            completion(.failure(error))
        }
        
        let userAddedObserver = FirebaseObserver(reference: usersReference, handle: userAddedHandle)
        
        return userAddedObserver
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

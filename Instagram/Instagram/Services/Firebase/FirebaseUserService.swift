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
            guard error == nil else {
                print("Failed to fetch email status: \(error?.localizedDescription ?? "")")
                
                completion(false)
                
                return
            }
        
            completion(providers != nil)
        }
    }
    
    static func isUserExist(withUsername username: String, completion: @escaping (Bool) -> Void) {
        databaseReference
            .child(FirebaseTables.users)
            .queryOrdered(byChild: User.CodingKeys.username.rawValue)
            .queryEqual(toValue: username)
            .observeSingleEvent(of: .value) { snapshot in
            completion(snapshot.value as? [String: Any] != nil)
        } withCancel: { error in
            print("Failed to fetch username status: \(error.localizedDescription)")
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
        createUserAccount(withEmail: email, password: password) { userIdentifier in
            guard let userIdentifier = userIdentifier else {
                completion(false)
                
                return
            }
            
            if let profileImageData = profileImageData {
                uploadUserProfilePNGImageData(profileImageData, identifier: userIdentifier) { profileImageURL in
                    guard let profileImageURL = profileImageURL else {
                        completion(false)
                        
                        return
                    }
                    
                    createUserRecord(
                        identifier: userIdentifier,
                        email: email,
                        fullName: fullName,
                        username: username,
                        profileImageURL: profileImageURL) { isUserCreated in
                        completion(isUserCreated)
                    }
                }
            } else {
                createUserRecord(
                    identifier: userIdentifier,
                    email: email,
                    fullName: fullName,
                    username: username,
                    profileImageURL: nil) { isUserCreated in
                    completion(isUserCreated)
                }
            }
        }
    }
    
    static func fetchUser(withIdentifier identifier: String, completion: @escaping (User?) -> Void) {
        databaseReference
            .child(FirebaseTables.users)
            .child(identifier)
            .observeSingleEvent(of: .value) { snapshot in
            guard
                let value = snapshot.value as? [String: Any],
                let user = JSONCoding.fromDictionary(value, type: User.self)
            else {
                completion(nil)
                
                return
            }
            
            completion(user)
        } withCancel: { error in
            print("Failed to fetch user: \(error.localizedDescription)")
        }
    }
}

// MARK: - Private Methods

private extension FirebaseUserService {
    static func createUserAccount(
        withEmail email: String,
        password: String,
        completion: @escaping (String?) -> Void
    ) {
        authReference.createUser(withEmail: email, password: password) { authDataResult, error in
            guard let userIdentifier = authDataResult?.user.uid, error == nil else {
                print("Failed to create user account: \(error?.localizedDescription ?? "")")
                
                completion(nil)
                
                return
            }
            
            completion(userIdentifier)
        }
    }
    
    static func createUserRecord(
        identifier: String,
        email: String,
        fullName: String?,
        username: String,
        profileImageURL: String?,
        completion: @escaping (Bool) -> Void
    ) {
        let user = User(email: email, fullName: fullName, username: username, profileImageURL: profileImageURL)
        
        if let userDictionary = JSONCoding.toDictionary(user) {
            databaseReference
                .child(FirebaseTables.users)
                .child(identifier)
                .setValue(userDictionary) { error, _ in
                guard error == nil else {
                    print("Failed to create user record: \(error?.localizedDescription ?? "")")
                    
                    completion(false)
                    
                    return
                }
                    
                completion(true)
            }
        }
    }

    static func uploadUserProfilePNGImageData(
        _ data: Data,
        identifier: String,
        completion: @escaping (String?) -> Void
    ) {
        let imageDataReference = storageReference.child(FirebaseStorages.profileImages).child("\(identifier).png")
        
        imageDataReference.putData(data, metadata: nil) { metadata, error in
            guard metadata != nil, error == nil else {
                print("Failed to upload user profile image data: \(error?.localizedDescription ?? "")")
                
                completion(nil)
                
                return
            }
            
            imageDataReference.downloadURL { url, error in
                guard let urlString = url?.absoluteString, error == nil else {
                    print("Failed to download user profile image data URL: \(error?.localizedDescription ?? "")")
                    
                    completion(nil)
                    
                    return
                }
                
                completion(urlString)
            }
        }
    }
}

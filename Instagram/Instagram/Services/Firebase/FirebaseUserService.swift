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
                updateUser(
                    identifier: userIdentifier,
                    fullName: fullName,
                    username: username,
                    bio: nil,
                    website: nil,
                    profileImageData: profileImageData,
                    completion: completion)
                
//                let lowercasedUsername = username.lowercased()
//
//                if let profileImageData = profileImageData {
//                    FirebaseStorageService.storeUserProfileImageData(
//                        profileImageData,
//                        identifier: userIdentifier) { result in
//                        switch result {
//                        case .success(let profileImageURL):
//                            createUserRecord(
//                                identifier: userIdentifier,
//                                email: email,
//                                fullName: fullName,
//                                username: lowercasedUsername,
//                                profileImageURL: profileImageURL) { error in
//                                completion(error)
//                            }
//                        case .failure(let error):
//                            completion(error)
//                        }
//                    }
//                } else {
//                    createUserRecord(
//                        identifier: userIdentifier,
//                        email: email,
//                        fullName: fullName,
//                        username: lowercasedUsername,
//                        profileImageURL: nil) { error in
//                        completion(error)
//                    }
//                }
            case .failure(let error):
                completion(error)
            }
        }
    }
    
    static func updateUser(
        identifier: String,
        fullName: String?,
        username: String,
        bio: String?,
        website: String?,
        profileImageData: Data?,
        completion: @escaping (Error?) -> Void
    ) {
        let lowercasedUsername = username.lowercased()
        
        if let profileImageData = profileImageData {
            FirebaseStorageService.storeUserProfileImageData(
                profileImageData,
                identifier: identifier) { result in
                switch result {
                case .success(let profileImageURL):
                    createUserRecord(
                        identifier: identifier,
                        fullName: fullName,
                        username: lowercasedUsername,
                        profileImageURL: profileImageURL,
                        bio: bio,
                        website: website) { error in
                        completion(error)
                    }
                case .failure(let error):
                    completion(error)
                }
            }
        } else {
            createUserRecord(
                identifier: identifier,
                fullName: fullName,
                username: lowercasedUsername,
                profileImageURL: nil,
                bio: bio,
                website: website) { error in
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
    
    static func observeUser(
        identifier: String,
        completion: @escaping (Result<User, Error>) -> Void
    ) -> FirebaseObserver {
        let usersReference = databaseReference.child(FirebaseTables.users)
        let usersHandle = usersReference.observe(.childChanged) { snapshot in
            guard identifier == snapshot.key else {
                return
            }
            
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
        
        let usersObserver = FirebaseObserver(reference: usersReference, handle: usersHandle)
        
        return usersObserver
    }
    
    static func fetchFollowersFollowing(
        identifier: String,
        table: String,
        completion: @escaping (Result<[User], Error>) -> Void
    ) {
        databaseReference
            .child(table)
            .child(identifier)
            .observeSingleEvent(of: .value) { snapshot in
            guard let value = snapshot.value as? [String: Any] else { return }
            
            let dispatchGroup = DispatchGroup()
            var users = [User]()
            var fetchErrors = [Error]()
            
            value.forEach { userIdentifier, _ in
                dispatchGroup.enter()
                
                fetchUser(withIdentifier: userIdentifier) { result in
                    switch result {
                    case .success(let user):
                        users.append(user)
                    case .failure(let error):
                        fetchErrors.append(error)
                    }
                    
                    dispatchGroup.leave()
                }
            }
            
            dispatchGroup.notify(queue: .main) {
                if let error = fetchErrors.first {
                    completion(.failure(error))
                } else {
                    completion(.success(users))
                }
            }
        } withCancel: { error in
            completion(.failure(error))
        }
    }
    
    static func fetchFromBeginUsers(
        by username: String,
        dropFirst: Bool = false,
        limit: UInt,
        completion: @escaping (Result<[User], Error>) -> Void
    ) {
        let lowercasedUsername = username.lowercased()
        
        databaseReference
            .child(FirebaseTables.users)
            .queryOrdered(byChild: User.CodingKeys.username.rawValue)
            .queryStarting(atValue: lowercasedUsername)
            .queryEnding(atValue: lowercasedUsername + Values.anyCharacter)
            .queryLimited(toFirst: limit)
            .observeSingleEvent(of: .value) { snapshot in
            var users = [User]()
            
            for child in snapshot.children {
                guard
                    let childSnapshot = child as? DataSnapshot,
                    let childValue = childSnapshot.value as? [String: Any],
                    var user = JSONCoding.fromDictionary(childValue, type: User.self)
                else {
                    return
                }
                
                let userIdentifier = childSnapshot.key
                user.identifier = userIdentifier
                
                users.append(user)
            }
            
            if dropFirst {
                completion(.success(Array(users.dropFirst())))
            } else {
                completion(.success(users))
            }
        } withCancel: { error in
            completion(.failure(error))
        }
    }
    
    static func isFollowingUser(
        currentUserIdentifier: String,
        followingUserIdentifier: String,
        completion: @escaping (Result<Bool, Error>) -> Void
    ) {
        databaseReference
            .child(FirebaseTables.following)
            .child(currentUserIdentifier)
            .child(followingUserIdentifier)
            .observeSingleEvent(of: .value) { snapshot in
            completion(.success(snapshot.exists()))
        } withCancel: { error in
            completion(.failure(error))
        }
    }
    
    static func followUserAndFeed(
        currentUserIdentifier: String,
        followingUserIdentifier: String,
        completion: @escaping (Error?) -> Void
    ) {
        let followingUserReference = databaseReference
            .child(FirebaseTables.following)
            .child(currentUserIdentifier)
            .child(followingUserIdentifier)
        
        followingUserReference.setValue(0) { error, _ in
            guard error == nil else {
                completion(error)
                
                return
            }
            
            databaseReference
                .child(FirebaseTables.followers)
                .child(followingUserIdentifier)
                .child(currentUserIdentifier)
                .setValue(0) { error, _ in
                guard error == nil else {
                    followingUserReference.removeValue()
                    
                    completion(error)
                    
                    return
                }
                
                copyUserFeed(
                    currentUserIdentifier: currentUserIdentifier,
                    followingUserIdentifier: followingUserIdentifier,
                    completion: completion)
            }
        }
    }
    
    static func unfollowUserAndFeed(
        currentUserIdentifier: String,
        followingUserIdentifier: String,
        completion: @escaping (Error?) -> Void
    ) {
        databaseReference
            .child(FirebaseTables.following)
            .child(currentUserIdentifier)
            .child(followingUserIdentifier)
            .removeValue() { error, _ in
            guard error == nil else {
                completion(error)
                
                return
            }
            
            databaseReference
                .child(FirebaseTables.followers)
                .child(followingUserIdentifier)
                .child(currentUserIdentifier)
                .removeValue() { error, _ in
                guard error == nil else {
                    completion(error)
                    
                    return
                }
                
                removeUserFeed(
                    currentUserIdentifier: currentUserIdentifier,
                    followingUserIdentifier: followingUserIdentifier,
                    completion: completion)
            }
        }
    }
    
    static func fetchFollowersUsersIdentifiers(
        identifier: String,
        completion: @escaping (Result<[String], Error>) -> Void
    ) {
        fetchFollowingFollowersUsersIdentifiers(
            identifier: identifier,
            table: FirebaseTables.followers,
            completion: completion)
    }
    
    static func fetchFollowingUsersIdentifiers(
        identifier: String,
        completion: @escaping (Result<[String], Error>) -> Void
    ) {
        fetchFollowingFollowersUsersIdentifiers(
            identifier: identifier,
            table: FirebaseTables.following,
            completion: completion)
    }
}

// MARK: - Private Methods

private extension FirebaseUserService {    
    static func createUserRecord(
        identifier: String,
        email: String? = nil,
        fullName: String?,
        username: String,
        profileImageURL: String?,
        bio: String? = nil,
        website: String? = nil,
        completion: @escaping (Error?) -> Void
    ) {
        let user = User(
            fullName: fullName,
            username: username,
            profileImageURL: profileImageURL,
            bio: bio,
            website: website)
        
        if let userDictionary = JSONCoding.toDictionary(user) {
            let userReference = databaseReference.child(FirebaseTables.users).child(identifier)
            
            userReference.setValue(userDictionary) { error, _ in
                guard error == nil else {
                    completion(error)
                    
                    return
                }
                
                guard let email = email else {
                    completion(nil)
                    
                    return
                }
                
                let userPrivateInfo = UserPrivateInfo(email: email, gender: nil, phone: nil)
                
                if let userPrivateInfoDictionary = JSONCoding.toDictionary(userPrivateInfo) {
                    databaseReference
                        .child(FirebaseTables.usersPrivateInfo)
                        .child(identifier)
                        .setValue(userPrivateInfoDictionary) { error, _ in
                        guard error == nil else {
                            userReference.removeValue()
                            
                            completion(error)
                            
                            return
                        }
                        
                        completion(nil)
                    }
                }
            }
        }
    }
    
    static func copyUserFeed(
        currentUserIdentifier: String,
        followingUserIdentifier: String,
        completion: @escaping (Error?) -> Void
    ) {
        databaseReference
            .child(FirebaseTables.posts)
            .child(followingUserIdentifier)
            .observeSingleEvent(of: .value) { snapshot in
            guard let value = snapshot.value as? [String: Any] else {
                completion(nil)
                
                return
            }
            
            let dispatchGroup = DispatchGroup()
            var removedFeedErrors = [Error]()
            
            value.forEach { postIdentifier, postValue in
                guard
                    let childValue = postValue as? [String: Any],
                    let post = JSONCoding.fromDictionary(childValue, type: Post.self)
                else {
                    return
                }
                
                dispatchGroup.enter()
                
                let feedPost = FeedPost(userIdentifier: followingUserIdentifier, timestamp: post.timestamp)
                
                if let feedPostDictionary = JSONCoding.toDictionary(feedPost) {
                    databaseReference
                        .child(FirebaseTables.usersFeed)
                        .child(currentUserIdentifier)
                        .child(postIdentifier)
                        .setValue(feedPostDictionary) { error, _ in
                        if let error = error {
                            removedFeedErrors.append(error)
                        }
                        
                        dispatchGroup.leave()
                    }
                }
            }
            
            dispatchGroup.notify(queue: .main) {
                let error = removedFeedErrors.first
                
                completion(error)
            }
        } withCancel: { error in
            completion(error)
        }
    }
    
    static func removeUserFeed(
        currentUserIdentifier: String,
        followingUserIdentifier: String,
        completion: @escaping (Error?) -> Void
    ) {
        databaseReference
            .child(FirebaseTables.posts)
            .child(followingUserIdentifier)
            .observeSingleEvent(of: .value) { snapshot in
            guard let value = snapshot.value as? [String: Any] else {
                completion(nil)
                
                return
            }
            
            let dispatchGroup = DispatchGroup()
            var removedFeedErrors = [Error]()
                
            value.forEach { postIdentifier, postValue in
                guard (postValue as? [String: Any]) != nil else { return }
                
                dispatchGroup.enter()
                
                databaseReference
                    .child(FirebaseTables.usersFeed)
                    .child(currentUserIdentifier)
                    .child(postIdentifier)
                    .removeValue { error, _ in
                    if let error = error {
                        removedFeedErrors.append(error)
                    }
                    
                    dispatchGroup.leave()
                }
            }
            
            dispatchGroup.notify(queue: .main) {
                let error = removedFeedErrors.first
                
                completion(error)
            }
        } withCancel: { error in
            completion(error)
        }
    }
    
    static func fetchFollowingFollowersUsersIdentifiers(
        identifier: String,
        table: String,
        completion: @escaping (Result<[String], Error>) -> Void
    ) {
        databaseReference
            .child(table)
            .child(identifier)
            .observeSingleEvent(of: .value) { snapshot in
            guard let value = snapshot.value as? [String: Any] else {
                completion(.success([]))
                
                return
            }
            
            let identifiers = value.keys.map { $0.description }
            
            completion(.success(identifiers))
        } withCancel: { error in
            completion(.failure(error))
        }
    }
}

//
//  FirebaseDatabaseService.swift
//  Instagram
//
//  Created by Admin on 03.02.2021.
//

import FirebaseDatabase
import CoreGraphics

struct FirebaseObserver {
    // MARK: Properties
    
    private let reference: DatabaseReference
    private let handle: UInt
    
    // MARK: Initialization
    
    init(reference: DatabaseReference, handle: UInt) {
        self.reference = reference
        self.handle = handle
    }
    
    // MARK: Public Methods
    
    func remove() {
        reference.removeObserver(withHandle: handle)
    }
}

enum FirebaseDatabaseService {
    // MARK: Constants
    
    private enum Tables {
        static let users = "users"
        static let usersPrivateInfo = "users_private_info"
        
        static let usersFeed = "users_feed"
        
        static let posts = "posts"
        static let postsComments = "posts_comments"
        static let postsLikes = "posts_likes"
        static let postsBookmarks = "posts_bookmarks"
        
        static let followers = "followers"
        static let following = "following"
    }
    
    private enum Values {
        static let anyCharacter = "\u{f8ff}"
    }
    
    // MARK: Properties
    
    private static let databaseReference = Database.database().reference()
}

// MARK: - User Public Methods

extension FirebaseDatabaseService {
    static func isUsernameExist(_ username: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        let lowercasedUsername = username.lowercased()
        
        databaseReference
            .child(Tables.users)
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
            .child(Tables.users)
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
                    userIdentifier: userIdentifier,
                    email: email,
                    fullName: fullName,
                    username: username,
                    bio: nil,
                    website: nil,
                    profileImageData: profileImageData,
                    completion: completion)
            case .failure(let error):
                completion(error)
            }
        }
    }
    
    static func updateUser(
        userIdentifier: String,
        email: String?,
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
                userIdentifier: userIdentifier,
                data: profileImageData) { result in
                switch result {
                case .success(let profileImageURL):
                    createUserRecord(
                        userIdentifier: userIdentifier,
                        email: email,
                        fullName: fullName,
                        username: lowercasedUsername,
                        profileImageURL: profileImageURL,
                        bio: bio,
                        website: website,
                        completion: completion)
                case .failure(let error):
                    completion(error)
                }
            }
        } else {
            createUserRecord(
                userIdentifier: userIdentifier,
                email: email,
                fullName: fullName,
                username: lowercasedUsername,
                profileImageURL: nil,
                bio: bio,
                website: website,
                completion: completion)
        }
    }
    
    static func fetchUser(userIdentifier: String, completion: @escaping (Result<User, Error>) -> Void) {
        databaseReference
            .child(Tables.users)
            .child(userIdentifier)
            .observeSingleEvent(of: .value) { snapshot in
            guard
                let value = snapshot.value as? [String: Any],
                var user = JSONCoding.fromDictionary(value, type: User.self)
            else {
                return
            }
            
            user.identifier = userIdentifier
            
            completion(.success(user))
        } withCancel: { error in
            completion(.failure(error))
        }
    }
    
    static func observeUser(
        userIdentifier: String,
        completion: @escaping (Result<User, Error>) -> Void
    ) -> FirebaseObserver {
        let usersReference = databaseReference.child(Tables.users)
        let usersHandle = usersReference.observe(.childChanged) { snapshot in
            guard userIdentifier == snapshot.key else {
                return
            }
            
            guard
                let value = snapshot.value as? [String: Any],
                var user = JSONCoding.fromDictionary(value, type: User.self)
            else {
                return
            }
            
            user.identifier = userIdentifier

            completion(.success(user))
        } withCancel: { error in
            completion(.failure(error))
        }
        
        let usersObserver = FirebaseObserver(reference: usersReference, handle: usersHandle)
        
        return usersObserver
    }
    
    static func fetchUsersFromBegin(
        startAtUsername username: String,
        dropFirst: Bool = false,
        limit: UInt,
        completion: @escaping (Result<[User], Error>) -> Void
    ) {
        let lowercasedUsername = username.lowercased()
        
        databaseReference
            .child(Tables.users)
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
                
                user.identifier = childSnapshot.key
                
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
            .child(Tables.following)
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
            .child(Tables.following)
            .child(currentUserIdentifier)
            .child(followingUserIdentifier)
        
        followingUserReference.setValue(0) { error, _ in
            guard error == nil else {
                completion(error)
                
                return
            }
            
            databaseReference
                .child(Tables.followers)
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
            .child(Tables.following)
            .child(currentUserIdentifier)
            .child(followingUserIdentifier)
            .removeValue() { error, _ in
            guard error == nil else {
                completion(error)
                
                return
            }
            
            databaseReference
                .child(Tables.followers)
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
}

// MARK: - User Private Methods

private extension FirebaseDatabaseService {
    static func createUserRecord(
        userIdentifier: String,
        email: String?,
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
            let userReference = databaseReference.child(Tables.users).child(userIdentifier)
            
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
                        .child(Tables.usersPrivateInfo)
                        .child(userIdentifier)
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
            .child(Tables.posts)
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
                        .child(Tables.usersFeed)
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
            .child(Tables.posts)
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
                    .child(Tables.usersFeed)
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
}

// MARK: - User Stats Public Methods

extension FirebaseDatabaseService {
    static func observeUserStats(
        userIdentifier: String,
        completion: @escaping (Result<UserStats, Error>) -> Void
    ) -> [FirebaseObserver] {
        let postsReference = databaseReference.child(Tables.posts).child(userIdentifier)
        let followersReference = databaseReference.child(Tables.followers).child(userIdentifier)
        let followingReference = databaseReference.child(Tables.following).child(userIdentifier)
        
        let postsHandle = postsReference.observe(.value) { snapshot in
            fetchUserStats(userIdentifier: userIdentifier, completion: completion)
        } withCancel: { error in
            completion(.failure(error))
        }
        
        let followersHandle = followersReference.observe(.value) { snapshot in
            fetchUserStats(userIdentifier: userIdentifier, completion: completion)
        } withCancel: { error in
            completion(.failure(error))
        }
        
        let followingHandle = followingReference.observe(.value) { snapshot in
            fetchUserStats(userIdentifier: userIdentifier, completion: completion)
        } withCancel: { error in
            completion(.failure(error))
        }
        
        let postsObserver = FirebaseObserver(reference: postsReference, handle: postsHandle)
        let followersObserver = FirebaseObserver(reference: followersReference, handle: followersHandle)
        let followingObserver = FirebaseObserver(reference: followingReference, handle: followingHandle)
        
        return [postsObserver, followersObserver, followingObserver]
    }
    
    private static func fetchUserStats(
        userIdentifier: String,
        completion: @escaping (Result<UserStats, Error>) -> Void
    ) {
        databaseReference
            .child(Tables.posts)
            .child(userIdentifier)
            .observeSingleEvent(of: .value) { snapshot in
            var postsCount = 0
                
            if let value = snapshot.value as? [String: Any] {
                postsCount = value.count
            }
            
            databaseReference
                .child(Tables.followers)
                .child(userIdentifier)
                .observeSingleEvent(of: .value) { snapshot in
                var followersCount = 0
                    
                if let value = snapshot.value as? [String: Any] {
                    followersCount = value.count
                }
                
                databaseReference
                    .child(Tables.following)
                    .child(userIdentifier)
                    .observeSingleEvent(of: .value) { snapshot in
                    var followingCount = 0
                        
                    if let value = snapshot.value as? [String: Any] {
                        followingCount = value.count
                    }
                    
                    let userStats = UserStats(posts: postsCount, followers: followersCount, following: followingCount)
                    
                    completion(.success(userStats))
                } withCancel: { error in
                    completion(.failure(error))
                }
            } withCancel: { error in
                completion(.failure(error))
            }
            
        } withCancel: { error in
            completion(.failure(error))
        }
    }
    
    static func fetchUserFollowersCount(userIdentifier: String, completion: @escaping (Result<Int, Error>) -> Void) {
        fetchUserFollowersFollowingCount(
            table: Tables.followers,
            userIdentifier: userIdentifier,
            completion: completion)
    }
    
    static func fetchUserFollowingCount(userIdentifier: String, completion: @escaping (Result<Int, Error>) -> Void) {
        fetchUserFollowersFollowingCount(
            table: Tables.following,
            userIdentifier: userIdentifier,
            completion: completion)
    }
}

// MARK: - User Stats Private Methods

private extension FirebaseDatabaseService {
    private static func fetchUserFollowersFollowingCount(
        table: String,
        userIdentifier: String,
        completion: @escaping (Result<Int, Error>) -> Void
    ) {
        databaseReference
            .child(table)
            .child(userIdentifier)
            .observeSingleEvent(of: .value) { snapshot in
            var usersCount = 0
                
            if let value = snapshot.value as? [String: Any] {
                usersCount = value.count
            }
            
            completion(.success(usersCount))
        } withCancel: { error in
            completion(.failure(error))
        }
    }
}

// MARK: - User Followers/Following Public Methods

extension FirebaseDatabaseService {
    static func fetchFollowersWithKindFromBegin(
        currentUserIdentifier: String,
        userIdentifier: String,
        startAtUserIdentifier startingUserIdentifier: String = "",
        dropFirst: Bool = false,
        limit: UInt,
        completion: @escaping (Result<[User], Error>) -> Void
    ) {
        fetchFollowersFollowingWithKindFromBegin(
            currentUserIdentifier: currentUserIdentifier,
            userIdentifier: userIdentifier,
            table: Tables.followers,
            startAtUserIdentifier: startingUserIdentifier,
            dropFirst: dropFirst,
            limit: limit,
            completion: completion)
    }
    
    static func fetchFollowingWithKindFromBegin(
        currentUserIdentifier: String,
        userIdentifier: String,
        startAtUserIdentifier startingUserIdentifier: String = "",
        dropFirst: Bool = false,
        limit: UInt,
        completion: @escaping (Result<[User], Error>) -> Void
    ) {
        fetchFollowersFollowingWithKindFromBegin(
            currentUserIdentifier: currentUserIdentifier,
            userIdentifier: userIdentifier,
            table: Tables.following,
            startAtUserIdentifier: startingUserIdentifier,
            dropFirst: dropFirst,
            limit: limit,
            completion: completion)
    }
}

// MARK: - User Followers/Following Private Methods

private extension FirebaseDatabaseService {
    static func fetchFollowersFollowingWithKindFromBegin(
        currentUserIdentifier: String,
        userIdentifier: String,
        table: String,
        startAtUserIdentifier startingUserIdentifier: String,
        dropFirst: Bool,
        limit: UInt,
        completion: @escaping (Result<[User], Error>) -> Void
    ) {
        databaseReference
            .child(table)
            .child(userIdentifier)
            .queryOrderedByKey()
            .queryStarting(atValue: startingUserIdentifier)
            .queryLimited(toFirst: limit)
            .observeSingleEvent(of: .value) { snapshot in
            let dispatchGroup = DispatchGroup()
            var users = [User]()
            var fetchErrors = [Error]()

            for child in snapshot.children {
                guard let snapshot = child as? DataSnapshot else { return }

                dispatchGroup.enter()

                let childIdentifier = snapshot.key

                fetchUser(userIdentifier: childIdentifier) { result in
                    switch result {
                    case .success(var user):
                        user.identifier = childIdentifier

                        if currentUserIdentifier == childIdentifier {
                            user.kind = .current

                            users.append(user)
                            dispatchGroup.leave()
                        } else {
                            isFollowingUser(
                                currentUserIdentifier: currentUserIdentifier,
                                followingUserIdentifier: childIdentifier) { result in
                                switch result {
                                case .success(let isFollowing):
                                    user.kind = isFollowing ? .following : .notFollowing

                                    users.append(user)
                                case .failure(let error):
                                    fetchErrors.append(error)
                                }

                                dispatchGroup.leave()
                            }
                        }
                    case .failure(let error):
                        fetchErrors.append(error)
                        dispatchGroup.leave()
                    }
                }
            }

            dispatchGroup.notify(queue: .main) {
                if let error = fetchErrors.first {
                    completion(.failure(error))
                } else {
                    // Same bug (as in the method "fetchFromEndUserFeedPosts"), same fix :\
                    users.sort { $0.identifier ?? "" < $1.identifier ?? "" }

                    if dropFirst {
                        completion(.success(Array(users.dropFirst())))
                    } else {
                        completion(.success(users))
                    }
                }
            }
        }
    }
}

// MARK: - Posts Public Methods

extension FirebaseDatabaseService {
    static func isLikedPost(
        userIdentifier: String,
        postOwnerIdentifier: String,
        postIdentifier: String,
        completion: @escaping (Result<Bool, Error>) -> Void
    ) {
        databaseReference
            .child(Tables.postsLikes)
            .child(postOwnerIdentifier)
            .child(postIdentifier)
            .child(userIdentifier)
            .observeSingleEvent(of: .value) { snapshot in
            completion(.success(snapshot.exists()))
        } withCancel: { error in
            completion(.failure(error))
        }
    }
    
    static func isBookmarkedPost(
        userIdentifier: String,
        postIdentifier: String,
        completion: @escaping (Result<Bool, Error>) -> Void
    ) {
        databaseReference
            .child(Tables.postsBookmarks)
            .child(userIdentifier)
            .child(postIdentifier)
            .observeSingleEvent(of: .value) { snapshot in
            completion(.success(snapshot.exists()))
        } withCancel: { error in
            completion(.failure(error))
        }
    }
    
    static func likePost(
        userIdentifier: String,
        postOwnerIdentifier: String,
        postIdentifier: String,
        completion: @escaping (Error?) -> Void
    ) {
        isLikedPost(
            userIdentifier: userIdentifier,
            postOwnerIdentifier: postOwnerIdentifier,
            postIdentifier: postIdentifier) { result in
            switch result {
            case .success(let isLiked):
                guard !isLiked else { return }
                
                createLikeRecord(
                    userIdentifier: userIdentifier,
                    postOwnerIdentifier: postOwnerIdentifier,
                    postIdentifier: postIdentifier) { error in
                    completion(error)
                }
            case .failure(let error):
                completion(error)
            }
        }
    }
    
    static func unlikePost(
        userIdentifier: String,
        postOwnerIdentifier: String,
        postIdentifier: String,
        completion: @escaping (Error?) -> Void
    ) {
        isLikedPost(
            userIdentifier: userIdentifier,
            postOwnerIdentifier: postOwnerIdentifier,
            postIdentifier: postIdentifier) { result in
            switch result {
            case .success(let isLiked):
                guard isLiked else { return }
                
                removeLikeRecord(
                    userIdentifier: userIdentifier,
                    postOwnerIdentifier: postOwnerIdentifier,
                    postIdentifier: postIdentifier) { error in
                    completion(error)
                }
            case .failure(let error):
                completion(error)
            }
        }
    }
    
    private static func fetchLikesCount(
        postOwnerIdentifier: String,
        postIdentifier: String,
        completion: @escaping (Result<Int, Error>) -> Void
    ) {
        databaseReference
            .child(Tables.postsLikes)
            .child(postOwnerIdentifier)
            .child(postIdentifier)
            .observeSingleEvent(of: .value) { snapshot in
            var likes = 0
            
            if let value = snapshot.value as? [String: Any] {
                likes = value.count
            }
            
            completion(.success(likes))
        } withCancel: { error in
            completion(.failure(error))
        }
    }
    
    static func sharePost(
        userIdentifier: String,
        imageData: Data,
        imageAspectRatio: CGFloat,
        caption: String?,
        completion: @escaping (Error?) -> Void
    ) {
        FirebaseStorageService.storeUserPostImageData(userIdentifier: userIdentifier, data: imageData) { result in
            switch result {
            case .success(let imageURL):
                createPostFeedRecord(
                    userIdentifier: userIdentifier,
                    imageURL: imageURL,
                    imageAspectRatio: imageAspectRatio,
                    caption: caption,
                    completion: completion)
            case .failure(let error):
                completion(error)
            }
        }
    }
    
    static func fetchPostsFromEnd(
        userIdentifier: String,
        endAtTimestamp timestamp: TimeInterval = Date().timeIntervalSince1970,
        dropLast: Bool = false,
        limit: UInt,
        completion: @escaping (Result<[Post], Error>) -> Void
    ) {
        databaseReference
            .child(Tables.posts)
            .child(userIdentifier)
            .queryOrdered(byChild: Post.CodingKeys.timestamp.rawValue)
            .queryEnding(atValue: timestamp)
            .queryLimited(toLast: limit)
            .observeSingleEvent(of: .value) { snapshot in
            var posts = [Post]()
            
            for child in snapshot.children {
                guard
                    let snapshot = child as? DataSnapshot,
                    let value = snapshot.value as? [String: Any],
                    var post = JSONCoding.fromDictionary(value, type: Post.self)
                else {
                    return
                }
                    
                post.identifier = snapshot.key
                
                posts.append(post)
            }
            
            if dropLast {
                completion(.success(Array(posts.dropLast())))
            } else {
                completion(.success(posts))
            }
        } withCancel: { error in
            completion(.failure(error))
        }
    }
    
    static func observePosts(
        userIdentifier: String,
        timestamp: TimeInterval = Date().timeIntervalSince1970,
        completion: @escaping (Result<Post, Error>) -> Void
    ) -> FirebaseObserver {
        let postsReference = databaseReference
            .child(Tables.posts)
            .child(userIdentifier)
        
        let postAddedHandle = postsReference
            .queryOrdered(byChild: Post.CodingKeys.timestamp.rawValue)
            .queryStarting(atValue: timestamp)
            .observe(.childAdded) { snapshot in
            guard
                let value = snapshot.value as? [String: Any],
                var post = JSONCoding.fromDictionary(value, type: Post.self)
            else {
                return
            }
            
            let postIdentifier = snapshot.key
            post.identifier = postIdentifier
                
            isLikedPost(
                userIdentifier: userIdentifier,
                postOwnerIdentifier: userIdentifier,
                postIdentifier: postIdentifier) { result in
                switch result {
                case .success(let isLiked):
                    post.isLiked = isLiked
                    
                    completion(.success(post))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } withCancel: { error in
            completion(.failure(error))
        }
        
        let postAddedObserver = FirebaseObserver(reference: postsReference, handle: postAddedHandle)
        
        return postAddedObserver
    }
    
    static func addPostToBookmarks(
        userIdentifier: String,
        postOwnerIdentifier: String,
        postIdentifier: String,
        timestamp: TimeInterval,
        completion: @escaping (Error?) -> Void
    ) {
        isBookmarkedPost(
            userIdentifier: userIdentifier,
            postIdentifier: postIdentifier) { result in
            switch result {
            case .success(let isBookmarked):
                guard !isBookmarked else { return }
                
                createBookmarkRecord(
                    userIdentifier: userIdentifier,
                    postOwnerIdentifier: postOwnerIdentifier,
                    postIdentifier: postIdentifier,
                    timestamp: timestamp,
                    completion: completion)
            case .failure(let error):
                completion(error)
            }
        }
    }
    
    static func removePostFromBookmarks(
        userIdentifier: String,
        postIdentifier: String,
        completion: @escaping (Error?) -> Void
    ) {
        isBookmarkedPost(
            userIdentifier: userIdentifier,
            postIdentifier: postIdentifier) { result in
            switch result {
            case .success(let isBookmarked):
                guard isBookmarked else { return }
                
                removeBookmarkRecord(
                    userIdentifier: userIdentifier,
                    postIdentifier: postIdentifier,
                    completion: completion)
            case .failure(let error):
                completion(error)
            }
        }
    }
    
    static func fetchBookmarkedPostsFromEnd(
        userIdentifier: String,
        endAtTimestamp timestamp: TimeInterval = Date().timeIntervalSince1970,
        dropLast: Bool = false,
        limit: UInt,
        completion: @escaping (Result<[Post], Error>) -> Void
    ) {
        databaseReference
            .child(Tables.postsBookmarks)
            .child(userIdentifier)
            .queryOrdered(byChild: FeedPost.CodingKeys.timestamp.rawValue)
            .queryEnding(atValue: timestamp)
            .queryLimited(toLast: limit)
            .observeSingleEvent(of: .value) { snapshot in
            let dispatchGroup = DispatchGroup()
            var posts = [Post]()
            var fetchErrors = [Error]()
            
            for child in snapshot.children {
                guard
                    let childSnapshot = child as? DataSnapshot,
                    let childValue = childSnapshot.value as? [String: Any],
                    let feedPost = JSONCoding.fromDictionary(childValue, type: FeedPost.self)
                else {
                    return
                }
                
                dispatchGroup.enter()
                
                let postOwnerIdentifier = feedPost.userIdentifier
                let feedPostIdentifier = childSnapshot.key
                
                fetchPost(
                    currentUserIdentifier: userIdentifier,
                    postOwnerIdentifier: postOwnerIdentifier,
                    postIdentifier: feedPostIdentifier) { result in
                    switch result {
                    case .success(var post):
                        post.userIdentifier = postOwnerIdentifier
                        
                        posts.append(post)
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
                    // Same bug, same fix :/
                    posts.sort { $0.timestamp < $1.timestamp }
                    
                    if dropLast {
                        completion(.success(Array(posts.dropLast())))
                    } else {
                        completion(.success(posts))
                    }
                }
            }
        } withCancel: { error in
            completion(.failure(error))
        }
    }
}

// MARK: - Posts Private Methods

private extension FirebaseDatabaseService {
    static func fetchPost(
        currentUserIdentifier: String,
        postOwnerIdentifier: String,
        postIdentifier: String,
        completion: @escaping (Result<Post, Error>) -> Void
    ) {
        databaseReference
            .child(Tables.posts)
            .child(postOwnerIdentifier)
            .child(postIdentifier)
            .observeSingleEvent(of: .value) { snapshot in
            guard
                let value = snapshot.value as? [String: Any],
                var post = JSONCoding.fromDictionary(value, type: Post.self)
            else {
                return
            }
            
            let postIdentifier = snapshot.key
            post.identifier = postIdentifier
            
            isLikedPost(
                userIdentifier: currentUserIdentifier,
                postOwnerIdentifier: postOwnerIdentifier,
                postIdentifier: postIdentifier) { result in
                switch result {
                case .success(let isLiked):
                    post.isLiked = isLiked
                    
                    isBookmarkedPost(
                        userIdentifier: currentUserIdentifier,
                        postIdentifier: postIdentifier) { result in
                        switch result {
                        case .success(let isBookmarked):
                            post.isBookmarked = isBookmarked
                            
                            fetchLikesCount(
                                postOwnerIdentifier: postOwnerIdentifier,
                                postIdentifier: postIdentifier) { result in
                                switch result {
                                case .success(let likesCount):
                                    post.likesCount = likesCount
                                    
                                    completion(.success(post))
                                case .failure(let error):
                                    completion(.failure(error))
                                }
                            }
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } withCancel: { error in
            completion(.failure(error))
        }
    }
    
    static func createPostFeedRecord(
        userIdentifier: String,
        imageURL: String,
        imageAspectRatio: CGFloat,
        caption: String?,
        completion: @escaping (Error?) -> Void
    ) {
        let postReference = databaseReference
            .child(Tables.posts)
            .child(userIdentifier)
        
        let post = Post(
            imageURL: imageURL,
            imageAspectRatio: imageAspectRatio,
            caption: caption,
            timestamp: Date().timeIntervalSince1970)

        guard
            let postDictionary = JSONCoding.toDictionary(post),
            let postIdentifier = postReference.childByAutoId().key
        else {
            return
        }

        postReference
            .child(postIdentifier)
            .setValue(postDictionary) { error, _ in
            guard error == nil else {
                completion(error)

                return
            }

            createUserFeedRecord(
                userIdentifier: userIdentifier,
                postOwnerIdentifier: userIdentifier,
                postIdentifier: postIdentifier,
                timestamp: post.timestamp) { error in
                guard error == nil else {
                    completion(error)

                    return
                }

                fetchFollowersUsersIdentifiers(userIdentifier: userIdentifier) { result in
                    switch result {
                    case .success(let followersIdentifiers):
                        guard !followersIdentifiers.isEmpty else {
                            completion(nil)

                            return
                        }

                        followersIdentifiers.forEach { followerIdentifier in
                            createUserFeedRecord(
                                userIdentifier: followerIdentifier,
                                postOwnerIdentifier: userIdentifier,
                                postIdentifier: postIdentifier,
                                timestamp: post.timestamp,
                                completion: completion)
                        }
                    case .failure(let error):
                        completion(error)
                    }
                }
            }
        }
    }
    
    static func createUserFeedRecord(
        userIdentifier: String,
        postOwnerIdentifier: String,
        postIdentifier: String,
        timestamp: TimeInterval,
        completion: @escaping (Error?) -> Void
    ) {
        let feedPost = FeedPost(userIdentifier: postOwnerIdentifier, timestamp: timestamp)
        
        if let feedPostDictionary = JSONCoding.toDictionary(feedPost) {
            databaseReference
                .child(Tables.usersFeed)
                .child(userIdentifier)
                .child(postIdentifier)
                .setValue(feedPostDictionary) { error, _ in
                completion(error)
            }
        }
    }
    
    static func fetchFollowersUsersIdentifiers(
        userIdentifier: String,
        completion: @escaping (Result<[String], Error>) -> Void
    ) {
        fetchFollowingFollowersUsersIdentifiers(
            table: Tables.followers,
            userIdentifier: userIdentifier,
            completion: completion)
    }

    static func fetchFollowingUsersIdentifiers(
        userIdentifier: String,
        completion: @escaping (Result<[String], Error>) -> Void
    ) {
        fetchFollowingFollowersUsersIdentifiers(
            table: Tables.following,
            userIdentifier: userIdentifier,
            completion: completion)
    }
    
    static func fetchFollowingFollowersUsersIdentifiers(
        table: String,
        userIdentifier: String,
        completion: @escaping (Result<[String], Error>) -> Void
    ) {
        databaseReference
            .child(table)
            .child(userIdentifier)
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
    
    static func createLikeRecord(
        userIdentifier: String,
        postOwnerIdentifier: String,
        postIdentifier: String,
        completion: @escaping (Error?) -> Void
    ) {
        databaseReference
            .child(Tables.postsLikes)
            .child(postOwnerIdentifier)
            .child(postIdentifier)
            .child(userIdentifier)
            .setValue(0) { error, _ in
            completion(error)
        }
    }
    
    static func removeLikeRecord(
        userIdentifier: String,
        postOwnerIdentifier: String,
        postIdentifier: String,
        completion: @escaping (Error?) -> Void
    ) {
        databaseReference
            .child(Tables.postsLikes)
            .child(postOwnerIdentifier)
            .child(postIdentifier)
            .child(userIdentifier)
            .removeValue { error, _ in
            completion(error)
        }
    }
    
    static func createBookmarkRecord(
        userIdentifier: String,
        postOwnerIdentifier: String,
        postIdentifier: String,
        timestamp: TimeInterval,
        completion: @escaping (Error?) -> Void
    ) {
        let bookmarkPost = FeedPost(userIdentifier: postOwnerIdentifier, timestamp: timestamp)
        
        if let bookmarkPostDictionary = JSONCoding.toDictionary(bookmarkPost) {
            databaseReference
                .child(Tables.postsBookmarks)
                .child(userIdentifier)
                .child(postIdentifier)
                .setValue(bookmarkPostDictionary) { error, _ in
                completion(error)
            }
        }
    }
    
    static func removeBookmarkRecord(
        userIdentifier: String,
        postIdentifier: String,
        completion: @escaping (Error?) -> Void
    ) {
        databaseReference
            .child(Tables.postsBookmarks)
            .child(userIdentifier)
            .child(postIdentifier)
            .removeValue { error, _ in
            completion(error)
        }
    }
}

// MARK: - User Feed Public Methods

extension FirebaseDatabaseService {
    static func isUserFeedExist(userIdentifier: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        databaseReference
            .child(Tables.usersFeed)
            .child(userIdentifier)
            .observeSingleEvent(of: .value) { snapshot in
            completion(.success(snapshot.exists()))
        } withCancel: { error in
            completion(.failure(error))
        }
    }
    
    static func fetchUserFeedPostsFromEnd(
        userIdentifier: String,
        endAtTimestamp timestamp: TimeInterval = Date().timeIntervalSince1970,
        dropLast: Bool = false,
        limit: UInt,
        completion: @escaping (Result<[UserPost], Error>) -> Void
    ) {
        databaseReference
            .child(Tables.usersFeed)
            .child(userIdentifier)
            .queryOrdered(byChild: FeedPost.CodingKeys.timestamp.rawValue)
            .queryEnding(atValue: timestamp)
            .queryLimited(toLast: limit)
            .observeSingleEvent(of: .value) { snapshot in
            let dispatchGroup = DispatchGroup()
            var usersPosts = [UserPost]()
            var fetchErrors = [Error]()
            
            for child in snapshot.children {
                guard
                    let childSnapshot = child as? DataSnapshot,
                    let childValue = childSnapshot.value as? [String: Any],
                    let feedPost = JSONCoding.fromDictionary(childValue, type: FeedPost.self)
                else {
                    return
                }
                
                dispatchGroup.enter()
                
                let postOwnerIdentifier = feedPost.userIdentifier
                let feedPostIdentifier = childSnapshot.key
                
                fetchUser(userIdentifier: postOwnerIdentifier) { result in
                    switch result {
                    case .success(let user):
                        fetchPost(
                            currentUserIdentifier: userIdentifier,
                            postOwnerIdentifier: postOwnerIdentifier,
                            postIdentifier: feedPostIdentifier) { result in
                            
                            switch result {
                            case .success(let post):
                                let userPost = UserPost(user: user, post: post)
                                
                                usersPosts.append(userPost)
                            case .failure(let error):
                                fetchErrors.append(error)
                            }
                            
                            dispatchGroup.leave()
                        }
                    case .failure(let error):
                        fetchErrors.append(error)
                        
                        dispatchGroup.leave()
                    }
                }
            }
            
            dispatchGroup.notify(queue: .main) {
                if let error = fetchErrors.first {
                    completion(.failure(error))
                } else {
                    // To fix a Firebase bug, when there is another active observer in the system
                    // (even if not associated with a table), the fetch order is changed
                    // In my case: if "observeUserFeedPosts" and "observePosts" is enabled at the same time (idk why)
                    usersPosts.sort { $0.post.timestamp < $1.post.timestamp }
                    
                    if dropLast {
                        completion(.success(Array(usersPosts.dropLast())))
                    } else {
                        completion(.success(usersPosts))
                    }
                }
            }
        } withCancel: { error in
            completion(.failure(error))
        }
    }
    
    static func observeUserFeedPosts(
        userIdentifier: String,
        timestamp: TimeInterval = Date().timeIntervalSince1970,
        completion: @escaping (Result<UserPost, Error>) -> Void
    ) -> FirebaseObserver {
        let userFeedReference = databaseReference
            .child(Tables.usersFeed)
            .child(userIdentifier)
        
        let feedPostAddedHandle = userFeedReference
            .queryOrdered(byChild: FeedPost.CodingKeys.timestamp.rawValue)
            .queryStarting(atValue: timestamp)
            .observe(.childAdded) { snapshot in
            guard
                let value = snapshot.value as? [String: Any],
                let feedPost = JSONCoding.fromDictionary(value, type: FeedPost.self)
            else {
                return
            }
            
            let postOwnerIdentifier = feedPost.userIdentifier
                
            fetchUser(userIdentifier: postOwnerIdentifier) { result in
                switch result {
                case .success(let user):
                let feedPostIdentifier = snapshot.key
                    
                fetchPost(
                    currentUserIdentifier: userIdentifier,
                    postOwnerIdentifier: postOwnerIdentifier,
                    postIdentifier: feedPostIdentifier) { result in
                    switch result {
                    case .success(let post):
                        let userPost = UserPost(user: user, post: post)
                        
                        completion(.success(userPost))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } withCancel: { error in
            completion(.failure(error))
        }
        
        let postFeedAddedObserver = FirebaseObserver(reference: userFeedReference, handle: feedPostAddedHandle)
        
        return postFeedAddedObserver
    }
}

// MARK: - Comments Public Methods

extension FirebaseDatabaseService {
    static func sendComment(
        senderIdentifier: String,
        postOwnerIdentifier: String,
        postIdentifier: String,
        text: String,
        completion: @escaping (Error?) -> Void
    ) {
        let comment = Comment(
            senderIdentifier: senderIdentifier,
            caption: text,
            timestamp: Date().timeIntervalSince1970)
        
        if let commentDictionary = JSONCoding.toDictionary(comment) {
            databaseReference
                .child(Tables.postsComments)
                .child(postOwnerIdentifier)
                .child(postIdentifier)
                .childByAutoId()
                .setValue(commentDictionary) { error, _ in
                completion(error)
            }
        }
    }
    
    static func fetchUserCommentsFromBegin(
        userIdentifier: String,
        postIdentifier: String,
        startAtTimestamp timestamp: TimeInterval = 0,
        dropFirst: Bool = false,
        limit: UInt,
        completion: @escaping (Result<[UserComment], Error>) -> Void
    ) {
        databaseReference
            .child(Tables.postsComments)
            .child(userIdentifier)
            .child(postIdentifier)
            .queryOrdered(byChild: Comment.CodingKeys.timestamp.rawValue)
            .queryStarting(atValue: timestamp)
            .queryLimited(toFirst: limit)
            .observeSingleEvent(of: .value) { snapshot in
            let dispatchGroup = DispatchGroup()
            var userComments = [UserComment]()
            var fetchErrors = [Error]()
            
            for child in snapshot.children {
                guard
                    let snapshot = child as? DataSnapshot,
                    let value = snapshot.value as? [String: Any],
                    var comment = JSONCoding.fromDictionary(value, type: Comment.self)
                else {
                    return
                }
                
                dispatchGroup.enter()
                
                comment.identifier = snapshot.key
                
                fetchUser(userIdentifier: comment.senderIdentifier) { result in
                    switch result {
                    case .success(let user):
                        let userComment = UserComment(user: user, comment: comment)
                        
                        userComments.append(userComment)
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
                    if dropFirst {
                        completion(.success(Array(userComments.dropFirst())))
                    } else {
                        completion(.success(userComments))
                    }
                }
            }
        } withCancel: { error in
            completion(.failure(error))
        }
    }
}

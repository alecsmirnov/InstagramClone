//
//  FirebasePostService.swift
//  Instagram
//
//  Created by Admin on 03.02.2021.
//

import FirebaseDatabase
import CoreGraphics

enum FirebasePostService {
    private static let databaseReference = Database.database().reference()
}

// MARK: - Public Methods

extension FirebasePostService {
    static func isUserFeedExist(identifier: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        databaseReference
            .child(FirebaseTables.usersFeed)
            .child(identifier)
            .observeSingleEvent(of: .value) { snapshot in
            completion(.success(snapshot.exists()))
        } withCancel: { error in
            completion(.failure(error))
        }
    }
    
    static func sharePost(
        identifier: String,
        imageData: Data,
        imageAspectRatio: CGFloat,
        caption: String?,
        completion: @escaping (Error?) -> Void
    ) {
        FirebaseStorageService.storeUserPostImageData(imageData, identifier: identifier) { result in
            switch result {
            case .success(let imageURL):
                createPostFeedRecord(
                    identifier: identifier,
                    imageURL: imageURL,
                    imageAspectRatio: imageAspectRatio,
                    caption: caption) { error in
                    completion(error)
                }
            case .failure(let error):
                completion(error)
            }
        }
    }
    
    static func fetchPost(
        identifier: String,
        postIdentifier: String,
        currentUserIdentifier: String,
        completion: @escaping (Result<Post, Error>) -> Void
    ) {
        databaseReference
            .child(FirebaseTables.posts)
            .child(identifier)
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
                postOwnerIdentifier: identifier,
                postIdentifier: postIdentifier,
                userIdentifier: currentUserIdentifier) { result in
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
    }
    
    static func observePosts(
        identifier: String,
        timestamp: TimeInterval = Date().timeIntervalSince1970,
        completion: @escaping (Result<Post, Error>) -> Void
    ) -> FirebaseObserver {
        let postsReference = databaseReference.child(FirebaseTables.posts).child(identifier)
        
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
                postOwnerIdentifier: identifier,
                postIdentifier: postIdentifier,
                userIdentifier: identifier) { result in
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
    
    static func observeUserFeedPosts(
        identifier: String,
        timestamp: TimeInterval = Date().timeIntervalSince1970,
        completion: @escaping (Result<UserPost, Error>) -> Void
    ) -> FirebaseObserver {
        let userFeedReference = databaseReference.child(FirebaseTables.usersFeed).child(identifier)
        
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
            
            FirebaseUserService.fetchUser(withIdentifier: feedPost.userIdentifier) { result in
                switch result {
                case .success(let user):
                let feedPostIdentifier = snapshot.key
                    
                fetchPost(
                    identifier: feedPost.userIdentifier,
                    postIdentifier: feedPostIdentifier,
                    currentUserIdentifier: identifier) { result in
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
    
    static func fetchLastUserFeedPosts(
        identifier: String,
        beforeTimestamp: TimeInterval = Date().timeIntervalSince1970,
        dropLast: Bool = false,
        limit: UInt,
        completion: @escaping (Result<[UserPost], Error>) -> Void
    ) {
        databaseReference
            .child(FirebaseTables.usersFeed)
            .child(identifier)
            .queryOrdered(byChild: FeedPost.CodingKeys.timestamp.rawValue)
            .queryEnding(atValue: beforeTimestamp)
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
                
                let feedPostIdentifier = childSnapshot.key
                
                FirebaseUserService.fetchUser(withIdentifier: feedPost.userIdentifier) { result in
                    switch result {
                    case .success(let user):
                        fetchPost(
                            identifier: feedPost.userIdentifier,
                            postIdentifier: feedPostIdentifier,
                            currentUserIdentifier: identifier) { result in
                            
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
                    // To fix a firebase bug, when there is another active observer in the system
                    // (even if not associated with a table), the fetch order is changed
                    // In my case: if profile and home observers is enabled at the same time (idk why)
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
    
    static func fetchLastPosts(
        identifier: String,
        beforeTimestamp: TimeInterval = Date().timeIntervalSince1970,
        dropLast: Bool = false,
        limit: UInt,
        completion: @escaping (Result<[Post], Error>) -> Void
    ) {
        databaseReference
            .child(FirebaseTables.posts)
            .child(identifier)
            .queryOrdered(byChild: Post.CodingKeys.timestamp.rawValue)
            .queryEnding(atValue: beforeTimestamp)
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
    
    static func fetchFirstUserComments(
        identifier: String,
        postIdentifier: String,
        afterTimestamp: TimeInterval = 0,
        dropFirst: Bool = false,
        limit: UInt,
        completion: @escaping (Result<[UserComment], Error>) -> Void
    ) {
        databaseReference
            .child(FirebaseTables.postsComments)
            .child(identifier)
            .child(postIdentifier)
            .queryOrdered(byChild: Comment.CodingKeys.timestamp.rawValue)
            .queryStarting(atValue: afterTimestamp)
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
                
                FirebaseUserService.fetchUser(withIdentifier: comment.senderIdentifier) { result in
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
    
    static func sendComment(
        postOwnerIdentifier: String,
        postIdentifier: String,
        senderIdentifier: String,
        text: String,
        completion: @escaping (Error?) -> Void
    ) {
        let comment = Comment(
            senderIdentifier: senderIdentifier,
            caption: text,
            timestamp: Date().timeIntervalSince1970)
        
        if let commentDictionary = JSONCoding.toDictionary(comment) {
            databaseReference
                .child(FirebaseTables.postsComments)
                .child(postOwnerIdentifier)
                .child(postIdentifier)
                .childByAutoId()
                .setValue(commentDictionary) { error, _ in
                completion(error)
            }
        }
    }
    
    static func isLikedPost(
        postOwnerIdentifier: String,
        postIdentifier: String,
        userIdentifier: String,
        completion: @escaping (Result<Bool, Error>) -> Void
    ) {
        databaseReference
            .child(FirebaseTables.postsLikes)
            .child(postOwnerIdentifier)
            .child(postIdentifier)
            .child(userIdentifier)
            .observeSingleEvent(of: .value) { snapshot in
            completion(.success(snapshot.exists()))
        } withCancel: { error in
            completion(.failure(error))
        }
    }
    
    static func likePost(
        postOwnerIdentifier: String,
        postIdentifier: String,
        userIdentifier: String,
        completion: @escaping (Error?) -> Void
    ) {
        isLikedPost(
            postOwnerIdentifier: postOwnerIdentifier,
            postIdentifier: postIdentifier,
            userIdentifier: userIdentifier) { result in
            switch result {
            case .success(let isLiked):
                guard !isLiked else { return }
                
                createLikeRecord(
                    postOwnerIdentifier: postOwnerIdentifier,
                    postIdentifier: postIdentifier,
                    userIdentifier: userIdentifier) { error in
                    guard error == nil else {
                        completion(error)
                        
                        return
                    }
                    
                    increaseLikesCount(
                        postOwnerIdentifier: postOwnerIdentifier,
                        postIdentifier: postIdentifier,
                        completion: completion)
                }
            case .failure(let error):
                completion(error)
            }
        }
    }
    
    static func unlikePost(
        postOwnerIdentifier: String,
        postIdentifier: String,
        userIdentifier: String,
        completion: @escaping (Error?) -> Void
    ) {
        isLikedPost(
            postOwnerIdentifier: postOwnerIdentifier,
            postIdentifier: postIdentifier,
            userIdentifier: userIdentifier) { result in
            switch result {
            case .success(let isLiked):
                guard isLiked else { return }
                
                removeLikeRecord(
                    postOwnerIdentifier: postOwnerIdentifier,
                    postIdentifier: postIdentifier,
                    userIdentifier: userIdentifier) { error in
                    guard error == nil else {
                        completion(error)
                        
                        return
                    }
                    
                    decreaseLikesCount(
                        postOwnerIdentifier: postOwnerIdentifier,
                        postIdentifier: postIdentifier,
                        completion: completion)
                }
            case .failure(let error):
                completion(error)
            }
        }
    }
}

// MARK: - Private Methods

private extension FirebasePostService {
    static func createPostFeedRecord(
        identifier: String,
        imageURL: String,
        imageAspectRatio: CGFloat,
        caption: String?,
        completion: @escaping (Error?) -> Void
    ) {
        let post = Post(
            imageURL: imageURL,
            imageAspectRatio: imageAspectRatio,
            caption: caption,
            timestamp: Date().timeIntervalSince1970)
        
        if let postDictionary = JSONCoding.toDictionary(post) {
            let postReference = databaseReference.child(FirebaseTables.posts).child(identifier)
            
            guard let postIdentifier = postReference.childByAutoId().key else { return }
            
            postReference
                .child(postIdentifier)
                .setValue(postDictionary) { error, _ in
                guard error == nil else {
                    completion(error)
                    
                    return
                }
                
                createUserFeedRecord(
                    userIdentifier: identifier,
                    postOwnerIdentifier: identifier,
                    postIdentifier: postIdentifier,
                    timestamp: post.timestamp) { error in
                    guard error == nil else {
                        completion(error)
                        
                        return
                    }
                    
                    FirebaseUserService.fetchFollowersUsersIdentifiers(identifier: identifier) { result in
                        switch result {
                        case .success(let followersIdentifiers):
                            guard !followersIdentifiers.isEmpty else {
                                completion(nil)
                                
                                return
                            }
                            
                            followersIdentifiers.forEach { followerIdentifier in
                                createUserFeedRecord(
                                    userIdentifier: followerIdentifier,
                                    postOwnerIdentifier: identifier,
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
                .child(FirebaseTables.usersFeed)
                .child(userIdentifier)
                .child(postIdentifier)
                .setValue(feedPostDictionary) { error, _ in
                completion(error)
            }
        }
    }
    
    static func createLikeRecord(
        postOwnerIdentifier: String,
        postIdentifier: String,
        userIdentifier: String,
        completion: @escaping (Error?) -> Void
    ) {
        databaseReference
            .child(FirebaseTables.postsLikes)
            .child(postOwnerIdentifier)
            .child(postIdentifier)
            .child(userIdentifier)
            .setValue(0) { error, _ in
            completion(error)
        }
    }
    
    static func removeLikeRecord(
        postOwnerIdentifier: String,
        postIdentifier: String,
        userIdentifier: String,
        completion: @escaping (Error?) -> Void
    ) {
        databaseReference
            .child(FirebaseTables.postsLikes)
            .child(postOwnerIdentifier)
            .child(postIdentifier)
            .child(userIdentifier)
            .removeValue { error, _ in
            completion(error)
        }
    }
    
    static func increaseLikesCount(
        postOwnerIdentifier: String,
        postIdentifier: String,
        completion: @escaping (Error?) -> Void
    ) {
        databaseReference
            .child(FirebaseTables.postsLikesCount)
            .child(postOwnerIdentifier)
            .child(postIdentifier)
            .runTransactionBlock { mutableData in
            var defaultCount = 1
            
            if let count = mutableData.value as? Int {
                defaultCount += count
            }
            
            mutableData.value = defaultCount
            
            return TransactionResult.success(withValue: mutableData)
        } andCompletionBlock: { error, _, _ in
            completion(error)
        }
    }
    
    static func decreaseLikesCount(
        postOwnerIdentifier: String,
        postIdentifier: String,
        completion: @escaping (Error?) -> Void
    ) {
        databaseReference
            .child(FirebaseTables.postsLikesCount)
            .child(postOwnerIdentifier)
            .child(postIdentifier)
            .runTransactionBlock { mutableData in
            if let count = mutableData.value as? Int, 0 < count {
                mutableData.value = count - 1
            }
            
            return TransactionResult.success(withValue: mutableData)
        } andCompletionBlock: { error, _, _ in
            completion(error)
        }
    }
}

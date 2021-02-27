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
    static func isAllPostsExists(identifier: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        isPostsExists(identifier: identifier) { result in
            switch result {
            case .success(let isCurrentUserPostsExists):
                guard isCurrentUserPostsExists else {
                    isFollowingPostsExists(identifier: identifier) { result in
                        switch result {
                        case .success(let isFollowingUserPostsExists):
                            completion(.success(isFollowingUserPostsExists))
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                    
                    return
                }
                
                completion(.success(true))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    static func isPostsExists(identifier: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        databaseReference
            .child(FirebaseTables.posts)
            .child(identifier)
            .observeSingleEvent(of: .value) { snapshot in
            completion(.success(snapshot.exists()))
        } withCancel: { error in
            completion(.failure(error))
        }
    }
    
    static func isFollowingPostsExists(identifier: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        FirebaseUserService.fetchFollowingUsersIdentifiers(identifier: identifier) { result in
            switch result {
            case .success(let identifiers):
                let dispatchGroup = DispatchGroup()
                var followingPosts = [Bool]()
                
                for followingUserIdentifier in identifiers {
                    dispatchGroup.enter()
                    
                    isPostsExists(identifier: followingUserIdentifier) { result in
                        switch result {
                        case .success(let isCurrentUserPostsExist):
                            followingPosts.append(isCurrentUserPostsExist)
                            
                            dispatchGroup.leave()
                        case .failure(let error):
                            completion(.failure(error))
                            
                            break
                        }
                    }
                }
                
                dispatchGroup.notify(queue: .main) {
                    for followingPost in followingPosts where followingPost {
                        completion(.success(true))
                        
                        break
                    }
                    
                    completion(.success(false))
                }
            case .failure(let error):
                completion(.failure(error))
            }
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
                createPostRecord(
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
    
    static func observePosts(
        identifier: String,
        completion: @escaping (Result<Post, Error>) -> Void
    ) -> FirebaseObserver {
        let userPostsReference = databaseReference.child(FirebaseTables.posts).child(identifier)
        
        let postAddedHandle = userPostsReference.observe(.childAdded) { snapshot in
            guard
                let value = snapshot.value as? [String: Any],
                var post = JSONCoding.fromDictionary(value, type: Post.self)
            else {
                return
            }
            
            let postIdentifier = snapshot.key
            post.identifier = postIdentifier
                
            completion(.success(post))
        } withCancel: { error in
            completion(.failure(error))
        }
        
        let postAddedObserver = FirebaseObserver(reference: userPostsReference, handle: postAddedHandle)
        
        return postAddedObserver
    }
    
    static func fetchAllPosts(
        identifier: String,
        completion: @escaping (Result<[Post], Error>) -> Void
    ) {
        databaseReference
            .child(FirebaseTables.posts)
            .child(identifier)
            .observeSingleEvent(of: .value) { snapshot in
            guard let value = snapshot.value as? [String: Any] else { return }
            
            var posts = [Post]()
            
            value.forEach { postIdentifier, postValue in
                guard
                    let postDictionary = postValue as? [String: Any],
                    var post = JSONCoding.fromDictionary(postDictionary, type: Post.self)
                else {
                    return
                }
                
                post.identifier = postIdentifier
                
                posts.append(post)
            }
                
            posts.sort { $0.timestamp < $1.timestamp }
            
            completion(.success(posts))
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
    
    static func observeComments(
        postOwnerIdentifier: String,
        postIdentifier: String,
        completion: @escaping (Result<Comment, Error>) -> Void
    ) -> FirebaseObserver {
        let userCommentsReference = databaseReference
            .child(FirebaseTables.postsComments)
            .child(postOwnerIdentifier)
            .child(postIdentifier)
        
        let commentAddedHandle = userCommentsReference.observe(.childAdded) { snapshot in
            guard
                let value = snapshot.value as? [String: Any],
                var comment = JSONCoding.fromDictionary(value, type: Comment.self)
            else {
                return
            }
            
            let commentIdentifier = snapshot.key
            comment.identifier = commentIdentifier
            comment.postIdentifier = postIdentifier
                
            completion(.success(comment))
        } withCancel: { error in
            completion(.failure(error))
        }
        
        let commentAddedObserver = FirebaseObserver(reference: userCommentsReference, handle: commentAddedHandle)
        
        return commentAddedObserver
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
        
    }
}

// MARK: - Private Methods

private extension FirebasePostService {
    static func createPostRecord(
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
            databaseReference
                .child(FirebaseTables.posts)
                .child(identifier)
                .childByAutoId()
                .setValue(postDictionary) { error, _ in
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

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
                let post = JSONCoding.fromDictionary(value, type: Post.self)
            else {
                return
            }
                
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
            
            value.forEach { identifier, postValue in
                guard
                    let postDictionary = postValue as? [String: Any],
                    let post = JSONCoding.fromDictionary(postDictionary, type: Post.self)
                else {
                    return
                }
                
                posts.append(post)
            }
                
            posts.sort { $0.timestamp < $1.timestamp }
            
            completion(.success(posts))
        } withCancel: { error in
            completion(.failure(error))
        }
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
}

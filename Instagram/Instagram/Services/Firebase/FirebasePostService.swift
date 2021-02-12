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
    static func sharePost(
        identifier: String,
        imageData: Data,
        imageAspectRatio: CGFloat,
        caption: String?,
        completion: @escaping (Error?) -> Void) {
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
    
    static func fetchAllPosts(
        identifier: String,
        completion: @escaping (Result<[Post], Error>) -> Void) {
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
    
    static func fetchUserPosts(
        identifier: String,
        completion: @escaping (Result<UserPost, Error>) -> Void) {
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
                
            databaseReference
                .child(FirebaseTables.posts)
                .child(identifier)
                .observe(.childAdded) { snapshot in
                guard
                    let value = snapshot.value as? [String: Any],
                    let post = JSONCoding.fromDictionary(value, type: Post.self)
                else {
                    return
                }
                    
                let userPost = UserPost(user: user, post: post)
                    
                completion(.success(userPost))
            }
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

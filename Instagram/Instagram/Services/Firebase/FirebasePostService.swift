//
//  FirebasePostService.swift
//  Instagram
//
//  Created by Admin on 03.02.2021.
//

import FirebaseDatabase

enum FirebasePostService {
    private static let databaseReference = Database.database().reference()
}

// MARK: - Public Methods

extension FirebasePostService {
    static func sharePost(
        identifier: String,
        imageData: Data,
        caption: String?,
        completion: @escaping (Error?) -> Void) {
        FirebaseStorageService.storeUserPostPNGImageData(imageData, identifier: identifier) { result in
            switch result {
            case .success(let imageURL):
                createPostRecord(identifier: identifier, imageURL: imageURL, caption: caption) { error in
                    completion(error)
                }
            case .failure(let error):
                completion(error)
            }
        }
    }
}

// MARK: - Private Methods

private extension FirebasePostService {
    static func createPostRecord(
        identifier: String,
        imageURL: String,
        caption: String?,
        completion: @escaping (Error?) -> Void
    ) {
        let post = Post(imageURL: imageURL, caption: caption, timestamp: Date().timeIntervalSince1970)
        
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

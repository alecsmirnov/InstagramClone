//
//  FirebaseStorageService.swift
//  Instagram
//
//  Created by Admin on 03.02.2021.
//

import FirebaseStorage

enum FirebaseStorageService {
    // MARK: Constants
    
    private enum Storages {
        static let profileImages = "profile_images"
        static let postImages = "post_images"
    }
    
    // MARK: Properties
    
    private static let storageReference = Storage.storage().reference()
}

// MARK: - Public Methods

extension FirebaseStorageService {
    static func storeUserProfileImageData(
        userIdentifier: String,
        data: Data,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        let imageDataReference = storageReference
            .child(Storages.profileImages)
            .child("\(userIdentifier).jpg")
        
        storeImageData(data, toStorage: imageDataReference, completion: completion)
    }
    
    static func storeUserPostImageData(
        userIdentifier: String,
        data: Data,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        let imageIdentifier = UUID().description
        let imageDataReference = storageReference
            .child(Storages.postImages)
            .child(userIdentifier)
            .child("\(imageIdentifier).jpg")
        
        storeImageData(data, toStorage: imageDataReference, completion: completion)
    }
}

// MARK: - Private Methods

private extension FirebaseStorageService {
    static func storeImageData(
        _ data: Data,
        toStorage storageReference: StorageReference,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        storageReference.putData(data, metadata: nil) { _, error in
            if let error = error {
                completion(.failure(error))
                
                return
            }
            
            storageReference.downloadURL { url, error in
                if let error = error {
                    completion(.failure(error))
                    
                    return
                }
                
                if let urlString = url?.absoluteString {
                    completion(.success(urlString))
                }
            }
        }
    }
}

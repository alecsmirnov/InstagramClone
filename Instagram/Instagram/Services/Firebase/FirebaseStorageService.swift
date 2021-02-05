//
//  FirebaseStorageService.swift
//  Instagram
//
//  Created by Admin on 03.02.2021.
//

import FirebaseStorage

enum FirebaseStorageService {
    // MARK: Constants
    
    enum StorageError: Error {
        case dataUploadFailure
        case urlDownloadFailure
    }
    
    // MARK: Properties
    
    private static let storageReference = Storage.storage().reference()
}

// MARK: - Public Methods

extension FirebaseStorageService {
    static func storeUserProfileImageData(
        _ data: Data,
        identifier: String,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        let imageDataReference = storageReference.child(FirebaseStorages.profileImages).child("\(identifier).jpg")
        
        storeImageData(data, to: imageDataReference, completion: completion)
    }
    
    static func storeUserPostImageData(
        _ data: Data,
        identifier: String,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        let imageIdentifier = UUID().description
        let imageDataReference = storageReference
            .child(FirebaseStorages.postImages)
            .child(identifier)
            .child("\(imageIdentifier).jpg")
        
        storeImageData(data, to: imageDataReference, completion: completion)
    }
}

// MARK: - Private Methods

private extension FirebaseStorageService {
    static func storeImageData(
        _ data: Data,
        to storageReference: StorageReference,
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

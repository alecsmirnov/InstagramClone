//
//  EditProfileService.swift
//  Instagram
//
//  Created by Admin on 17.03.2021.
//

import UIKit

final class EditProfileService: EditProfileServiceProtocol {
    func updateUser(
        currentUsername: String,
        fullName: String?,
        username: String,
        website: String?,
        bio: String?,
        profileImage: UIImage?,
        completion: @escaping (EditProfileServiceResult) -> Void
    ) {
        if username != currentUsername {
            FirebaseDatabaseService.isUsernameExist(username) { [self] result in
                switch result {
                case .success(let isExist):
                    if isExist {
                        completion(.usernameExist)
                    } else {
                        updateUserRecord(
                            fullName: fullName,
                            username: username,
                            website: website,
                            bio: bio,
                            profileImage: profileImage) { error in
                            if let error = error {
                                print("Failed to update user: \(error.localizedDescription)")
                                
                                completion(.failure)
                            } else {
                                completion(.success)
                            }
                        }
                    }
                case .failure(let error):
                    print("Failed to fetch username status: \(error.localizedDescription)")
                    
                    completion(.failure)
                }
            }
        } else {
            updateUserRecord(
                fullName: fullName,
                username: username,
                website: website,
                bio: bio,
                profileImage: profileImage) { error in
                if let error = error {
                    print("Failed to update user: \(error.localizedDescription)")
                    
                    completion(.failure)
                } else {
                    completion(.success)
                }
            }
        }
    }
}

// MARK: - EditProfileUsernameServiceProtocol

extension EditProfileService: EditProfileUsernameServiceProtocol {
    func checkUsername(_ username: String, completion: @escaping (EditProfileUsernameServiceResult) -> Void) {
        guard !username.isEmpty else {
            completion(.isEmptyUsername)
            
            return
        }
        
        guard ValidationService.isValidUsername(username) else {
            completion(.invalidUsername)
            
            return
        }
        
        FirebaseDatabaseService.isUsernameExist(username) { result in
            switch result {
            case .success(let isUsernameExist):
                completion(isUsernameExist ? .usernameExist : .validUsername)
            case .failure(let error):
                print("Failed to fetch username status: \(error.localizedDescription)")
            }
        }
    }
}

// MARK: - Private Methods

private extension EditProfileService {
    func updateUserRecord(
        fullName: String?,
        username: String,
        website: String?,
        bio: String?,
        profileImage: UIImage?,
        completion: @escaping (Error?) -> Void
    ) {
        guard let currentUserIdentifier = FirebaseAuthService.currentUserIdentifier else { return }
        
        let imageSize = LoginRegistrationConstants.Metrics.profileImageButtonSize
        let profileImageData = profileImage?.resize(
            withWidth: imageSize,
            height: imageSize,
            contentMode: .aspectFill).jpegData(compressionQuality: 1)
        
        FirebaseDatabaseService.updateUser(
            userIdentifier: currentUserIdentifier,
            email: nil,
            fullName: fullName,
            username: username,
            bio: bio,
            website: website,
            profileImageData: profileImageData,
            completion: completion)
    }
}

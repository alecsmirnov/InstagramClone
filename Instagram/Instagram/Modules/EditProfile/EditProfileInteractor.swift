//
//  EditProfileInteractor.swift
//  Instagram
//
//  Created by Admin on 06.03.2021.
//

import UIKit

protocol IEditProfileInteractor: AnyObject {
    func updateUser(
        currentUsername: String,
        fullName: String?,
        username: String,
        website: String?,
        bio: String?,
        profileImage: UIImage?)
}

protocol IEditProfileInteractorOutput: AnyObject {
    func userWithUsernameExist()
    func updateUserSuccess()
    func updateUserFailure()
}

final class EditProfileInteractor {
    weak var presenter: IEditProfileInteractorOutput?
}

// MARK: - IEditProfileInteractor

extension EditProfileInteractor: IEditProfileInteractor {
    func updateUser(
        currentUsername: String,
        fullName: String?,
        username: String,
        website: String?,
        bio: String?,
        profileImage: UIImage?
    ) {
        if username != currentUsername {
            FirebaseDatabaseService.isUsernameExist(username) { [self] result in
                switch result {
                case .success(let isExist):
                    if isExist {
                        presenter?.userWithUsernameExist()
                    } else {
                        updateUserRecord(
                            fullName: fullName,
                            username: username,
                            website: website,
                            bio: bio,
                            profileImage: profileImage)
                    }
                case .failure(let error):
                    presenter?.updateUserFailure()
                    
                    print("Failed to fetch username status: \(error.localizedDescription)")
                }
            }
        } else {
            updateUserRecord(
                fullName: fullName,
                username: username,
                website: website,
                bio: bio,
                profileImage: profileImage)
        }
    }
}

// MARK: - Private Methods

private extension EditProfileInteractor {
    func updateUserRecord(
        fullName: String?,
        username: String,
        website: String?,
        bio: String?,
        profileImage: UIImage?
    ) {
        guard let currentUserIdentifier = FirebaseAuthService.currentUserIdentifier else { return }
        
        let profileImageData = profileImage?.resize(
            withWidth: LoginRegistrationConstants.Metrics.profileImageButtonSize,
            height: LoginRegistrationConstants.Metrics.profileImageButtonSize,
            contentMode: .aspectFill).jpegData(compressionQuality: 1)
        
        FirebaseDatabaseService.updateUser(
            userIdentifier: currentUserIdentifier,
            fullName: fullName,
            username: username,
            bio: bio,
            website: website,
            profileImageData: profileImageData) { [self] error in
            if let error = error {
                presenter?.updateUserFailure()
                
                print("Failed to update user: \(error.localizedDescription)")
            } else {
                presenter?.updateUserSuccess()
            }
        }
    }
}

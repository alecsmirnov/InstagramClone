//
//  EditProfilePresenter.swift
//  Instagram
//
//  Created by Admin on 06.03.2021.
//

import UIKit

final class EditProfilePresenter {
    weak var view: EditProfileViewControllerProtocol?
    weak var coordinator: EditProfileCoordinatorProtocol?
    
    var editProfileService: EditProfileServiceProtocol?
    
    var user: User?
    
    private var currentUsername: String?
}

// MARK: - EditProfileView Output

extension EditProfilePresenter: EditProfileViewControllerOutputProtocol {
    func viewDidLoad() {
        guard let user = user else { return }
        
        currentUsername = user.username
        view?.setUser(user)
    }
    
    func didTapCloseButton() {
        coordinator?.closeEditProfileViewController()
    }
    
    func didTapEditButton(
        fullName: String?,
        username: String,
        website: String?,
        bio: String?,
        profileImage: UIImage?
    ) {
        guard let currentUsername = currentUsername else { return }
        
        view?.showLoadingView()
        
        editProfileService?.updateUser(
            currentUsername: currentUsername,
            fullName: fullName,
            username: username,
            website: website,
            bio: bio,
            profileImage: profileImage) { [weak self] result in
            self?.view?.hideLoadingView {
                switch result {
                case .usernameExist:
                    self?.view?.showAlreadyInUseUsernameAlert()
                case .success:
                    self?.coordinator?.closeEditProfileViewController()
                case .failure:
                    self?.view?.showUnknownAlert()
                }
            }
        }
    }
    
    func didTapUsernameTextField() {
        guard
            let username = user?.username,
            let currentUsername = currentUsername
        else {
            return
        }
        
        coordinator?.showEditProfileUsernameViewController(
            username: username,
            currentUsername: currentUsername,
            delegate: self)
    }
    
    func didTapBioTextField() {
        if let bio = user?.bio {
            coordinator?.showEditProfileBioViewController(bio: bio, delegate: self)
        }
    }
}

// MARK: - EditProfileUsernamePresenterDelegate

extension EditProfilePresenter: EditProfileUsernamePresenterDelegate {
    func editProfileUsernamePresenter(
        _ editProfileUsernamePresenter: EditProfileUsernamePresenter,
        didChangeUsername username: String
    ) {
        guard let user = user else { return }
        
        let newUser = User(
            fullName: user.fullName,
            username: username,
            profileImageURL: user.profileImageURL,
            bio: user.bio,
            website: user.website,
            identifier: user.identifier,
            kind: user.kind)
        
        self.user = newUser
        
        view?.setUser(newUser)
    }
}

// MARK: - EditProfileBioPresenterDelegate

extension EditProfilePresenter: EditProfileBioPresenterDelegate {
    func editProfileBioPresenter(_ editProfileBioPresenter: EditProfileBioPresenter, didChangeBio bio: String?) {
        user?.bio = bio
        
        if let user = user {
            view?.setUser(user)
        }
    }
}

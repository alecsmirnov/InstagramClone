//
//  ProfileCoordinator.swift
//  Instagram
//
//  Created by Admin on 13.03.2021.
//

import UIKit

protocol ProfileCoordinatorProtocol: AnyObject {
    func showFollowersViewController(user: User, followersCount: Int)
    func showFollowingViewController(user: User, followingCount: Int)
    func showEditProfileViewController(user: User)
    func showMenuViewController()
}

protocol EditProfileCoordinatorProtocol: AnyObject {
    func showEditProfileUsernameViewController(
        username: String,
        currentUsername: String,
        delegate: EditProfileUsernamePresenterDelegate)
    func showEditProfileBioViewController(bio: String?, delegate: EditProfileBioPresenterDelegate)
    func closeEditProfileViewController()
}

final class ProfileCoordinator: CoordinatorProtocol {
    // MARK: Properties
    
    var user: User?
    
    var navigationController: UINavigationController
    var childCoordinators: [CoordinatorProtocol] = []
    
    private weak var presenterController: UIViewController?
    
    // MARK: Lifecycle
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    convenience init() {
        self.init(navigationController: UINavigationController())
    }
    
    convenience init(presenterController: UIViewController?) {
        self.init()
        
        self.presenterController = presenterController
    }
}

// MARK: - Interface

extension ProfileCoordinator {
    func start() {
        let profileViewController = ProfileAssembly.createProfileViewController(user: user, coordinator: self)
        
        navigationController.pushViewController(profileViewController, animated: false)
    }
}

// MARK: - ProfileCoordinatorProtocol

extension ProfileCoordinator: ProfileCoordinatorProtocol {
    func showFollowersViewController(user: User, followersCount: Int) {
        let followersViewController = FollowersFollowingAssembly.createFollowersViewController(
            user: user,
            followersCount: followersCount)
        
        navigationController.pushViewController(followersViewController, animated: true)
    }
    
    func showFollowingViewController(user: User, followingCount: Int) {
        let followingViewController = FollowersFollowingAssembly.createFollowingViewController(
            user: user,
            followingCount: followingCount)
        
        navigationController.pushViewController(followingViewController, animated: true)
    }
    
    func showEditProfileViewController(user: User) {
        let editProfileViewController = EditProfileAssembly.createEditProfileNavigationViewController(
            user: user,
            coordinator: self)
        
        editProfileViewController.modalPresentationStyle = .fullScreen
        
        presenterController?.present(editProfileViewController, animated: true)
    }
    
    func showMenuViewController() {
        
    }
}

// MARK: - EditProfileCoordinatorProtocol

extension ProfileCoordinator: EditProfileCoordinatorProtocol {
    func showEditProfileUsernameViewController(
        username: String,
        currentUsername: String,
        delegate: EditProfileUsernamePresenterDelegate
    ) {
        let navigationViewController = EditProfileUsernameAssembly.createEditProfileUsernameNavigationViewController(
            username: username,
            currentUsername: currentUsername,
            delegate: delegate)
        
        navigationViewController.modalPresentationStyle = .fullScreen
        navigationViewController.modalTransitionStyle = .crossDissolve
        
        presenterController?.presentedViewController?.present(navigationViewController, animated: true)
    }
    
    func showEditProfileBioViewController(bio: String?, delegate: EditProfileBioPresenterDelegate) {
        let editProfileBioNavigationController = EditProfileBioAssembly.createEditProfileBioNavigationViewController(
            bio: bio,
            delegate: delegate)
        
        editProfileBioNavigationController.modalPresentationStyle = .fullScreen
        editProfileBioNavigationController.modalTransitionStyle = .crossDissolve
        
        presenterController?.presentedViewController?.present(editProfileBioNavigationController, animated: true)
    }
    
    func closeEditProfileViewController() {
        presenterController?.dismiss(animated: true)
    }
}

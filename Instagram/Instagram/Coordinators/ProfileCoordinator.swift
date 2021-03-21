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

protocol ProfileCoordinatorDelegate: AnyObject {
    func profileCoordinatorDidFinishWork(_ profileCoordinator: ProfileCoordinator)
}

protocol EditProfileCoordinatorProtocol: AnyObject {
    func showEditProfileUsernameViewController(
        username: String,
        currentUsername: String,
        delegate: EditProfileUsernamePresenterDelegate)
    func showEditProfileBioViewController(bio: String?, delegate: EditProfileBioPresenterDelegate)
    func closeEditProfileViewController()
}

protocol EditProfileUsernameCoordinatorProtocol: AnyObject {
    func closeEditProfileUsernameViewController()
}

protocol EditProfileBioCoordinatorProtocol: AnyObject {
    func closeEditProfileBioViewController()
}

protocol FollowersFollowingCoordinatorProtocol: AnyObject {
    func showProfileViewController(user: User)
}

final class ProfileCoordinator: CoordinatorProtocol {
    // MARK: Properties
    
    var menuEnabled = false
    var user: User?
    
    var navigationController: UINavigationController
    var childCoordinators: [CoordinatorProtocol] = []
    
    private weak var presenterController: UIViewController?
    private weak var delegate: ProfileCoordinatorDelegate?
    
    // MARK: Lifecycle
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    convenience init() {
        self.init(navigationController: UINavigationController())
    }
    
    convenience init(presenterController: UIViewController?, delegate: ProfileCoordinatorDelegate?) {
        self.init()
        
        self.presenterController = presenterController
        self.delegate = delegate
    }
    
    convenience init(
        navigationController: UINavigationController,
        presenterController: UIViewController?,
        delegate: ProfileCoordinatorDelegate?
    ) {
        self.init(navigationController: navigationController)
        
        self.presenterController = presenterController
        self.delegate = delegate
    }
}

// MARK: - Interface

extension ProfileCoordinator {
    func start() {
        start(animated: false)
    }
    
    func start(animated: Bool) {
        let profileViewController = ProfileAssembly.createProfileViewController(
            menuEnabled: menuEnabled,
            user: user,
            coordinator: self)
        
        navigationController.pushViewController(profileViewController, animated: animated)
    }
}

// MARK: - ProfileCoordinatorProtocol

extension ProfileCoordinator: ProfileCoordinatorProtocol {
    func showFollowersViewController(user: User, followersCount: Int) {
        let followersViewController = FollowersFollowingAssembly.createFollowersViewController(
            user: user,
            followersCount: followersCount,
            coordinator: self)
        
        navigationController.pushViewController(followersViewController, animated: true)
    }
    
    func showFollowingViewController(user: User, followingCount: Int) {
        let followingViewController = FollowersFollowingAssembly.createFollowingViewController(
            user: user,
            followingCount: followingCount,
            coordinator: self)
        
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
        FirebaseAuthService.signOut()
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
            delegate: delegate,
            coordinator: self)
        
        navigationViewController.modalPresentationStyle = .fullScreen
        navigationViewController.modalTransitionStyle = .crossDissolve
        
        presenterController?.presentedViewController?.present(navigationViewController, animated: true)
    }
    
    func showEditProfileBioViewController(bio: String?, delegate: EditProfileBioPresenterDelegate) {
        let editProfileBioNavigationController = EditProfileBioAssembly.createEditProfileBioNavigationViewController(
            bio: bio,
            delegate: delegate,
            coordinator: self)
        
        editProfileBioNavigationController.modalPresentationStyle = .fullScreen
        editProfileBioNavigationController.modalTransitionStyle = .crossDissolve
        
        presenterController?.presentedViewController?.present(editProfileBioNavigationController, animated: true)
    }
    
    func closeEditProfileViewController() {
        presenterController?.dismiss(animated: true)
    }
}

// MARK: - EditProfileUsernameCoordinatorProtocol

extension ProfileCoordinator: EditProfileUsernameCoordinatorProtocol {
    func closeEditProfileUsernameViewController() {
        presenterController?.presentedViewController?.dismiss(animated: true)
    }
}

// MARK: - EditProfileBioCoordinatorProtocol

extension ProfileCoordinator: EditProfileBioCoordinatorProtocol {
    func closeEditProfileBioViewController() {
        presenterController?.presentedViewController?.dismiss(animated: true)
    }
}

// MARK: - FollowersFollowingCoordinatorProtocol

extension ProfileCoordinator: FollowersFollowingCoordinatorProtocol {
    func showProfileViewController(user: User) {        
        let profileViewController = ProfileAssembly.createProfileViewController(user: user, coordinator: self)
        
        navigationController.pushViewController(profileViewController, animated: true)
    }
}

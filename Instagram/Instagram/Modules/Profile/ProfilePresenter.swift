//
//  ProfilePresenter.swift
//  Instagram
//
//  Created by Admin on 21.01.2021.
//

import NotificationCenter

protocol IProfilePresenter: AnyObject {
    func viewDidLoad()
    
    func didRequestPosts()
    
    func didPressEditButton()
    func didPressFollowButton()
    func didPressUnfollowButton()
    
    func didPressMenuButton()
}

final class ProfilePresenter {
    // MARK: Properties
    
    weak var viewController: IProfileViewController?
    var interactor: IProfileInteractor?
    var router: IProfileRouter?
    
    var user: User?
    
    // MARK: Initialization
    
    deinit {
        removeFollowUnfollowNotifications()
    }
}

// MARK: - IProfilePresenter

extension ProfilePresenter: IProfilePresenter {
    func viewDidLoad() {
        if let user = user, let identifier = user.identifier {
            if interactor?.isCurrentUser(identifier: identifier) ?? true {
                viewController?.showEditButton()
            } else {
                interactor?.isFollowingUser(identifier: identifier)
                
                setupFollowUnfollowNotifications()
            }
            
            viewController?.setUser(user)
            viewController?.reloadData()
            
            interactor?.fetchPosts(identifier: identifier)
        } else {
            viewController?.showEditButton()
            
            interactor?.fetchCurrentUser()
        }
    }
    
    func didRequestPosts() {
        guard let identifier = user?.identifier else { return }
        
        interactor?.requestPosts(identifier: identifier)
    }
    
    func didPressEditButton() {
        
    }
    
    func didPressFollowButton() {
        guard let identifier = user?.identifier else { return }
        
        interactor?.followUser(identifier: identifier)
    }
    
    func didPressUnfollowButton() {
        guard let identifier = user?.identifier else { return }
        
        interactor?.unfollowUser(identifier: identifier)
    }
    
    func didPressMenuButton() {
        // TODO: move to Menu module
        
        interactor?.signOut()
        
        router?.showLoginViewController()
    }
}

// MARK: - IProfileInteractorOutput

extension ProfilePresenter: IProfileInteractorOutput {
    func fetchCurrentUserSuccess(_ user: User) {
        viewController?.setUser(user)
        viewController?.reloadData()
        
        self.user = user
        
        if let identifier = user.identifier {
            interactor?.fetchPosts(identifier: identifier)
        }
    }
    
    func fetchCurrentUserFailure() {
        
    }
    
    func fetchPostsSuccess(_ posts: [Post]) {
        posts.forEach { post in
            viewController?.appendPost(post)
        }
        
        viewController?.reloadData()
    }
    
    func fetchPostsFailure() {
        
    }
    
    func requestPostSuccess() {
        
    }
    
    func requestPostFailure() {
        
    }
    
    func isFollowingUserSuccess(_ isFollowing: Bool) {
        if isFollowing {
            viewController?.showUnfollowButton()
        } else {
            viewController?.showFollowButton()
        }
        
        viewController?.reloadData()
    }
    
    func isFollowingUserFailure() {
        
    }
    
    func followUserSuccess() {
        viewController?.showUnfollowButton()
        viewController?.reloadData()
        
        sendFollowUserNotification()
    }
    
    func followUserFailure() {
        
    }
    
    func unfollowUserSuccess() {
        viewController?.showFollowButton()
        viewController?.reloadData()
        
        sendUnfollowUserNotification()
    }
    
    func unfollowUserFailure() {
        
    }
}

// MARK: - Notifications

private extension ProfilePresenter {
    func setupFollowUnfollowNotifications() {
        NotificationCenter.default.addObserver(
            forName: .followUser,
            object: nil,
            queue: nil) { [weak self] notification in
            guard let object = notification.object as? Self, object !== self else { return }
            
            self?.viewController?.showUnfollowButton()
            self?.viewController?.reloadData()
        }
        
        NotificationCenter.default.addObserver(
            forName: .unfollowUser,
            object: nil,
            queue: nil) { [weak self] notification in
            guard let object = notification.object as? Self, object !== self else { return }
            
            self?.viewController?.showFollowButton()
            self?.viewController?.reloadData()
        }
    }
    
    func removeFollowUnfollowNotifications() {
        NotificationCenter.default.removeObserver(self, name: .followUser, object: nil)
        NotificationCenter.default.removeObserver(self, name: .unfollowUser, object: nil)
    }
    
    func sendFollowUserNotification() {
        NotificationCenter.default.post(name: .followUser, object: self)
    }
    
    func sendUnfollowUserNotification() {
        NotificationCenter.default.post(name: .unfollowUser, object: self)
    }
}

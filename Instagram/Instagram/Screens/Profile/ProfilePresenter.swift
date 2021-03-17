//
//  ProfilePresenter.swift
//  Instagram
//
//  Created by Admin on 21.01.2021.
//

import NotificationCenter

final class ProfilePresenter {
    // MARK: Properties
    
    weak var view: ProfileViewControllerProtocol?
    weak var coordinator: ProfileCoordinatorProtocol?
    
    var profileService: ProfileServiceProtocol?
    
    var user: User?
    
    private var followersCount = 0
    private var followingCount = 0
    
    private var postDisplay: PostDisplay = .userPosts
    
    // MARK: Constants
    
    private enum PostDisplay {
        case userPosts
        case bookmarks
    }
    
    // MARK: Lifecycle
    
    deinit {
        removeFollowUnfollowNotifications()
    }
}

// MARK: - ProfileView Output

extension ProfilePresenter: ProfileViewControllerOutputProtocol {
    func viewDidLoad() {
        if let user = user, let userIdentifier = user.identifier {
            view?.setUser(user)
            
            if profileService?.isCurrentUser(userIdentifier: userIdentifier) ?? true {
                view?.showEditButton()
            } else {
                profileService?.isFollowingUser(userIdentifier: userIdentifier) { [weak self] isFollowing in
                    isFollowing ? self?.view?.showUnfollowButton() : self?.view?.showFollowButton()
                }
                
                setupFollowUnfollowNotifications()
            }
            
            initUserProfile(userIdentifier: userIdentifier)
        } else {
            view?.showEditButton()
            
            profileService?.fetchCurrentUser() { [weak self] user in
                self?.user = user
                
                self?.view?.setUser(user)
                self?.view?.showEditButton()
                
                if let userIdentifier = user.identifier {
                    self?.initUserProfile(userIdentifier: userIdentifier)
                }
            }
        }
    }
    
    func didRequestPosts() {
        guard let userIdentifier = user?.identifier else { return }
        
        switch postDisplay {
        case .userPosts:
            profileService?.requestPosts(userIdentifier: userIdentifier) { [weak self] posts in
                self?.appendPosts(posts)
            }
        case .bookmarks:
            profileService?.requestBookmarkedPosts(userIdentifier: userIdentifier) { [weak self] posts in
                self?.appendPosts(posts)
            }
        }
    }
    
    func didTapFollowersButton() {
        guard let user = user else { return }
        
        coordinator?.showFollowersViewController(user: user, followersCount: followersCount)
    }
    
    func didTapFollowingButton() {
        guard let user = user else { return }
        
        coordinator?.showFollowingViewController(user: user, followingCount: followingCount)
    }
    
    func didTapEditButton() {
        guard let user = user else { return }
        
        coordinator?.showEditProfileViewController(user: user)
    }
    
    func didTapFollowButton() {
        guard let userIdentifier = user?.identifier else { return }
        
        profileService?.followUser(userIdentifier: userIdentifier) { [weak self] in
            self?.view?.showUnfollowButton()
            
            self?.sendFollowUserNotification()
        }
    }
    
    func didTapUnfollowButton() {
        guard let userIdentifier = user?.identifier else { return }
        
        profileService?.unfollowUser(userIdentifier: userIdentifier) { [weak self] in
            self?.view?.showFollowButton()
            
            self?.sendUnfollowUserNotification()
        }
    }
    
    func didTapGridButton() {
        changePostDisplay(.userPosts)
    }
    
    func didTapBookmarkButton() {
        changePostDisplay(.bookmarks)
    }
    
    func didSelectPost(_ post: Post) {
        // TODO: Detail post screen
    }
    
    func didTapMenuButton() {
        coordinator?.showMenuViewController()
    }
}

// MARK: - Private Methods

private extension ProfilePresenter {
    func initUserProfile(userIdentifier: String) {
        profileService?.observeUserChanges(userIdentifier: userIdentifier) { [weak self] user in
            self?.user = user
            
            self?.view?.setUser(user)
        }
        
        profileService?.fetchObserveUserStats(userIdentifier: userIdentifier) { [weak self] userStats in
            self?.followersCount = userStats.followers
            self?.followingCount = userStats.following
            
            self?.view?.setUserStats(userStats)
        }
        
        profileService?.fetchPostsDescendingByDate(userIdentifier: userIdentifier) { [weak self] posts in
            self?.appendPosts(posts)
        }
        
        profileService?.observeNewPosts(userIdentifier: userIdentifier) { [weak self] post in
            self?.view?.appendFirstPost(post)
            self?.view?.insertNewFirstItem()
        }
    }
    
    func appendPosts(_ posts: [Post]) {
        view?.appendPosts(posts.reversed())
        view?.insertNewLastItems(count: posts.count)
    }
    
    private func changePostDisplay(_ postDisplay: PostDisplay) {
        guard let userIdentifier = user?.identifier else { return }
        
        self.postDisplay = postDisplay
        
        view?.removeAllPosts()
        view?.reloadData()
        
        switch postDisplay {
        case .userPosts:
            profileService?.fetchPostsDescendingByDate(userIdentifier: userIdentifier) { [weak self] posts in
                self?.appendPosts(posts)
            }
        case .bookmarks:
            profileService?.fetchBookmarkedPostsDescendingByDate(userIdentifier: userIdentifier) { [weak self] posts in
                self?.appendPosts(posts)
            }
        }
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
            
            self?.view?.showUnfollowButton()
        }
        
        NotificationCenter.default.addObserver(
            forName: .unfollowUser,
            object: nil,
            queue: nil) { [weak self] notification in
            guard let object = notification.object as? Self, object !== self else { return }
            
            self?.view?.showFollowButton()
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

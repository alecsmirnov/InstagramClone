//
//  ProfilePresenter.swift
//  Instagram
//
//  Created by Admin on 21.01.2021.
//

import NotificationCenter

final class ProfilePresenter {
    // MARK: Properties
    
    weak var viewController: ProfileViewControllerProtocol?
    var interactor: IProfileInteractor?
    var router: IProfileRouter?
    
    var user: User?
    var userStats: UserStats?
    
    private var isUsersPosts = true
    
    // MARK: Initialization
    
    deinit {
        interactor?.removeUserObserver()
        interactor?.removeUserStatsObserver()
        interactor?.removePostsObserver()
        
        removeFollowUnfollowNotifications()
    }
}

// MARK: - IProfilePresenter

extension ProfilePresenter: ProfileViewControllerOutputProtocol {
    func viewDidLoad() {
        if let user = user, let identifier = user.identifier {
            if interactor?.isCurrentUser(identifier: identifier) ?? true {
                viewController?.showEditButton()
            } else {
                interactor?.isFollowingUser(identifier: identifier)
                
                setupFollowUnfollowNotifications()
            }
            
            viewController?.setUser(user)
            //viewController?.reloadData()
            
            interactor?.observeUser(identifier: identifier)
            interactor?.fetchObserveUserStats(identifier: identifier)
            interactor?.fetchPosts(identifier: identifier)
            interactor?.observePosts()
        } else {
            viewController?.showEditButton()
            
            interactor?.fetchCurrentUser()
        }
    }
    
    func didRequestPosts() {
        guard let identifier = user?.identifier else { return }
        
        if isUsersPosts {
            interactor?.requestPosts(identifier: identifier)
        } else {
            interactor?.requestBookmarkedPosts(identifier: identifier)
        }
    }
    
    func didTapFollowersButton() {
        guard let user = user, let userStats = userStats else { return }
        
        router?.showFollowersViewController(user: user, userStats: userStats)
    }
    
    func didTapFollowingButton() {
        guard let user = user, let userStats = userStats else { return }
        
        router?.showFollowingViewController(user: user, userStats: userStats)
    }
    
    func didTapEditButton() {
        guard let user = user else { return }
        
        router?.showEditProfileViewController(user: user)
    }
    
    func didTapFollowButton() {
        guard let identifier = user?.identifier else { return }
        
        interactor?.followUser(identifier: identifier)
    }
    
    func didTapUnfollowButton() {
        guard let identifier = user?.identifier else { return }
        
        interactor?.unfollowUser(identifier: identifier)
    }
    
    func didTapGridButton() {
        guard let identifier = user?.identifier else { return }
        
        isUsersPosts = true
        
        viewController?.removeAllPosts()
        viewController?.reloadData()
        
        interactor?.fetchPosts(identifier: identifier)
    }
    
    func didTapBookmarkButton() {
        guard let identifier = user?.identifier else { return }
        
        isUsersPosts = false
        
        viewController?.removeAllPosts()
        viewController?.reloadData()
        
        interactor?.fetchBookmarkedPosts(identifier: identifier)
    }
    
    func didTapMenuButton() {
        // TODO: move to Menu module
        
        interactor?.signOut()
        
        router?.showLoginViewController()
    }
}

// MARK: - IProfileInteractorOutput

extension ProfilePresenter: IProfileInteractorOutput {
    func fetchCurrentUserSuccess(_ user: User) {
        self.user = user
        
        viewController?.setUser(user)
        viewController?.showEditButton()
        //viewController?.reloadData()
        
        if let identifier = user.identifier {
            interactor?.observeUser(identifier: identifier)
            interactor?.fetchObserveUserStats(identifier: identifier)
            interactor?.fetchPosts(identifier: identifier)
            interactor?.observePosts()
        }
    }
    
    func fetchCurrentUserFailure() {
        
    }
    
    func fetchUserSuccess(_ user: User) {
        self.user = user
        
        viewController?.setUser(user)
        //viewController?.reloadData()
    }
    
    func fetchUserFailure() {
        
    }
    
    func fetchUserStatsSuccess(_ userStats: UserStats) {
        self.userStats = userStats
        
        viewController?.setUserStats(userStats)
        //viewController?.reloadData()
    }
    
    func fetchUserStatsFailure() {
        
    }
    
    func fetchPostsSuccess(_ posts: [Post]) {
        guard isUsersPosts else { return }
        
        viewController?.appendPosts(posts.reversed())
        viewController?.insertNewLastItems(count: posts.count)
    }
    
    func fetchPostsFailure() {
        
    }
    
    func observePostsSuccess(_ post: Post) {
        viewController?.appendFirstPost(post)
        viewController?.insertNewFirstItem()
    }
    
    func observePostsFailure() {
        
    }
    
    func fetchBookmarkedPostsSuccess(_ posts: [Post]) {
        guard !isUsersPosts else { return }
        
        print("bookmarks")
        
        print(posts.count)
        
        viewController?.appendPosts(posts.reversed())
        viewController?.insertNewLastItems(count: posts.count)
    }
    
    func fetchBookmarkedPostsFailure() {
        
    }
    
    func isFollowingUserSuccess(_ isFollowing: Bool) {
        if isFollowing {
            viewController?.showUnfollowButton()
        } else {
            viewController?.showFollowButton()
        }
    }
    
    func isFollowingUserFailure() {
        
    }
    
    func followUserSuccess() {
        viewController?.showUnfollowButton()
        
        sendFollowUserNotification()
    }
    
    func followUserFailure() {
        
    }
    
    func unfollowUserSuccess() {
        viewController?.showFollowButton()
        
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

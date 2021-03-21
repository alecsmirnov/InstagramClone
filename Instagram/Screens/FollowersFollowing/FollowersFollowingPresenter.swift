//
//  FollowersFollowingPresenter.swift
//  Instagram
//
//  Created by Admin on 03.03.2021.
//

final class FollowersFollowingPresenter {
    // MARK: Properties
    
    weak var view: FollowersFollowingViewControllerProtocol?
    weak var coordinator: FollowersFollowingCoordinatorProtocol?
    
    var followersFollowingService: FollowersFollowingServiceProtocol?
    
    var userIdentifier: String?
    var usersCount = 0
    
    private var displayMode: FollowersFollowingViewDisplayMode
    
    // MARK: Constants
    
    enum FollowersFollowingViewDisplayMode {
        case followers
        case following
    }
    
    // MARK: Lifecycle
    
    init(displayMode: FollowersFollowingViewDisplayMode) {
        self.displayMode = displayMode
    }
}

// MARK: - FollowersFollowingView Output

extension FollowersFollowingPresenter: FollowersFollowingViewControllerOutputProtocol {
    func viewDidLoad() {
        guard
            let userIdentifier = userIdentifier,
            let isCurrentUser = followersFollowingService?.isCurrentUser(identifier: userIdentifier)
        else {
            return
        }
        
        updateTitle()
        
        if isCurrentUser {
            switch displayMode {
            case .followers:
                view?.setupFollowersAppearance()
            case .following:
                view?.setupFollowingAppearance()
            }
        } else {
            view?.setupUsersAppearance()
        }
        
        switch displayMode {
        case .followers:
            followersFollowingService?.fetchFollowers(userIdentifier: userIdentifier) { [weak self] users in
                self?.appendUsers(users)
            }
        case .following:
            followersFollowingService?.fetchFollowing(userIdentifier: userIdentifier) { [weak self] users in
                self?.appendUsers(users)
            }
        }
    }
    
    func didPullToRefresh() {
        guard let userIdentifier = userIdentifier else { return }
        
        switch displayMode {
        case .followers:
            followersFollowingService?.fetchFollowers(userIdentifier: userIdentifier) { [weak self] users in
                self?.appendUsersAfterRefresh(users)
            }
            
            followersFollowingService?.fetchFollowersCount(userIdentifier: userIdentifier) { [weak self] usersCount in
                self?.usersCount = usersCount
                
                self?.updateTitle()
            }
        case .following:
            followersFollowingService?.fetchFollowing(userIdentifier: userIdentifier) { [weak self] users in
                self?.appendUsersAfterRefresh(users)
            }
            
            followersFollowingService?.fetchFollowingsCount(userIdentifier: userIdentifier) { [weak self] usersCount in
                self?.usersCount = usersCount
                
                self?.updateTitle()
            }
        }
    }
    
    func didRequestUsers() {
        guard let userIdentifier = userIdentifier else { return }
        
        switch displayMode {
        case .followers:
            followersFollowingService?.requestFollowers(userIdentifier: userIdentifier) { [weak self] users in
                self?.appendUsers(users)
            }
        case .following:
            followersFollowingService?.requestFollowing(userIdentifier: userIdentifier) { [weak self] users in
                self?.appendUsers(users)
            }
        }
    }
    
    func didSelectUser(_ user: User) {
        coordinator?.showProfileViewController(user: user)
    }
    
    func didTapFollowButton(at index: Int, for user: User) {
        guard let userIdentifier = user.identifier else { return }
        
        followersFollowingService?.followUser(identifier: userIdentifier, at: index) { [weak self] in
            self?.followUser(at: index)
        }
    }
    
    func didTapUnfollowButton(at index: Int, for user: User) {
        guard let userIdentifier = user.identifier else { return }
        
        followersFollowingService?.unfollowUser(identifier: userIdentifier, at: index) { [weak self] in
            self?.unfollowUser(at: index)
        }
    }
    
    func didTapRemoveButton(at index: Int, for user: User) {
        guard let userIdentifier = user.identifier else { return }
        
        followersFollowingService?.removeUserFromFollowers(identifier: userIdentifier, at: index) { [weak self] in
            self?.removeUser(at: index)
        }
    }
}

// MARK: - Private Methods

private extension FollowersFollowingPresenter {
    func appendUsersAfterRefresh(_ users: [User]) {
        view?.endRefreshing()
        view?.removeAllUsers()
        view?.reloadData()
        
        appendUsers(users)
    }
    
    func appendUsers(_ users: [User]) {
        view?.appendUsers(users)
        view?.insertNewRows(count: users.count)
    }
    
    func followUser(at index: Int) {
        guard
            let userIdentifier = userIdentifier,
            let isCurrentUser = followersFollowingService?.isCurrentUser(identifier: userIdentifier)
        else {
            return
        }
        
        view?.setupUnfollowButton(at: index)
        
        if isCurrentUser {
            usersCount += 1
            updateTitle()
        }
    }
    
    func unfollowUser(at index: Int) {
        guard
            let userIdentifier = userIdentifier,
            let isCurrentUser = followersFollowingService?.isCurrentUser(identifier: userIdentifier)
        else {
            return
        }
        
        view?.setupFollowButton(at: index)
        
        if isCurrentUser {
            usersCount -= 1
            updateTitle()
        }
    }
    
    func removeUser(at index: Int) {
        guard
            let userIdentifier = userIdentifier,
            let isCurrentUser = followersFollowingService?.isCurrentUser(identifier: userIdentifier)
        else {
            return
        }
        
        view?.setupNoButton(at: index)
        
        if isCurrentUser {
            usersCount -= 1
            updateTitle()
        }
    }
    
    func updateTitle() {
        var titleText: String
        
        switch displayMode {
        case .followers:
            titleText = "followers"
        case .following:
            titleText = "following"
        }
        
        view?.setTitle(text: titleText, usersCount: usersCount)
    }
}

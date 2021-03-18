//
//  FollowersFollowingPresenter.swift
//  Instagram
//
//  Created by Admin on 03.03.2021.
//

final class FollowersFollowingPresenter {
    // MARK: Properties
    
    weak var viewController: FollowersFollowingViewControllerProtocol?
    var interactor: IFollowersFollowingInteractor?
    var router: IFollowersFollowingRouter?
    
    var userIdentifier: String?
    var usersCount = 0
    
    private var isRefreshing = false
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
            let isCurrentUser = interactor?.isCurrentUser(identifier: userIdentifier)
        else {
            return
        }
        
        updateTitle()
        
        if isCurrentUser {
            switch displayMode {
            case .followers:
                viewController?.setupFollowersAppearance()
            case .following:
                viewController?.setupFollowingAppearance()
            }
        } else {
            viewController?.setupUsersAppearance()
        }
        
        switch displayMode {
        case .followers:
            interactor?.fetchFollowers(userIdentifier: userIdentifier)
        case .following:
            interactor?.fetchFollowing(userIdentifier: userIdentifier)
        }
    }
    
    func didPullToRefresh() {
        guard let userIdentifier = userIdentifier else { return }
        
        isRefreshing = true
        
        switch displayMode {
        case .followers:
            interactor?.fetchFollowers(userIdentifier: userIdentifier)
            interactor?.fetchFollowersCount(userIdentifier: userIdentifier)
        case .following:
            interactor?.fetchFollowing(userIdentifier: userIdentifier)
            interactor?.fetchFollowingsCount(userIdentifier: userIdentifier)
        }
    }
    
    func didRequestUsers() {
        guard let userIdentifier = userIdentifier else { return }
        
        switch displayMode {
        case .followers:
            interactor?.requestFollowers(userIdentifier: userIdentifier)
        case .following:
            interactor?.requestFollowing(userIdentifier: userIdentifier)
        }
    }
    
    func didSelectUser(_ user: User) {
        router?.showProfileViewController(user: user)
    }
    
    func didTapFollowButton(at index: Int, for user: User) {
        guard let userIdentifier = user.identifier else { return }
        
        interactor?.followUser(identifier: userIdentifier, at: index)
    }
    
    func didTapUnfollowButton(at index: Int, for user: User) {
        guard let userIdentifier = user.identifier else { return }
        
        interactor?.unfollowUser(identifier: userIdentifier, at: index)
    }
    
    func didTapRemoveButton(at index: Int, for user: User) {
        guard let userIdentifier = user.identifier else { return }
        
        interactor?.removeUserFromFollowers(identifier: userIdentifier, at: index)
    }
}

// MARK: - IFollowersFollowingInteractorOutput

extension FollowersFollowingPresenter: IFollowersFollowingInteractorOutput {
    func fetchFollowersSuccess(_ users: [User]) {
        fetchSuccess(displayMode: .followers, users: users)
    }
    
    func fetchFollowersFailure() {
        
    }
    
    func fetchFollowingSuccess(_ users: [User]) {        
        fetchSuccess(displayMode: .following, users: users)
    }
    
    func fetchFollowingFailure() {
        
    }
    
    func fetchFollowersCountSuccess(_ usersCount: Int) {
        self.usersCount = usersCount
        
        updateTitle()
    }
    
    func fetchFollowersCountFailure() {
        
    }
    
    func fetchFollowingsCountSuccess(_ usersCount: Int) {
        self.usersCount = usersCount
        
        updateTitle()
    }
    
    func fetchFollowingsCountFailure() {
        
    }
    
    func followUserSuccess(at index: Int) {
        followUser(at: index)
    }
    
    func followUserFailure(at index: Int) {
        
    }
    
    func unfollowUserSuccess(at index: Int) {
        unfollowUser(at: index)
    }
    
    func unfollowUserFailure(at index: Int) {
        
    }
    
    func removeUserFromFollowersSuccess(at index: Int) {
        removeUser(at: index)
    }
    
    func removeUserFromFollowersFailure(at index: Int) {
        
    }
}

// MARK: - Private Methods

private extension FollowersFollowingPresenter {
    func fetchSuccess(displayMode: FollowersFollowingViewDisplayMode, users: [User]) {
        if isRefreshing {
            isRefreshing = false

            viewController?.endRefreshing()
            viewController?.removeAllUsers()
            viewController?.reloadData()
        }
        
        viewController?.appendUsers(users)
        viewController?.insertNewRows(count: users.count)
    }
    
    func followUser(at index: Int) {
        guard
            let userIdentifier = userIdentifier,
            let isCurrentUser = interactor?.isCurrentUser(identifier: userIdentifier)
        else {
            return
        }
        
        viewController?.setupUnfollowButton(at: index)
        
        if isCurrentUser {
            usersCount += 1
            updateTitle()
        }
    }
    
    func unfollowUser(at index: Int) {
        guard
            let userIdentifier = userIdentifier,
            let isCurrentUser = interactor?.isCurrentUser(identifier: userIdentifier)
        else {
            return
        }
        
        viewController?.setupFollowButton(at: index)
        
        if isCurrentUser {
            usersCount -= 1
            updateTitle()
        }
    }
    
    func removeUser(at index: Int) {
        guard
            let userIdentifier = userIdentifier,
            let isCurrentUser = interactor?.isCurrentUser(identifier: userIdentifier)
        else {
            return
        }
        
        viewController?.setupNoButton(at: index)
        
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
        
        viewController?.setTitle(text: titleText, usersCount: usersCount)
    }
}

//
//  FollowersFollowingPresenter.swift
//  Instagram
//
//  Created by Admin on 03.03.2021.
//

protocol IFollowersFollowingPresenter: AnyObject {
    func viewDidLoad()
    
    func didPullToRefresh()
    func didRequestUsers()
    
    func didSelectUser(_ user: User)
    func didPressFollowButton(at index: Int, user: User)
    func didPressUnfollowButton(at index: Int, user: User)
    func didPressRemoveButton(at index: Int, user: User)
}

final class FollowersFollowingPresenter {
    // MARK: Properties
    
    weak var viewController: IFollowersFollowingViewController?
    var interactor: IFollowersFollowingInteractor?
    var router: IFollowersFollowingRouter?
    
    var userIdentifier: String?
    var displayMode = FollowersFollowingDisplayMode.followers
    var usersCount = 0
    
    private var isRefreshing = false
}

// MARK: - IFollowersFollowingPresenter

extension FollowersFollowingPresenter: IFollowersFollowingPresenter {
    func viewDidLoad() {
        guard let userIdentifier = userIdentifier else { return }
        
        viewController?.setDisplayMode(displayMode, usersCount: usersCount)
        
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
    
    func didPressFollowButton(at index: Int, user: User) {
        guard let userIdentifier = user.identifier else { return }
        
        interactor?.followUser(identifier: userIdentifier, at: index)
    }
    
    func didPressUnfollowButton(at index: Int, user: User) {
        guard let userIdentifier = user.identifier else { return }
        
        interactor?.unfollowUser(identifier: userIdentifier, at: index)
    }
    
    func didPressRemoveButton(at index: Int, user: User) {
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
        
        viewController?.setDisplayMode(displayMode, usersCount: usersCount)
    }
    
    func fetchFollowersCountFailure() {
        
    }
    
    func fetchFollowingsCountSuccess(_ usersCount: Int) {
        self.usersCount = usersCount
        
        viewController?.setDisplayMode(displayMode, usersCount: usersCount)
    }
    
    func fetchFollowingsCountFailure() {
        
    }
    
    func followUserSuccess(at index: Int) {
        updateUser(state: .unfollow, at: index)
    }
    
    func followUserFailure(at index: Int) {
        
    }
    
    func unfollowUserSuccess(at index: Int) {
        updateUser(state: .follow, at: index)
    }
    
    func unfollowUserFailure(at index: Int) {
        
    }
    
    func removeUserFromFollowersSuccess(at index: Int) {
        updateUser(state: .none, at: index)
    }
    
    func removeUserFromFollowersFailure(at index: Int) {
        
    }
}

// MARK: - Private Methods

private extension FollowersFollowingPresenter {
    func fetchSuccess(displayMode: FollowersFollowingDisplayMode, users: [User]) {
        guard
            let userIdentifier = userIdentifier,
            let isCurrentUser = interactor?.isCurrentUser(identifier: userIdentifier)
        else {
            return
        }
        
        if isRefreshing {
            isRefreshing = false

            viewController?.endRefreshing()
            viewController?.removeAllUsers()
            viewController?.reloadData()
        }
        
        if isCurrentUser {
            let buttonState: FollowUnfollowRemoveButtonState = (displayMode == .followers) ? .remove : .unfollow
            
            users.forEach { user in
                viewController?.appendUser(user, buttonState: buttonState)
            }
        } else {
            users.forEach { user in
                guard let userKind = user.kind else { return }
                
                switch userKind {
                case .following:
                    viewController?.appendUser(user, buttonState: .unfollow)
                case .notFollowing:
                    viewController?.appendUser(user, buttonState: .follow)
                case .current:
                    viewController?.appendUser(user, buttonState: .none)
                }
            }
        }
        
        viewController?.reloadData()
    }
    
    func updateUser(state: FollowUnfollowRemoveButtonState, at index: Int) {
        viewController?.changeButtonState(state, at: index)
        
        updateDisplayModeAfterUserChange(state: state)
    }
    
    func updateDisplayModeAfterUserChange(state: FollowUnfollowRemoveButtonState) {
        guard
            let userIdentifier = userIdentifier,
            let isCurrentUser = interactor?.isCurrentUser(identifier: userIdentifier)
        else {
            return
        }
        
        if isCurrentUser {
            switch state {
            case .follow, .none:
                usersCount -= 1
            case .unfollow:
                usersCount += 1
            case .remove:
                break
            }
            
            viewController?.setDisplayMode(displayMode, usersCount: usersCount)
        }
    }
}

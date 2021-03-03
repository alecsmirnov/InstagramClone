//
//  FollowersFollowingPresenter.swift
//  Instagram
//
//  Created by Admin on 03.03.2021.
//

protocol IFollowersFollowingPresenter: AnyObject {
    func viewDidLoad()
    
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
    var displayMode = DisplayMode.followers
    var itemsCount = 0
    
    // MARK: Constants
    
    enum DisplayMode {
        case followers
        case following
    }
}

// MARK: - IFollowersFollowingPresenter

extension FollowersFollowingPresenter: IFollowersFollowingPresenter {
    func viewDidLoad() {
        guard let userIdentifier = userIdentifier else { return }
        
        switch displayMode {
        case .followers:
            viewController?.showFollowersCount(itemsCount)
            
            interactor?.fetchFollowers(userIdentifier: userIdentifier)
        case .following:
            viewController?.showFollowingCount(itemsCount)
            
            interactor?.fetchFollowing(userIdentifier: userIdentifier)
        }
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
        print("remove")
    }
}

// MARK: - IFollowersFollowingInteractorOutput

extension FollowersFollowingPresenter: IFollowersFollowingInteractorOutput {
    func fetchFollowersSuccess(_ followers: [User]) {
        // TODO: Check for current user
        
        followers.forEach { user in
            viewController?.appendUser(user, userState: .remove)
        }
        
        viewController?.reloadData()
    }
    
    func fetchFollowingSuccess(_ following: [User]) {
        // TODO: Check for current user
        
        following.forEach { user in
            viewController?.appendUser(user, userState: .unfollow)
        }
        
        viewController?.reloadData()
    }
    
    func followUserSuccess(at index: Int) {
        viewController?.updateUser(at: index, userState: .unfollow)
        viewController?.reloadRow(at: index)
    }
    
    func followUserFailure(at index: Int) {
        
    }
    
    func unfollowUserSuccess(at index: Int) {
        viewController?.updateUser(at: index, userState: .follow)
        viewController?.reloadRow(at: index)
    }
    
    func unfollowUserFailure(at index: Int) {
        
    }
}

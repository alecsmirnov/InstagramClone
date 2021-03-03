//
//  FollowersFollowingInteractor.swift
//  Instagram
//
//  Created by Admin on 03.03.2021.
//

protocol IFollowersFollowingInteractor: AnyObject {
    func fetchFollowers(userIdentifier: String)
    func fetchFollowing(userIdentifier: String)
    
    func followUser(identifier: String, at index: Int)
    func unfollowUser(identifier: String, at index: Int)
}

protocol IFollowersFollowingInteractorOutput: AnyObject {
    func fetchFollowersSuccess(_ followers: [User])
    func fetchFollowingSuccess(_ following: [User])
    
    func followUserSuccess(at index: Int)
    func followUserFailure(at index: Int)
    
    func unfollowUserSuccess(at index: Int)
    func unfollowUserFailure(at index: Int)
}

final class FollowersFollowingInteractor {
    weak var presenter: IFollowersFollowingInteractorOutput?
}

// MARK: - IFollowersFollowingInteractor

extension FollowersFollowingInteractor: IFollowersFollowingInteractor {
    func fetchFollowers(userIdentifier: String) {
        FirebaseUserService.fetchFollowersFollowing(
            identifier: userIdentifier,
            table: FirebaseTables.followers) { [self] result in
            switch result {
            case .success(let users):
                presenter?.fetchFollowersSuccess(users)
            case .failure(_):
                break
            }
        }
    }
    
    func fetchFollowing(userIdentifier: String) {
        FirebaseUserService.fetchFollowersFollowing(
            identifier: userIdentifier,
            table: FirebaseTables.following) { [self] result in
            switch result {
            case .success(let users):
                presenter?.fetchFollowingSuccess(users)
                print("fetch following")
            case .failure(_):
                break
            }
        }
    }
    
    func followUser(identifier: String, at index: Int) {
        guard let currentUserIdentifier = FirebaseAuthService.currentUserIdentifier else { return }
        
        FirebaseUserService.followUserAndFeed(
            currentUserIdentifier: currentUserIdentifier,
            followingUserIdentifier: identifier) { [self] error in
            if let error = error {
                presenter?.followUserFailure(at: index)
                
                print("Failed to follow user at index \(index): \(error.localizedDescription)")
            } else {
                presenter?.followUserSuccess(at: index)
            }
        }
    }
    
    func unfollowUser(identifier: String, at index: Int) {
        guard let currentUserIdentifier = FirebaseAuthService.currentUserIdentifier else { return }
        
        FirebaseUserService.unfollowUserAndFeed(
            currentUserIdentifier: currentUserIdentifier,
            followingUserIdentifier: identifier) { [self] error in
            if let error = error {
                presenter?.unfollowUserFailure(at: index)
                
                print("Failed to unfollow user at index \(index): \(error.localizedDescription)")
            } else {
                presenter?.unfollowUserSuccess(at: index)
            }
        }
    }
}

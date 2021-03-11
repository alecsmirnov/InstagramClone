//
//  FollowersFollowingInteractor.swift
//  Instagram
//
//  Created by Admin on 03.03.2021.
//

protocol IFollowersFollowingInteractor: AnyObject {
    func fetchFollowers(userIdentifier: String)
    func requestFollowers(userIdentifier: String)
    
    func fetchFollowing(userIdentifier: String)
    func requestFollowing(userIdentifier: String)
    
    func fetchFollowersCount(userIdentifier: String)
    func fetchFollowingsCount(userIdentifier: String)
    
    func isCurrentUser(identifier: String) -> Bool
    
    func followUser(identifier: String, at index: Int)
    func unfollowUser(identifier: String, at index: Int)
    func removeUserFromFollowers(identifier: String, at index: Int)
}

protocol IFollowersFollowingInteractorOutput: AnyObject {
    func fetchFollowersSuccess(_ users: [User])
    func fetchFollowersFailure()
    
    func fetchFollowingSuccess(_ users: [User])
    func fetchFollowingFailure()
    
    func fetchFollowersCountSuccess(_ usersCount: Int)
    func fetchFollowersCountFailure()
    
    func fetchFollowingsCountSuccess(_ usersCount: Int)
    func fetchFollowingsCountFailure()
    
    func followUserSuccess(at index: Int)
    func followUserFailure(at index: Int)
    
    func unfollowUserSuccess(at index: Int)
    func unfollowUserFailure(at index: Int)
    
    func removeUserFromFollowersSuccess(at index: Int)
    func removeUserFromFollowersFailure(at index: Int)
}

final class FollowersFollowingInteractor {
    // MARK: Properties
    
    weak var presenter: IFollowersFollowingInteractorOutput?
    
    private var lastRequestedUserIdentifier: String?
    
    // MARK: Constants
    
    private enum Requests {
        static let usersLimit: UInt = 4
    }
}

// MARK: - IFollowersFollowingInteractor

extension FollowersFollowingInteractor: IFollowersFollowingInteractor {
    func fetchFollowers(userIdentifier: String) {
        guard let currentUserIdentifier = FirebaseAuthService.currentUserIdentifier else { return }
        
        FirebaseDatabaseService.fetchFollowersWithKindFromBegin(
            currentUserIdentifier: currentUserIdentifier,
            userIdentifier: userIdentifier,
            limit: Requests.usersLimit) { [self] result in
            switch result {
            case .success(let users):
                lastRequestedUserIdentifier = users.last?.identifier
                
                presenter?.fetchFollowersSuccess(users)
            case .failure(let error):
                presenter?.fetchFollowersFailure()
                
                print("Failed to fetch followers: \(error.localizedDescription)")
            }
        }
    }
    
    func requestFollowers(userIdentifier: String) {
        guard
            let currentUserIdentifier = FirebaseAuthService.currentUserIdentifier,
            let lastRequestedUserIdentifier = lastRequestedUserIdentifier
        else {
            return
        }
        
        FirebaseDatabaseService.fetchFollowersWithKindFromBegin(
            currentUserIdentifier: currentUserIdentifier,
            userIdentifier: userIdentifier,
            startAtUserIdentifier: lastRequestedUserIdentifier,
            dropFirst: true,
            limit: Requests.usersLimit + 1) { [self] result in
            switch result {
            case .success(let users):
                self.lastRequestedUserIdentifier = users.last?.identifier
                
                if !users.isEmpty {
                    presenter?.fetchFollowersSuccess(users)
                }
            case .failure(let error):
                presenter?.fetchFollowersFailure()
                
                print("Failed to fetch followers: \(error.localizedDescription)")
            }
        }
    }
    
    func fetchFollowing(userIdentifier: String) {
        guard let currentUserIdentifier = FirebaseAuthService.currentUserIdentifier else { return }
        
        FirebaseDatabaseService.fetchFollowingWithKindFromBegin(
            currentUserIdentifier: currentUserIdentifier,
            userIdentifier: userIdentifier,
            limit: Requests.usersLimit) { [self] result in
            switch result {
            case .success(let users):
                lastRequestedUserIdentifier = users.last?.identifier
                
                presenter?.fetchFollowingSuccess(users)
            case .failure(let error):
                presenter?.fetchFollowingFailure()
                
                print("Failed to fetch following: \(error.localizedDescription)")
            }
        }
    }
    
    func requestFollowing(userIdentifier: String) {
        guard
            let currentUserIdentifier = FirebaseAuthService.currentUserIdentifier,
            let lastRequestedUserIdentifier = lastRequestedUserIdentifier
        else {
            return
        }
        
        FirebaseDatabaseService.fetchFollowingWithKindFromBegin(
            currentUserIdentifier: currentUserIdentifier,
            userIdentifier: userIdentifier,
            startAtUserIdentifier: lastRequestedUserIdentifier,
            dropFirst: true,
            limit: Requests.usersLimit + 1) { [self] result in
            switch result {
            case .success(let users):
                self.lastRequestedUserIdentifier = users.last?.identifier
                
                if !users.isEmpty {
                    presenter?.fetchFollowingSuccess(users)
                }
            case .failure(let error):
                presenter?.fetchFollowingFailure()
                
                print("Failed to fetch followings: \(error.localizedDescription)")
            }
        }
    }
    
    func fetchFollowersCount(userIdentifier: String) {
        FirebaseDatabaseService.fetchUserFollowersCount(userIdentifier: userIdentifier) { [self] result in
            switch result {
            case .success(let usersCount):
                presenter?.fetchFollowersCountSuccess(usersCount)
            case .failure(let error):
                presenter?.fetchFollowersCountFailure()
                
                print("Failed to fetch followers count: \(error.localizedDescription)")
            }
        }
    }
    
    func fetchFollowingsCount(userIdentifier: String) {
        FirebaseDatabaseService.fetchUserFollowingCount(userIdentifier: userIdentifier) { [self] result in
            switch result {
            case .success(let usersCount):
                presenter?.fetchFollowingsCountSuccess(usersCount)
            case .failure(let error):
                presenter?.fetchFollowingsCountFailure()
                
                print("Failed to fetch followings count: \(error.localizedDescription)")
            }
        }
    }
    
    func isCurrentUser(identifier: String) -> Bool {
        guard let currentUserIdentifier = FirebaseAuthService.currentUserIdentifier else { return false }
        
        return identifier == currentUserIdentifier
    }
    
    func followUser(identifier: String, at index: Int) {
        guard let currentUserIdentifier = FirebaseAuthService.currentUserIdentifier else { return }
        
        FirebaseDatabaseService.followUserAndFeed(
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
        
        FirebaseDatabaseService.unfollowUserAndFeed(
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
    
    func removeUserFromFollowers(identifier: String, at index: Int) {
        guard let currentUserIdentifier = FirebaseAuthService.currentUserIdentifier else { return }
        
        FirebaseDatabaseService.unfollowUserAndFeed(
            currentUserIdentifier: identifier,
            followingUserIdentifier: currentUserIdentifier) { [self] error in
            if let error = error {
                presenter?.removeUserFromFollowersFailure(at: index)
                
                print("Failed to remove user from followers at index \(index): \(error.localizedDescription)")
            } else {
                presenter?.removeUserFromFollowersSuccess(at: index)
            }
        }
    }
}

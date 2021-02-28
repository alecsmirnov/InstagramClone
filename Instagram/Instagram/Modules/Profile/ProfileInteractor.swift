//
//  ProfileInteractor.swift
//  Instagram
//
//  Created by Admin on 21.01.2021.
//

import Foundation

protocol IProfileInteractor: AnyObject {
    func fetchCurrentUser()
    func fetchPosts(identifier: String)
    func requestPosts(identifier: String)
    
    func isCurrentUser(identifier: String) -> Bool
    func isFollowingUser(identifier: String)
    
    func followUser(identifier: String)
    func unfollowUser(identifier: String)
    
    // TODO: move to Menu module
    
    func signOut()
}

protocol IProfileInteractorOutput: AnyObject {
    func fetchCurrentUserSuccess(_ user: User)
    func fetchCurrentUserFailure()
    
    func fetchPostsSuccess(_ posts: [Post])
    func fetchPostsFailure()
    
    func requestPostSuccess()
    func requestPostFailure()
    
    func isFollowingUserSuccess(_ isFollowing: Bool)
    func isFollowingUserFailure()
    
    func followUserSuccess()
    func followUserFailure()
    
    func unfollowUserSuccess()
    func unfollowUserFailure()
}

final class ProfileInteractor {
    // MARK: Properties
    
    weak var presenter: IProfileInteractorOutput?
    
    private var lastRequestedPostTimestamp: TimeInterval?
    
    // MARK: Constants
    
    private enum Requests {
        static let postLimit: UInt = 3
    }
}

// MARK: - IProfileInteractor

extension ProfileInteractor: IProfileInteractor {
    func fetchCurrentUser() {
        guard let identifier = FirebaseAuthService.currentUserIdentifier else { return }
        
        FirebaseUserService.fetchUser(withIdentifier: identifier) { [self] result in
            switch result {
            case .success(let user):
                presenter?.fetchCurrentUserSuccess(user)
            case .failure(let error):
                presenter?.fetchCurrentUserFailure()
                
                print("Failed to fetch user: \(error.localizedDescription)")
            }
        }
    }
    
    func fetchPosts(identifier: String) {
        FirebasePostService.fetchLastPosts(identifier: identifier, limit: Requests.postLimit) { [self] result in
            switch result {
            case .success(let posts):
                lastRequestedPostTimestamp = posts.first?.timestamp
                
                presenter?.fetchPostsSuccess(posts)
            case .failure(let error):
                presenter?.fetchPostsFailure()

                print("Failed to fetch posts: \(error.localizedDescription)")
            }
        }
    }
    
    func requestPosts(identifier: String) {
        guard let lastRequestedPostTimestamp = lastRequestedPostTimestamp else { return }
        
        FirebasePostService.fetchLastPosts(
            identifier: identifier,
            afterTimestamp: lastRequestedPostTimestamp,
            dropFirst: true,
            limit: Requests.postLimit) { [self] result in
            switch result {
            case .success(let posts):
                self.lastRequestedPostTimestamp = posts.first?.timestamp
                
                if !posts.isEmpty {
                    presenter?.fetchPostsSuccess(posts)
                }
            case .failure(let error):
                presenter?.fetchPostsFailure()

                print("Failed to request posts: \(error.localizedDescription)")
            }
        }
    }
    
    func isCurrentUser(identifier: String) -> Bool {
        guard let currentUserIdentifier = FirebaseAuthService.currentUserIdentifier else { return false }
        
        return identifier == currentUserIdentifier
    }
    
    func isFollowingUser(identifier: String) {
        guard let currentUserIdentifier = FirebaseAuthService.currentUserIdentifier else { return }
        
        FirebaseUserService.isFollowingUser(
            currentUserIdentifier: currentUserIdentifier,
            followingUserIdentifier: identifier) { [self] result in
            switch result {
            case .success(let isFollowing):
                presenter?.isFollowingUserSuccess(isFollowing)
            case .failure(let error):
                presenter?.isFollowingUserFailure()
                
                print("Failed to check following user: \(error.localizedDescription)")
            }
        }
    }
    
    func followUser(identifier: String) {
        guard let currentUserIdentifier = FirebaseAuthService.currentUserIdentifier else { return }
        
        FirebaseUserService.followUserAndFeed(
            currentUserIdentifier: currentUserIdentifier,
            followingUserIdentifier: identifier) { [self] error in
            if let error = error {
                presenter?.followUserFailure()
                
                print("Failed to follow user: \(error.localizedDescription)")
            } else {
                presenter?.followUserSuccess()
            }
        }
    }
    
    func unfollowUser(identifier: String) {
        guard let currentUserIdentifier = FirebaseAuthService.currentUserIdentifier else { return }
        
        FirebaseUserService.unfollowUserAndFeed(
            currentUserIdentifier: currentUserIdentifier,
            followingUserIdentifier: identifier) { [self] error in
            if let error = error {
                presenter?.unfollowUserFailure()
                
                print("Failed to unfollow user: \(error.localizedDescription)")
            } else {
                presenter?.unfollowUserSuccess()
            }
        }
    }
    
    func signOut() {
        FirebaseAuthService.signOut()
    }
}

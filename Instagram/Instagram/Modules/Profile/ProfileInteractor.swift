//
//  ProfileInteractor.swift
//  Instagram
//
//  Created by Admin on 21.01.2021.
//

protocol IProfileInteractor: AnyObject {
    func fetchCurrentUser()
    func fetchPosts(identifier: String)
    
    func isCurrentUserIdentifier(_ identifier: String) -> Bool
    
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
    
    func isFollowingUserSuccess(_ isFollowing: Bool)
    func isFollowingUserFailure()
    
    func followUserSuccess()
    func followUserFailure()
    
    func unfollowUserSuccess()
    func unfollowUserFailure()
}

final class ProfileInteractor {
    weak var presenter: IProfileInteractorOutput?
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
        FirebasePostService.fetchAllPosts(identifier: identifier) { [self] result in
            switch result {
            case .success(let posts):
                presenter?.fetchPostsSuccess(posts)
            case .failure(let error):
                presenter?.fetchPostsFailure()
                
                print("Failed to fetch posts: \(error.localizedDescription)")
            }
        }
    }
    
    func isCurrentUserIdentifier(_ identifier: String) -> Bool {
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
        
        FirebaseUserService.followUser(
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
        
        FirebaseUserService.unfollowUser(
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

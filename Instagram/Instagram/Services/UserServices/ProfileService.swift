//
//  ProfileService.swift
//  Instagram
//
//  Created by Admin on 17.03.2021.
//

import UIKit

final class ProfileService {
    // MARK: Properties
    
    private var lastRequestedPostTimestamp: TimeInterval?
    
    private var userObserver: FirebaseObserver?
    private var userStatsObservers: [FirebaseObserver]?
    private var postsObserver: FirebaseObserver?
    
    // MARK: Constants
    
    private enum Requests {
        static let postLimit: UInt = 6
    }
    
    // MARK: Lifecycle
    
    deinit {
        removeUserObserver()
        removeUserStatsObserver()
        removePostsObserver()
    }
}

// MARK: - Public Methods

extension ProfileService: ProfileServiceProtocol {
    func fetchCurrentUser(completion: @escaping (User) -> Void) {
        guard let currentUserIdentifier = FirebaseAuthService.currentUserIdentifier else { return }
        
        FirebaseDatabaseService.fetchUser(userIdentifier: currentUserIdentifier) { result in
            switch result {
            case .success(let user):
                completion(user)
            case .failure(let error):
                print("Failed to fetch current user: \(error.localizedDescription)")
            }
        }
    }
    
    func observeUserChanges(userIdentifier: String, completion: @escaping (User) -> Void) {
        removeUserObserver()
        
        userObserver = FirebaseDatabaseService.observeUser(userIdentifier: userIdentifier) { result in
            switch result {
            case .success(let user):
                completion(user)
                break
            case .failure(let error):
                print("Failed to fetch observed user: \(error.localizedDescription)")
            }
        }
    }
    
    func removeUserObserver() {
        userObserver?.remove()
        userObserver = nil
    }
    
    func fetchObserveUserStats(userIdentifier: String, completion: @escaping (UserStats) -> Void) {
        removeUserStatsObserver()
        
        userStatsObservers = FirebaseDatabaseService.observeUserStats(userIdentifier: userIdentifier) { result in
            switch result {
            case .success(let userStats):
                completion(userStats)
            case .failure(let error):
                print("Failed to fetch observed user stats: \(error.localizedDescription)")
            }
        }
    }
    
    func removeUserStatsObserver() {
        userStatsObservers?.forEach { observer in
            observer.remove()
        }
        
        userStatsObservers = nil
    }
    
    func fetchPostsDescendingByDate(userIdentifier: String, completion: @escaping ([Post]) -> Void) {
        FirebaseDatabaseService.fetchPostsFromEnd(
            userIdentifier: userIdentifier,
            limit: Requests.postLimit) { [self] result in
            switch result {
            case .success(let posts):
                lastRequestedPostTimestamp = posts.first?.timestamp
                
                if !posts.isEmpty {
                    completion(posts)
                }
            case .failure(let error):
                print("Failed to fetch posts: \(error.localizedDescription)")
            }
        }
    }
    
    func requestPosts(userIdentifier: String, completion: @escaping ([Post]) -> Void) {
        guard let lastRequestedPostTimestamp = lastRequestedPostTimestamp else { return }
        
        // To prevent bug with collectionView dynamic header size and multiple calls to this method
        self.lastRequestedPostTimestamp = nil
        
        FirebaseDatabaseService.fetchPostsFromEnd(
            userIdentifier: userIdentifier,
            endAtTimestamp: lastRequestedPostTimestamp,
            dropLast: true,
            limit: Requests.postLimit + 1) { [self] result in
            switch result {
            case .success(let posts):
                self.lastRequestedPostTimestamp = posts.first?.timestamp
                
                if !posts.isEmpty {
                    completion(posts)
                }
            case .failure(let error):
                print("Failed to request posts: \(error.localizedDescription)")
            }
        }
    }
    
    func observeNewPosts(userIdentifier: String, completion: @escaping (Post) -> Void) {
        removePostsObserver()
        
        postsObserver = FirebaseDatabaseService.observePosts(userIdentifier: userIdentifier) { result in
            switch result {
            case .success(let post):
                completion(post)
            case .failure(let error):
                print("Failed to fetch observed posts: \(error.localizedDescription)")
            }
        }
    }
    
    func removePostsObserver() {
        postsObserver?.remove()
        postsObserver = nil
    }
    
    func fetchBookmarkedPostsDescendingByDate(userIdentifier: String, completion: @escaping ([Post]) -> Void) {
        FirebaseDatabaseService.fetchBookmarkedPostsFromEnd(
            userIdentifier: userIdentifier,
            limit: Requests.postLimit) { [self] result in
            switch result {
            case .success(let posts):
                lastRequestedPostTimestamp = posts.first?.timestamp
                
                if !posts.isEmpty {
                    completion(posts)
                }
            case .failure(let error):
                print("Failed to fetch bookmarked posts: \(error.localizedDescription)")
            }
        }
    }
    
    func requestBookmarkedPosts(userIdentifier: String, completion: @escaping ([Post]) -> Void) {
        guard let lastRequestedPostTimestamp = lastRequestedPostTimestamp else { return }
        
        // To prevent bug with collectionView dynamic header size and multiple calls to this method
        self.lastRequestedPostTimestamp = nil
        
        FirebaseDatabaseService.fetchBookmarkedPostsFromEnd(
            userIdentifier: userIdentifier,
            endAtTimestamp: lastRequestedPostTimestamp,
            dropLast: true,
            limit: Requests.postLimit + 1) { [self] result in
            switch result {
            case .success(let posts):
                self.lastRequestedPostTimestamp = posts.first?.timestamp
                
                if !posts.isEmpty {
                    completion(posts)
                }
            case .failure(let error):
                print("Failed to request bookmarked posts: \(error.localizedDescription)")
            }
        }
    }
    
    func isCurrentUser(userIdentifier: String) -> Bool {
        guard let currentUserIdentifier = FirebaseAuthService.currentUserIdentifier else { return false }
        
        return userIdentifier == currentUserIdentifier
    }
    
    func isFollowingUser(userIdentifier: String, completion: @escaping (Bool) -> Void) {
        guard let currentUserIdentifier = FirebaseAuthService.currentUserIdentifier else { return }
        
        FirebaseDatabaseService.isFollowingUser(
            currentUserIdentifier: currentUserIdentifier,
            followingUserIdentifier: userIdentifier) { result in
            switch result {
            case .success(let isFollowing):
                completion(isFollowing)
            case .failure(let error):
                print("Failed to check following user: \(error.localizedDescription)")
            }
        }
    }
    
    func followUser(userIdentifier: String, completion: @escaping () -> Void) {
        guard let currentUserIdentifier = FirebaseAuthService.currentUserIdentifier else { return }
        
        FirebaseDatabaseService.followUserAndFeed(
            currentUserIdentifier: currentUserIdentifier,
            followingUserIdentifier: userIdentifier) { error in
            if let error = error {
                print("Failed to follow user: \(error.localizedDescription)")
            } else {
                completion()
            }
        }
    }
    
    func unfollowUser(userIdentifier: String, completion: @escaping () -> Void) {
        guard let currentUserIdentifier = FirebaseAuthService.currentUserIdentifier else { return }
        
        FirebaseDatabaseService.unfollowUserAndFeed(
            currentUserIdentifier: currentUserIdentifier,
            followingUserIdentifier: userIdentifier) { error in
            if let error = error {
                print("Failed to unfollow user: \(error.localizedDescription)")
            } else {
                completion()
            }
        }
    }
}

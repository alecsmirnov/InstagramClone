//
//  FeedService.swift
//  Instagram
//
//  Created by Admin on 21.03.2021.
//

import Foundation

final class FeedService {
    // MARK: Properties
    
    private var lastRequestedPostTimestamp: TimeInterval?
    private var userFeedObserver: FirebaseObserver?
    
    // MARK: Constants
    
    private enum Requests {
        static let postLimit: UInt = 2
    }
    
    // MARK: Lifecycle
    
    deinit {
        removeUserFeedObserver()
    }
}

// MARK: - FeedServiceProtocol

extension FeedService: FeedServiceProtocol {
    func fetchUserPostsDescendingByDate(completion: @escaping ([UserPost]) -> Void) {
        guard let identifier = FirebaseAuthService.currentUserIdentifier else { return }
        
        FirebaseDatabaseService.isUserFeedExist(userIdentifier: identifier) { [weak self] result in
            switch result {
            case .success(let isFeedExist):
                guard isFeedExist else {
                    completion([])

                    return
                }
                
                FirebaseDatabaseService.fetchUserFeedPostsFromEnd(
                    userIdentifier: identifier,
                    limit: Requests.postLimit) { result in
                    switch result {
                    case .success(let userPosts):
                        self?.lastRequestedPostTimestamp = userPosts.first?.post.timestamp
                        
                        completion(userPosts)
                    case .failure(let error):
                        print("Failed to fetch users posts: \(error.localizedDescription)")
                    }
                }
            case .failure(let error):
                print("Failed to check existed user feed: \(error.localizedDescription)")
            }
        }
    }
    
    func requestUserPosts(completion: @escaping ([UserPost]) -> Void) {
        guard
            let identifier = FirebaseAuthService.currentUserIdentifier,
            let lastRequestedPostTimestamp = lastRequestedPostTimestamp
        else {
            return
        }
        
        self.lastRequestedPostTimestamp = nil
        
        FirebaseDatabaseService.fetchUserFeedPostsFromEnd(
            userIdentifier: identifier,
            endAtTimestamp: lastRequestedPostTimestamp,
            dropLast: true,
            limit: Requests.postLimit + 1) { [weak self] result in
            switch result {
            case .success(let userPosts):
                self?.lastRequestedPostTimestamp = userPosts.first?.post.timestamp
                
                if !userPosts.isEmpty {
                    completion(userPosts)
                }
            case .failure(let error):
                print("Failed to request users posts: \(error.localizedDescription)")
            }
        }
    }
    
    func observeUserFeed(completion: @escaping (UserPost) -> Void) {
        guard let identifier = FirebaseAuthService.currentUserIdentifier else { return }
        
        removeUserFeedObserver()
        
        userFeedObserver = FirebaseDatabaseService.observeUserFeedPosts(userIdentifier: identifier) { result in
            switch result {
            case .success(let userPost):
                completion(userPost)
            case .failure(let error):
                print("Failed to fetch observed users posts: \(error.localizedDescription)")
            }
        }
    }
    
    func removeUserFeedObserver() {
        userFeedObserver?.remove()
        userFeedObserver = nil
    }
    
    func likePost(_ userPost: UserPost, at index: Int, completion: @escaping () -> Void) {
        guard
            let postOwnerIdentifier = userPost.postOwnerIdentifier,
            let postIdentifier = userPost.postIdentifier,
            let userIdentifier = FirebaseAuthService.currentUserIdentifier
        else {
            return
        }
        
        FirebaseDatabaseService.likePost(
            userIdentifier: userIdentifier,
            postOwnerIdentifier: postOwnerIdentifier,
            postIdentifier: postIdentifier) { error in
            if let error = error {
                print("Failed to like post at index \(index): \(error.localizedDescription)")
            } else {
                completion()
            }
        }
    }
    
    func unlikePost(_ userPost: UserPost, at index: Int, completion: @escaping () -> Void) {
        guard
            let postOwnerIdentifier = userPost.postOwnerIdentifier,
            let postIdentifier = userPost.postIdentifier,
            let userIdentifier = FirebaseAuthService.currentUserIdentifier
        else {
            return
        }
        
        FirebaseDatabaseService.unlikePost(
            userIdentifier: userIdentifier,
            postOwnerIdentifier: postOwnerIdentifier,
            postIdentifier: postIdentifier) { error in
            if let error = error {
                print("Failed to unlike post at index \(index): \(error.localizedDescription)")
            } else {
                completion()
            }
        }
    }
    
    func addPostToBookmarks(_ userPost: UserPost, at index: Int, completion: @escaping () -> Void) {
        guard
            let postOwnerIdentifier = userPost.postOwnerIdentifier,
            let postIdentifier = userPost.postIdentifier,
            let userIdentifier = FirebaseAuthService.currentUserIdentifier
        else {
            return
        }
        
        let postTimestamp = userPost.post.timestamp
        
        FirebaseDatabaseService.addPostToBookmarks(
            userIdentifier: userIdentifier,
            postOwnerIdentifier: postOwnerIdentifier,
            postIdentifier: postIdentifier,
            timestamp: postTimestamp) { error in
            if let error = error {
                print("Failed to add post at index \(index) to bookmarks: \(error.localizedDescription)")
            } else {
                completion()
            }
        }
    }
    
    func removePostFromBookmarks(_ userPost: UserPost, at index: Int, completion: @escaping () -> Void) {
        guard
            let postIdentifier = userPost.postIdentifier,
            let userIdentifier = FirebaseAuthService.currentUserIdentifier
        else {
            return
        }
        
        FirebaseDatabaseService.removePostFromBookmarks(
            userIdentifier: userIdentifier,
            postIdentifier: postIdentifier) { error in
            if let error = error {
                print("Failed to remove post at index \(index) from bookmarks: \(error.localizedDescription)")
            } else {
                completion()
            }
        }
    }
}

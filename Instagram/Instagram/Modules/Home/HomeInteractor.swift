//
//  HomeInteractor.swift
//  Instagram
//
//  Created by Admin on 14.01.2021.
//

import Foundation

protocol IHomeInteractor: AnyObject {
    func fetchUserPosts()
    func requestUserPosts()
    
    func observeUserFeed()
    func removeUserFeedObserver()
    
    func likePost(_ userPost: UserPost, at index: Int)
    func unlikePost(_ userPost: UserPost, at index: Int)
    
    func addPostToBookmarks(_ userPost: UserPost, at index: Int)
    func removePostFromBookmarks(_ userPost: UserPost, at index: Int)
}

protocol IHomeInteractorOutput: AnyObject {
    func fetchUserPostSuccess(_ userPosts: [UserPost])
    func fetchUserPostNoResult()
    func fetchUserPostFailure()
    
    func observeUserFeedSuccess(_ userPost: UserPost)
    func observeUserFeedFailure()
    
    func likePostSuccess(at index: Int)
    func likePostFailure(at index: Int)
    
    func unlikePostSuccess(at index: Int)
    func unlikePostFailure(at index: Int)
    
    func addPostToBookmarksSuccess(at index: Int)
    func addPostToBookmarksFailure(at index: Int)
    
    func removePostFromBookmarksSuccess(at index: Int)
    func removePostFromBookmarksFailure(at index: Int)
}

final class HomeInteractor {
    // MARK: Properties
    
    weak var presenter: IHomeInteractorOutput?
    
    private var lastRequestedPostTimestamp: TimeInterval?
    private var userFeedObserver: FirebaseObserver?
    
    // MARK: Constants
    
    private enum Requests {
        static let postLimit: UInt = 1
    }
}

// MARK: - IHomeInteractor

extension HomeInteractor: IHomeInteractor {
    func fetchUserPosts() {
        guard let identifier = FirebaseAuthService.currentUserIdentifier else { return }
        
        FirebasePostService.isUserFeedExist(identifier: identifier) { [self] result in
            switch result {
            case .success(let isFeedExist):
                guard isFeedExist else {
                    presenter?.fetchUserPostNoResult()

                    return
                }
                
                FirebasePostService.fetchFromEndUserFeedPosts(
                    identifier: identifier,
                    limit: Requests.postLimit) { result in
                    switch result {
                    case .success(let userPosts):
                        lastRequestedPostTimestamp = userPosts.first?.post.timestamp
                        
                        presenter?.fetchUserPostSuccess(userPosts)
                    case .failure(let error):
                        presenter?.fetchUserPostFailure()

                        print("Failed to fetch users posts: \(error.localizedDescription)")
                    }
                }
            case .failure(let error):
                presenter?.fetchUserPostFailure()

                print("Failed to check existed user feed: \(error.localizedDescription)")
            }
        }
    }
    
    func requestUserPosts() {
        guard
            let identifier = FirebaseAuthService.currentUserIdentifier,
            let lastRequestedPostTimestamp = lastRequestedPostTimestamp
        else {
            return
        }
        
        self.lastRequestedPostTimestamp = nil
        
        FirebasePostService.fetchFromEndUserFeedPosts(
            identifier: identifier,
            beforeTimestamp: lastRequestedPostTimestamp,
            dropLast: true,
            limit: Requests.postLimit + 1) { [self] result in
            switch result {
            case .success(let userPosts):
                self.lastRequestedPostTimestamp = userPosts.first?.post.timestamp
                
                if !userPosts.isEmpty {
                    presenter?.fetchUserPostSuccess(userPosts)
                }
            case .failure(let error):
                presenter?.fetchUserPostFailure()

                print("Failed to request users posts: \(error.localizedDescription)")
            }
        }
    }
    
    func observeUserFeed() {
        guard let identifier = FirebaseAuthService.currentUserIdentifier else { return }
        
        removeUserFeedObserver()
        
        userFeedObserver = FirebasePostService.observeUserFeedPosts(identifier: identifier) { [self] result in
            switch result {
            case .success(let userPost):
                presenter?.observeUserFeedSuccess(userPost)
            case .failure(let error):
                presenter?.observeUserFeedFailure()

                print("Failed to fetch observed users posts: \(error.localizedDescription)")
            }
        }
    }
    
    func removeUserFeedObserver() {
        userFeedObserver?.remove()
        userFeedObserver = nil
    }
    
    func likePost(_ userPost: UserPost, at index: Int) {
        guard
            let postOwnerIdentifier = userPost.postOwnerIdentifier,
            let postIdentifier = userPost.postIdentifier,
            let userIdentifier = FirebaseAuthService.currentUserIdentifier
        else {
            return
        }
        
        FirebasePostService.likePost(
            postOwnerIdentifier: postOwnerIdentifier,
            postIdentifier: postIdentifier,
            userIdentifier: userIdentifier) { [self] error in
            if let error = error {
                presenter?.likePostFailure(at: index)
                
                print("Failed to like post at index \(index): \(error.localizedDescription)")
            } else {
                presenter?.likePostSuccess(at: index)
                
                print("Post at index \(index) successfully liked")
            }
        }
    }
    
    func unlikePost(_ userPost: UserPost, at index: Int) {
        guard
            let postOwnerIdentifier = userPost.postOwnerIdentifier,
            let postIdentifier = userPost.postIdentifier,
            let userIdentifier = FirebaseAuthService.currentUserIdentifier
        else {
            return
        }
        
        FirebasePostService.unlikePost(
            postOwnerIdentifier: postOwnerIdentifier,
            postIdentifier: postIdentifier,
            userIdentifier: userIdentifier) { [self] error in
            if let error = error {
                presenter?.unlikePostFailure(at: index)
                
                print("Failed to unlike post at index \(index): \(error.localizedDescription)")
            } else {
                presenter?.unlikePostSuccess(at: index)
                
                print("Post at index \(index) successfully unliked")
            }
        }
    }
    
    func addPostToBookmarks(_ userPost: UserPost, at index: Int) {
        guard
            let postOwnerIdentifier = userPost.postOwnerIdentifier,
            let postIdentifier = userPost.postIdentifier,
            let userIdentifier = FirebaseAuthService.currentUserIdentifier
        else {
            return
        }
        
        FirebasePostService.addPostToBookmarks(
            postOwnerIdentifier: postOwnerIdentifier,
            postIdentifier: postIdentifier,
            userIdentifier: userIdentifier) { [self] error in
            if let error = error {
                presenter?.addPostToBookmarksFailure(at: index)
                
                print("Failed to add post at index \(index) to bookmarks: \(error.localizedDescription)")
            } else {
                presenter?.addPostToBookmarksSuccess(at: index)
                
                print("Post at index \(index) successfully added to bookmarks")
            }
        }
    }
    
    func removePostFromBookmarks(_ userPost: UserPost, at index: Int) {
        guard
            let postIdentifier = userPost.postIdentifier,
            let userIdentifier = FirebaseAuthService.currentUserIdentifier
        else {
            return
        }
        
        FirebasePostService.removePostFromBookmarks(
            userIdentifier: userIdentifier,
            postIdentifier: postIdentifier) { [self] error in
            if let error = error {
                presenter?.removePostFromBookmarksFailure(at: index)
                
                print("Failed to remove post at index \(index) from bookmarks: \(error.localizedDescription)")
            } else {
                presenter?.removePostFromBookmarksSuccess(at: index)
                
                print("Post at index \(index) successfully removed from bookmarks")
            }
        }
    }
}

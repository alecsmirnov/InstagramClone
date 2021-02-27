//
//  HomeInteractor.swift
//  Instagram
//
//  Created by Admin on 14.01.2021.
//

import Dispatch

protocol IHomeInteractor: AnyObject {
    func reloadAllObservers()
    func removeAllObservers()
    
    func observeUserPosts()
    
    func likePost(_ userPost: UserPost)
    func unlikePost(_ userPost: UserPost)
}

protocol IHomeInteractorOutput: AnyObject {
    func fetchUserPostSuccess(_ userPost: UserPost)
    func fetchUserPostNoResult()
    func fetchUserPostFailure()
}

final class HomeInteractor {
    weak var presenter: IHomeInteractorOutput?
    
    private var userPostsObserver = [String: FirebaseObserver]()
}

// MARK: - IHomeInteractor

extension HomeInteractor: IHomeInteractor {
    func reloadAllObservers() {
        guard let identifier = FirebaseAuthService.currentUserIdentifier else { return }
        
        FirebasePostService.isAllPostsExists(identifier: identifier) { [self] result in
            switch result {
            case .success(let isPostsExists):
                guard isPostsExists else {
                    presenter?.fetchUserPostNoResult()
                    
                    return
                }
                
                removeAllObservers()
                observeUserPosts()
            case .failure(let error):
                presenter?.fetchUserPostFailure()
                
                print("Failed to check existed posts: \(error.localizedDescription)")
            }
        }
    }
    
    func removeAllObservers() {
        userPostsObserver.forEach { identifier, _ in
            removeUserObserver(identifier: identifier)
        }
    }
    
    func observeUserPosts() {
        guard let identifier = FirebaseAuthService.currentUserIdentifier else { return }
        
        observeUserPosts(identifier: identifier) { [self] result in
            switch result {
            case .success(let userPost):
                presenter?.fetchUserPostSuccess(userPost)
            case .failure(let error):
                presenter?.fetchUserPostFailure()
                
                print("Failed to fetch user post: \(error.localizedDescription)")
            }
        }
        
        FirebaseUserService.fetchFollowingUsersIdentifiers(identifier: identifier) { [self] result in
            switch result {
            case .success(let identifiers):
                identifiers.forEach { followingUserIdentifier in
                    observeUserPosts(identifier: followingUserIdentifier) { [self] result in
                        switch result {
                        case .success(let userPost):
                            presenter?.fetchUserPostSuccess(userPost)
                        case .failure(let error):
                            presenter?.fetchUserPostFailure()
                            
                            print("Failed to fetch following user post: \(error.localizedDescription)")
                        }
                    }
                }
            case .failure(let error):
                print("Failed to fetch following users identifiers: \(error.localizedDescription)")
            }
        }
    }
    
    func likePost(_ userPost: UserPost) {
        guard
            let postOwnerIdentifier = userPost.postOwnerIdentifier,
            let postIdentifier = userPost.postIdentifier,
            let userIdentifier = FirebaseAuthService.currentUserIdentifier
        else {
            return
        }
        
        FirebasePostService.likePost(
            postOwnerIdentifier: postOwnerIdentifier,
            postIdentifier: postIdentifier, userIdentifier: userIdentifier) { error in
            if let error = error {
                print("Failed to like post: \(error.localizedDescription)")
            } else {
                print("Post successfully liked")
            }
        }
    }
    
    func unlikePost(_ userPost: UserPost) {
        guard
            let postOwnerIdentifier = userPost.postOwnerIdentifier,
            let postIdentifier = userPost.postIdentifier,
            let userIdentifier = FirebaseAuthService.currentUserIdentifier
        else {
            return
        }
        
        FirebasePostService.unlikePost(
            postOwnerIdentifier: postOwnerIdentifier,
            postIdentifier: postIdentifier, userIdentifier: userIdentifier) { error in
            if let error = error {
                print("Failed to unlike post: \(error.localizedDescription)")
            } else {
                print("Post successfully unliked")
            }
        }
    }
}

// MARK: - Private Methods

private extension HomeInteractor {
    func observeUserPosts(identifier: String, completion: @escaping (Result<UserPost, Error>) -> Void) {
        FirebaseUserService.fetchUser(withIdentifier: identifier) { [self] result in
            switch result {
            case .success(let user):
                observePosts(identifier: identifier) { result in
                    switch result {
                    case .success(let post):
                        var userPost = UserPost(user: user, post: post)
                        
                        guard
                            let postOwnerIdentifier = userPost.postOwnerIdentifier,
                            let postIdentifier = userPost.postIdentifier,
                            let currentUserIdentifier = FirebaseAuthService.currentUserIdentifier
                        else {
                            return
                        }
                        
                        FirebasePostService.isLikedPost(
                            postOwnerIdentifier: postOwnerIdentifier,
                            postIdentifier: postIdentifier,
                            userIdentifier: currentUserIdentifier) { result in
                            switch result {
                            case .success(let isLiked):
                                userPost.isLiked = isLiked
                                
                                completion(.success(userPost))
                            case .failure(let error):
                                completion(.failure(error))
                            }
                        }
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func observePosts(identifier: String, completion: @escaping (Result<Post, Error>) -> Void) {
        removeUserObserver(identifier: identifier)
        
        userPostsObserver[identifier] = FirebasePostService.observePosts(identifier: identifier) { result in
            switch result {
            case .success(let post):
                completion(.success(post))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func removeUserObserver(identifier: String) {
        userPostsObserver[identifier]?.remove()
        userPostsObserver[identifier] = nil
    }
}

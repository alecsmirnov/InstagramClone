//
//  CommentsInteractor.swift
//  Instagram
//
//  Created by Admin on 26.02.2021.
//

import Foundation

protocol ICommentsInteractor: AnyObject {
    func sendComment(userPost: UserPost, text: String)
    
    func fetchUserComments(userPost: UserPost)
    func requestUserComments(userPost: UserPost)
    func fetchSentUserComment(userPost: UserPost)
}

protocol ICommentsInteractorOutput: AnyObject {
    func sendCommentSuccess()
    func sendCommentFailure()
    
    func fetchUserCommentsSuccess(_ userComments: [UserComment])
    func fetchUserCommentsFailure()
}

final class CommentsInteractor {
    // MARK: Properties
    
    weak var presenter: ICommentsInteractorOutput?
    
    private var lastRequestedUserCommentTimestamp: TimeInterval?
    private var beforeSentUserCommentTimestamp: TimeInterval?
    
    // MARK: Constants
    
    private enum Requests {
        static let commentLimit: UInt = 8
    }
}

// MARK: - ICommentsInteractor

extension CommentsInteractor: ICommentsInteractor {
    func sendComment(userPost: UserPost, text: String) {
        guard
            let postOwnerIdentifier = userPost.postOwnerIdentifier,
            let postIdentifier = userPost.postIdentifier,
            let senderIdentifier = FirebaseAuthService.currentUserIdentifier
        else {
            return
        }
        
        FirebasePostService.sendComment(
            postOwnerIdentifier: postOwnerIdentifier,
            postIdentifier: postIdentifier,
            senderIdentifier: senderIdentifier,
            text: text) { [self] error in
            if let error = error {
                presenter?.sendCommentFailure()
                
                print("Failed to send comment: \(error.localizedDescription)")
            } else {
                presenter?.sendCommentSuccess()
                
                print("Comment successfully sent")
            }
        }
    }
    
    func fetchUserComments(userPost: UserPost) {
        guard
            let postOwnerIdentifier = userPost.postOwnerIdentifier,
            let postIdentifier = userPost.postIdentifier
        else {
            return
        }
        
        FirebasePostService.fetchFirstUserComments(
            identifier: postOwnerIdentifier,
            postIdentifier: postIdentifier,
            limit: Requests.commentLimit) { [self] result in
            switch result {
            case .success(let userComments):
                lastRequestedUserCommentTimestamp = userComments.last?.comment.timestamp
                beforeSentUserCommentTimestamp = lastRequestedUserCommentTimestamp
                
                presenter?.fetchUserCommentsSuccess(userComments)
            case .failure(let error):
                presenter?.fetchUserCommentsFailure()

                print("Failed to fetch user comments: \(error.localizedDescription)")
            }
        }
    }
    
    func requestUserComments(userPost: UserPost) {
        guard
            let postOwnerIdentifier = userPost.postOwnerIdentifier,
            let postIdentifier = userPost.postIdentifier,
            let timestamp = lastRequestedUserCommentTimestamp
        else {
            return
        }
        
        lastRequestedUserCommentTimestamp = nil
        
        requestNextUserComments(
            postOwnerIdentifier: postOwnerIdentifier,
            postIdentifier: postIdentifier,
            timestamp: timestamp)
    }
    
    func fetchSentUserComment(userPost: UserPost) {
        guard
            let postOwnerIdentifier = userPost.postOwnerIdentifier,
            let postIdentifier = userPost.postIdentifier
        else {
            return
        }
        
        let timestamp = beforeSentUserCommentTimestamp ?? 0
        
        requestNextUserComments(
            postOwnerIdentifier: postOwnerIdentifier,
            postIdentifier: postIdentifier,
            timestamp: timestamp)
    }
}

// MARK: - Private Methods

private extension CommentsInteractor {
    func requestNextUserComments(postOwnerIdentifier: String, postIdentifier: String, timestamp: TimeInterval) {
        FirebasePostService.fetchFirstUserComments(
            identifier: postOwnerIdentifier,
            postIdentifier: postIdentifier,
            afterTimestamp: timestamp,
            dropFirst: true,
            limit: Requests.commentLimit + 1) { [self] result in
            switch result {
            case .success(let userComments):
                if !userComments.isEmpty {
                    lastRequestedUserCommentTimestamp = userComments.last?.comment.timestamp
                    beforeSentUserCommentTimestamp = lastRequestedUserCommentTimestamp
                
                    presenter?.fetchUserCommentsSuccess(userComments)
                }
            case .failure(let error):
                presenter?.fetchUserCommentsFailure()

                print("Failed to fetch user comments: \(error.localizedDescription)")
            }
        }
    }
}

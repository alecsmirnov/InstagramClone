//
//  CommentsService.swift
//  Instagram
//
//  Created by Admin on 21.03.2021.
//

import Foundation

final class CommentsService {
    // MARK: Properties
    
    private var lastRequestedUserCommentTimestamp: TimeInterval?
    private var beforeSentUserCommentTimestamp: TimeInterval?
    
    // MARK: Constants
    
    private enum Requests {
        static let commentLimit: UInt = 8
    }
}

// MARK: - CommentsServiceProtocol

extension CommentsService: CommentsServiceProtocol {
    func sendComment(userPost: UserPost, text: String, completion: @escaping () -> Void) {
        guard
            let senderIdentifier = FirebaseAuthService.currentUserIdentifier,
            let postOwnerIdentifier = userPost.postOwnerIdentifier,
            let postIdentifier = userPost.postIdentifier
        else {
            return
        }
        
        FirebaseDatabaseService.sendComment(
            senderIdentifier: senderIdentifier,
            postOwnerIdentifier: postOwnerIdentifier,
            postIdentifier: postIdentifier,
            text: text) { error in
            if let error = error {
                print("Failed to send comment: \(error.localizedDescription)")
            } else {
                completion()
            }
        }
    }
    
    func fetchSentUserComment(userPost: UserPost, completion: @escaping (UserComment) -> Void) {
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
            timestamp: timestamp,
            limit: 1) { usersComments in
            guard let userComment = usersComments.first else { return }
            
            completion(userComment)
        }
    }
    
    func fetchUserComments(userPost: UserPost, completion: @escaping ([UserComment]) -> Void) {
        guard
            let postOwnerIdentifier = userPost.postOwnerIdentifier,
            let postIdentifier = userPost.postIdentifier
        else {
            return
        }
        
        FirebaseDatabaseService.fetchUserCommentsFromBegin(
            userIdentifier: postOwnerIdentifier,
            postIdentifier: postIdentifier,
            limit: Requests.commentLimit) { [weak self] result in
            switch result {
            case .success(let userComments):
                self?.lastRequestedUserCommentTimestamp = userComments.last?.comment.timestamp
                self?.beforeSentUserCommentTimestamp = self?.lastRequestedUserCommentTimestamp
                
                completion(userComments)
            case .failure(let error):
                print("Failed to fetch user comments: \(error.localizedDescription)")
            }
        }
    }
    
    func requestUserComments(userPost: UserPost, completion: @escaping ([UserComment]) -> Void) {
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
            timestamp: timestamp,
            limit: Requests.commentLimit,
            completion: completion)
    }
}

// MARK: - Private Methods

private extension CommentsService {
    func requestNextUserComments(
        postOwnerIdentifier: String,
        postIdentifier: String,
        timestamp: TimeInterval,
        limit: UInt,
        completion: @escaping ([UserComment]) -> Void
    ) {
        var dropFirst = true
        var dropLimit: UInt = 1
        
        if beforeSentUserCommentTimestamp == nil {
            dropFirst = false
            dropLimit = 0
        }
        
        FirebaseDatabaseService.fetchUserCommentsFromBegin(
            userIdentifier: postOwnerIdentifier,
            postIdentifier: postIdentifier,
            startAtTimestamp: timestamp,
            dropFirst: dropFirst,
            limit: limit + dropLimit) { [weak self] result in
            switch result {
            case .success(let userComments):
                if !userComments.isEmpty {
                    self?.lastRequestedUserCommentTimestamp = userComments.last?.comment.timestamp
                    self?.beforeSentUserCommentTimestamp = self?.lastRequestedUserCommentTimestamp
                
                    completion(userComments)
                }
            case .failure(let error):
                print("Failed to fetch user comments: \(error.localizedDescription)")
            }
        }
    }
}

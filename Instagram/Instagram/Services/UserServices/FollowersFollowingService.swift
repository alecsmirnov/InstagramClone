//
//  FollowersFollowingService.swift
//  Instagram
//
//  Created by Admin on 18.03.2021.
//

import Foundation

final class FollowersFollowingService {
    // MARK: Properties
    
    private var lastRequestedUserIdentifier: String?
    
    // MARK: Constants
    
    private enum Requests {
        static let usersLimit: UInt = 4
    }
}

extension FollowersFollowingService: FollowersFollowingServiceProtocol {
    func fetchFollowers(userIdentifier: String, completion: @escaping ([User]) -> Void) {
        guard let currentUserIdentifier = FirebaseAuthService.currentUserIdentifier else { return }
        
        FirebaseDatabaseService.fetchFollowersWithKindFromBegin(
            currentUserIdentifier: currentUserIdentifier,
            userIdentifier: userIdentifier,
            limit: Requests.usersLimit) { [weak self] result in
            switch result {
            case .success(let users):
                self?.lastRequestedUserIdentifier = users.last?.identifier
                
                completion(users)
            case .failure(let error):
                print("Failed to fetch followers: \(error.localizedDescription)")
            }
        }
    }
    
    func requestFollowers(userIdentifier: String, completion: @escaping ([User]) -> Void) {
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
            limit: Requests.usersLimit + 1) { [weak self] result in
            switch result {
            case .success(let users):
                self?.lastRequestedUserIdentifier = users.last?.identifier
                
                if !users.isEmpty {
                    completion(users)
                }
            case .failure(let error):                
                print("Failed to fetch followers: \(error.localizedDescription)")
            }
        }
    }
    
    func fetchFollowing(userIdentifier: String, completion: @escaping ([User]) -> Void) {
        guard let currentUserIdentifier = FirebaseAuthService.currentUserIdentifier else { return }
        
        FirebaseDatabaseService.fetchFollowingWithKindFromBegin(
            currentUserIdentifier: currentUserIdentifier,
            userIdentifier: userIdentifier,
            limit: Requests.usersLimit) { [weak self] result in
            switch result {
            case .success(let users):
                self?.lastRequestedUserIdentifier = users.last?.identifier
                
                completion(users)
            case .failure(let error):
                print("Failed to fetch following: \(error.localizedDescription)")
            }
        }
    }
    
    func requestFollowing(userIdentifier: String, completion: @escaping ([User]) -> Void) {
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
            limit: Requests.usersLimit + 1) { [weak self] result in
            switch result {
            case .success(let users):
                self?.lastRequestedUserIdentifier = users.last?.identifier
                
                if !users.isEmpty {
                    completion(users)
                }
            case .failure(let error):                
                print("Failed to fetch followings: \(error.localizedDescription)")
            }
        }
    }
    
    func fetchFollowersCount(userIdentifier: String, completion: @escaping (Int) -> Void) {
        FirebaseDatabaseService.fetchUserFollowersCount(userIdentifier: userIdentifier) { result in
            switch result {
            case .success(let usersCount):
                completion(usersCount)
            case .failure(let error):
                print("Failed to fetch followers count: \(error.localizedDescription)")
            }
        }
    }
    
    func fetchFollowingsCount(userIdentifier: String, completion: @escaping (Int) -> Void) {
        FirebaseDatabaseService.fetchUserFollowingCount(userIdentifier: userIdentifier) { result in
            switch result {
            case .success(let usersCount):
                completion(usersCount)
            case .failure(let error):                
                print("Failed to fetch followings count: \(error.localizedDescription)")
            }
        }
    }
    
    func isCurrentUser(identifier: String) -> Bool {
        guard let currentUserIdentifier = FirebaseAuthService.currentUserIdentifier else { return false }
        
        return identifier == currentUserIdentifier
    }
    
    func followUser(identifier: String, at index: Int, completion: @escaping () -> Void) {
        guard let currentUserIdentifier = FirebaseAuthService.currentUserIdentifier else { return }
        
        FirebaseDatabaseService.followUserAndFeed(
            currentUserIdentifier: currentUserIdentifier,
            followingUserIdentifier: identifier) { error in
            if let error = error {
                print("Failed to follow user at index \(index): \(error.localizedDescription)")
            } else {
                completion()
            }
        }
    }
    
    func unfollowUser(identifier: String, at index: Int, completion: @escaping () -> Void) {
        guard let currentUserIdentifier = FirebaseAuthService.currentUserIdentifier else { return }
        
        FirebaseDatabaseService.unfollowUserAndFeed(
            currentUserIdentifier: currentUserIdentifier,
            followingUserIdentifier: identifier) { error in
            if let error = error {
                print("Failed to unfollow user at index \(index): \(error.localizedDescription)")
            } else {
                completion()
            }
        }
    }
    
    func removeUserFromFollowers(identifier: String, at index: Int, completion: @escaping () -> Void) {
        guard let currentUserIdentifier = FirebaseAuthService.currentUserIdentifier else { return }
        
        FirebaseDatabaseService.unfollowUserAndFeed(
            currentUserIdentifier: identifier,
            followingUserIdentifier: currentUserIdentifier) { error in
            if let error = error {
                print("Failed to remove user from followers at index \(index): \(error.localizedDescription)")
            } else {
                completion()
            }
        }
    }
}

//
//  ProfileServiceProtocol.swift
//  Instagram
//
//  Created by Admin on 17.03.2021.
//

import UIKit

protocol ProfileServiceProtocol: AnyObject {
    func fetchCurrentUser(completion: @escaping (User) -> Void)
    func observeUserChanges(userIdentifier: String, completion: @escaping (User) -> Void)
    func removeUserObserver()
    
    func fetchObserveUserStats(userIdentifier: String, completion: @escaping (UserStats) -> Void)
    func removeUserStatsObserver()
    
    func fetchPostsDescendingByDate(userIdentifier: String, completion: @escaping ([Post]) -> Void)
    func requestPosts(userIdentifier: String, completion: @escaping ([Post]) -> Void)
    func observeNewPosts(userIdentifier: String, completion: @escaping (Post) -> Void)
    func removePostsObserver()
    
    func fetchBookmarkedPostsDescendingByDate(userIdentifier: String, completion: @escaping ([Post]) -> Void)
    func requestBookmarkedPosts(userIdentifier: String, completion: @escaping ([Post]) -> Void)
    
    func isCurrentUser(userIdentifier: String) -> Bool
    func isFollowingUser(userIdentifier: String, completion: @escaping (Bool) -> Void)
    
    func followUser(userIdentifier: String, completion: @escaping () -> Void)
    func unfollowUser(userIdentifier: String, completion: @escaping () -> Void)
}

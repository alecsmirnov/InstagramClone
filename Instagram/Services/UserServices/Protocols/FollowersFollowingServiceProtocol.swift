//
//  FollowersFollowingServiceProtocol.swift
//  Instagram
//
//  Created by Admin on 18.03.2021.
//

protocol FollowersFollowingServiceProtocol: AnyObject {
    func fetchFollowers(userIdentifier: String, completion: @escaping ([User]) -> Void)
    func requestFollowers(userIdentifier: String, completion: @escaping ([User]) -> Void)
    
    func fetchFollowing(userIdentifier: String, completion: @escaping ([User]) -> Void)
    func requestFollowing(userIdentifier: String, completion: @escaping ([User]) -> Void)
    
    func fetchFollowersCount(userIdentifier: String, completion: @escaping (Int) -> Void)
    func fetchFollowingsCount(userIdentifier: String, completion: @escaping (Int) -> Void)
    
    func isCurrentUser(identifier: String) -> Bool
    
    func followUser(identifier: String, at index: Int, completion: @escaping () -> Void)
    func unfollowUser(identifier: String, at index: Int, completion: @escaping () -> Void)
    func removeUserFromFollowers(identifier: String, at index: Int, completion: @escaping () -> Void)
}

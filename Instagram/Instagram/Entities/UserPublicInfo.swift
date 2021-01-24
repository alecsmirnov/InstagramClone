//
//  UserPublicInfo.swift
//  Instagram
//
//  Created by Admin on 24.01.2021.
//

import Foundation

struct UserPublicInfo {
    let bio: String?
    let website: String?
    let posts: Int?
    let followers: Int?
    let following: Int?
}

// MARK: - Codable

extension UserPublicInfo: Codable {
    enum CodingKeys: String, CodingKey {
        case bio
        case website
        case posts
        case followers
        case following
    }
}

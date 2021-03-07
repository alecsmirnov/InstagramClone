//
//  User.swift
//  Instagram
//
//  Created by Admin on 21.01.2021.
//

struct User {
    let fullName: String?
    let username: String
    let profileImageURL: String?
    var bio: String?
    var website: String?
    
    var identifier: String?
    var kind: Kind?
    
    enum Kind {
        case following
        case notFollowing
        case current
    }
}

// MARK: - Codable

extension User: Codable {
    enum CodingKeys: String, CodingKey {
        case fullName = "full_name"
        case username
        case profileImageURL = "profile_image_url"
        case bio
        case website
    }
}

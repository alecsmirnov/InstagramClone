//
//  User.swift
//  Instagram
//
//  Created by Admin on 21.01.2021.
//

struct User {
    let email: String
    let fullName: String?
    let username: String
    let profileImageURL: String?
}

// MARK: - Codable

extension User: Codable {
    enum CodingKeys: String, CodingKey {
        case email
        case fullName = "full_name"
        case username
        case profileImageURL = "profile_image_url"
    }
}

//
//  UserNode.swift
//  Instagram
//
//  Created by Admin on 19.01.2021.
//

struct UserNode {
    let email: String
    let fullName: String?
    let username: String
}

// MARK: - Codable

extension UserNode: Codable {
    enum CodingKeys: String, CodingKey {
        case email
        case fullName = "full_name"
        case username
    }
}

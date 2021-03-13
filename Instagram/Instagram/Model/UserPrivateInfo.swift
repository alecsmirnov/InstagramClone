//
//  UserPrivateInfo.swift
//  Instagram
//
//  Created by Admin on 24.01.2021.
//

import Foundation

struct UserPrivateInfo {
    let email: String
    let gender: String?
    let phone: String?
}

// MARK: - Codable

extension UserPrivateInfo: Codable {
    enum CodingKeys: String, CodingKey {
        case email
        case gender
        case phone
    }
}

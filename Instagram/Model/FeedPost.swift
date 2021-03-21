//
//  FeedPost.swift
//  Instagram
//
//  Created by Admin on 01.03.2021.
//

import Foundation

struct FeedPost {
    let userIdentifier: String
    let timestamp: TimeInterval
    
    var postIdentifier: String?
}

// MARK: - Codable

extension FeedPost: Codable {
    enum CodingKeys: String, CodingKey {
        case userIdentifier = "user_identifier"
        case timestamp
    }
}

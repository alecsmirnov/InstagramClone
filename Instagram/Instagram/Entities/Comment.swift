//
//  Comment.swift
//  Instagram
//
//  Created by Admin on 27.02.2021.
//

import Foundation

struct Comment {
    let senderIdentifier: String
    let caption: String
    let timestamp: TimeInterval
    
    var identifier: String?
    var postIdentifier: String?
}

// MARK: - Codable

extension Comment: Codable {
    enum CodingKeys: String, CodingKey {
        case senderIdentifier = "sender_identifier"
        case caption
        case timestamp
    }
}

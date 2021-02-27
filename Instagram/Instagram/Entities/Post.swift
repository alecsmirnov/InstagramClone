//
//  Post.swift
//  Instagram
//
//  Created by Admin on 03.02.2021.
//

import Foundation
import CoreGraphics

struct Post {
    let imageURL: String
    let imageAspectRatio: CGFloat
    let caption: String?
    let timestamp: TimeInterval
    
    var identifier: String?
}

// MARK: - Codable

extension Post: Codable {
    enum CodingKeys: String, CodingKey {
        case imageURL = "image_url"
        case imageAspectRatio = "image_aspect_ratio"
        case caption
        case timestamp
    }
}

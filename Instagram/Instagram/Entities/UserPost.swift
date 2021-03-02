//
//  UserPost.swift
//  Instagram
//
//  Created by Admin on 12.02.2021.
//

struct UserPost {
    let user: User
    let post: Post
}

extension UserPost {
    var userComment: UserComment? {
        guard let comment = comment else { return nil }
        
        let userComment = UserComment(user: user, comment: comment)
        
        return userComment
    }
    
    var comment: Comment? {
        guard
            let senderIdentifier = user.identifier,
            let postIdentifier = post.identifier,
            let caption = post.caption
        else {
            return nil
        }
        
        let comment = Comment(
            senderIdentifier: senderIdentifier,
            caption: caption,
            timestamp: post.timestamp,
            identifier: nil,
            postIdentifier: postIdentifier)
        
        return comment
    }
    
    var postOwnerIdentifier: String? {
        return user.identifier
    }
    
    var postIdentifier: String? {
        return post.identifier
    }
}

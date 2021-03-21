//
//  EditProfileServiceProtocol.swift
//  Instagram
//
//  Created by Admin on 17.03.2021.
//

import UIKit

protocol EditProfileServiceProtocol: AnyObject {
    func updateUser(
        currentUsername: String,
        fullName: String?,
        username: String,
        website: String?,
        bio: String?,
        profileImage: UIImage?,
        completion: @escaping (EditProfileServiceResult) -> Void)
}

enum EditProfileServiceResult {
    case usernameExist
    case success
    case failure
}

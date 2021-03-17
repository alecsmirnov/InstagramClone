//
//  EditProfileUsernameServiceProtocol.swift
//  Instagram
//
//  Created by Admin on 17.03.2021.
//

import UIKit

protocol EditProfileUsernameServiceProtocol: AnyObject {
    func checkUsername(_ username: String, completion: @escaping (EditProfileUsernameServiceResult) -> Void)
}

enum EditProfileUsernameServiceResult {
    case validUsername
    case invalidUsername
    case usernameExist
    case isEmptyUsername
}

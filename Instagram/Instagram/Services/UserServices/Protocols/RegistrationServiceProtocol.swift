//
//  RegistrationServiceProtocol.swift
//  Instagram
//
//  Created by Admin on 16.03.2021.
//

import Foundation

protocol RegistrationServiceProtocol: AnyObject {
    func checkEmail(_ email: String, completion: @escaping (RegistrationServiceResult.CheckEmail?) -> Void)
    func checkUsername(_ username: String, completion: @escaping (RegistrationServiceResult.CheckUsername?) -> Void)
    func checkPassword(_ password: String, completion: @escaping (RegistrationServiceResult.CheckPassword?) -> Void)
    func signUp(
        withEmail email: String,
        fullName: String?,
        username: String,
        password: String,
        profileImageData: Data?,
        completion: @escaping (RegistrationServiceResult.SignUp?) -> Void)
}

enum RegistrationServiceResult {
    enum CheckEmail: Error {
        case empty
        case invalid
        case exist
    }
    
    enum CheckUsername: Error {
        case empty
        case invalid
        case exist
    }

    enum CheckPassword: Error {
        case empty
        case invalid(Int)
    }

    typealias SignUp = Error
}

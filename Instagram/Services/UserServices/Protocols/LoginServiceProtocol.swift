//
//  LoginServiceProtocol.swift
//  Instagram
//
//  Created by Admin on 16.03.2021.
//

protocol LoginServiceProtocol: AnyObject {
    func checkEmail(_ email: String, completion: @escaping (LoginServiceResult.CheckEmail?) -> Void)
    func checkPassword(_ password: String, completion: @escaping (LoginServiceResult.CheckPassword?) -> Void)
    func signIn(withEmail email: String, password: String, completion: @escaping (LoginServiceResult.SignIn?) -> Void)
}

enum LoginServiceResult {
    enum CheckEmail: Error {
        case empty
        case invalid
    }

    enum CheckPassword: Error {
        case empty
        case invalid(Int)
    }

    enum SignIn: Error {
        case userNotFound
        case wrongPassword
    }
}

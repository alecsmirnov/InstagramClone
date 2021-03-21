//
//  SearchServiceProtocol.swift
//  Instagram
//
//  Created by Admin on 16.03.2021.
//

protocol SearchServiceProtocol: AnyObject {
    var previousSearchExist: Bool { get }
    
    func searchUsers(by username: String, completion: @escaping (Result<[User], Error>) -> Void)
    func requestNextUsers(completion: @escaping (Result<[User], Error>) -> Void)
    func refreshPreviousSearch(completion: @escaping (Result<[User], Error>) -> Void)
    func clearPreviousSearch()
}

//
//  SearchInteractor.swift
//  Instagram
//
//  Created by Admin on 15.02.2021.
//

import Foundation

protocol ISearchInteractor: AnyObject {
    func fetchUsers(by username: String)
    func requestUsers()
    func refreshUsers()
}

protocol ISearchInteractorOutput: AnyObject {
    func fetchUsersSuccess(_ users: [User])
    func fetchUsersNoResult()
    func fetchUsersFailure()
}

final class SearchInteractor {
    // MARK: Properties
    
    weak var presenter: ISearchInteractorOutput?
    
    private var username: String?
    private var lastRequestedUsername: String?
    private var usersObserver: FirebaseObserver?
    
    // MARK: Constants
    
    private enum Requests {
        static let usersLimit: UInt = 8
    }
}

// MARK: - ISearchInteractor

extension SearchInteractor: ISearchInteractor {
    func fetchUsers(by username: String) {
        FirebaseUserService.isUsernamePrefixExist(username) { [weak self] result in
            switch result {
            case .success(let isExist):
                guard isExist else {
                    self?.presenter?.fetchUsersNoResult()
                    
                    return
                }
                
                self?.username = username
                
                FirebaseUserService.fetchFromBeginUsers(by: username, limit: Requests.usersLimit) { [self] result in
                    switch result {
                    case .success(let users):
                        self?.lastRequestedUsername = users.last?.username
                        
                        self?.presenter?.fetchUsersSuccess(users)
                    case .failure(let error):
                        self?.presenter?.fetchUsersFailure()
                        
                        print("Failed to fetch users: \(error.localizedDescription)")
                    }
                }
            case .failure(let error):
                self?.presenter?.fetchUsersFailure()
                
                print("Failed to checking the existence of users: \(error.localizedDescription)")
            }
        }
    }
    
    func requestUsers() {
        guard let lastRequestedUsername = lastRequestedUsername else { return }
        
        FirebaseUserService.fetchFromBeginUsers(
            by: lastRequestedUsername,
            dropFirst: true,
            limit: Requests.usersLimit + 1) { [self] result in
            switch result {
            case .success(let users):
                self.lastRequestedUsername = users.last?.username
                
                if !users.isEmpty {
                    presenter?.fetchUsersSuccess(users)
                }
            case .failure(let error):
                presenter?.fetchUsersFailure()
                
                print("Failed to fetch users: \(error.localizedDescription)")
            }
        }
    }
    
    func refreshUsers() {
        guard let username = username else { return }
        
        fetchUsers(by: username)
    }
}

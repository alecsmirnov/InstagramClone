//
//  SearchInteractor.swift
//  Instagram
//
//  Created by Admin on 15.02.2021.
//

import Foundation

protocol ISearchInteractor: AnyObject {
    func fetchUsers(by username: String)
}

protocol ISearchInteractorOutput: AnyObject {
    func fetchUserSuccess(_ user: User)
    func fetchUsersNoResult()
    func fetchUsersFailure()
}

final class SearchInteractor {
    weak var presenter: ISearchInteractorOutput?
    
    private var usersObserver: FirebaseObserver?
}

// MARK: - ISearchInteractor

extension SearchInteractor: ISearchInteractor {
    func fetchUsers(by username: String) {
        usersObserver?.remove()
        
        FirebaseUserService.isUsernamePrefixExist(username) { [weak self] result in
            switch result {
            case .success(let isExist):
                if isExist {
                    self?.observeUsers(by: username)
                } else {
                    self?.presenter?.fetchUsersNoResult()
                }
            case .failure(let error):
                self?.presenter?.fetchUsersFailure()
                
                print("Failed to fetch users: \(error.localizedDescription)")
            }
        }
    }
}

// MARK: - Private Methods

private extension SearchInteractor {
    func observeUsers(by username: String) {
        usersObserver = FirebaseUserService.fetchUsers(by: username) { [self] result in
            switch result {
            case .success(let user):
                presenter?.fetchUserSuccess(user)
            case .failure(let error):
                presenter?.fetchUsersFailure()
                
                print("Failed to fetch users: \(error.localizedDescription)")
            }
        }
    }
}

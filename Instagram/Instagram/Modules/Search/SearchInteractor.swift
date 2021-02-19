//
//  SearchInteractor.swift
//  Instagram
//
//  Created by Admin on 15.02.2021.
//

import Foundation

protocol ISearchInteractor: AnyObject {
    func fetchUsers(by username: String)
    
    func removeObservation()
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
        removeObservation()
        
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
    
    func removeObservation() {
        usersObserver?.remove()
    }
}

// MARK: - Private Methods

private extension SearchInteractor {
    func observeUsers(by username: String) {
        usersObserver = FirebaseUserService.observeUsers(by: username) { [self] result in
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

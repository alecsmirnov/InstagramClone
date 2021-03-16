//
//  SearchService.swift
//  Instagram
//
//  Created by Admin on 15.03.2021.
//

final class SearchService {
    // MARK: Properties
    
    var previousSearchExist: Bool {
        return lastUsernameSearch != nil
    }
    
    private var lastUsernameSearch: String?
    private var lastRequestedUsername: String?
    
    // MARK: Constants
    
    private enum Requests {
        static let usersLimit: UInt = 8
    }
}

// MARK: - Public Methods

extension SearchService: SearchServiceProtocol {
    func searchUsers(by username: String, completion: @escaping (Result<[User], Error>) -> Void) {
        FirebaseDatabaseService.isUsernamePrefixExist(username) { [weak self] result in
            switch result {
            case .success(let isExist):
                guard isExist else {
                    completion(.success([]))
                    
                    return
                }
                
                self?.lastUsernameSearch = username
                
                FirebaseDatabaseService.fetchUsersFromBegin(
                    startAtUsername: username,
                    limit: Requests.usersLimit) { result in
                    switch result {
                    case .success(let users):
                        self?.lastRequestedUsername = users.last?.username
                        
                        completion(.success(users))
                    case .failure(let error):
                        print("Failed to search users by \(username): \(error.localizedDescription)")
                        
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                print("Failed to checking the existence of users: \(error.localizedDescription)")
                
                completion(.failure(error))
            }
        }
    }
    
    func requestNextUsers(completion: @escaping (Result<[User], Error>) -> Void) {
        guard let lastRequestedUsername = lastRequestedUsername else { return }
        
        FirebaseDatabaseService.fetchUsersFromBegin(
            startAtUsername: lastRequestedUsername,
            dropFirst: true,
            limit: Requests.usersLimit + 1) { [weak self] result in
            switch result {
            case .success(let users):
                self?.lastRequestedUsername = users.last?.username
                
                if !users.isEmpty {
                    completion(.success(users))
                }
            case .failure(let error):
                print("Failed to fetch users: \(error.localizedDescription)")
                
                completion(.failure(error))
            }
        }
    }
    
    func refreshPreviousSearch(completion: @escaping (Result<[User], Error>) -> Void) {
        guard let lastUsernameSearch = lastUsernameSearch else { return }
        
        searchUsers(by: lastUsernameSearch, completion: completion)
    }
    
    func clearPreviousSearch() {
        lastUsernameSearch = nil
    }
}

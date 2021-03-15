//
//  SearchService.swift
//  Instagram
//
//  Created by Admin on 15.03.2021.
//

final class SearchService {
    // MARK: Properties
    
    var lastUsernameSearchIsEmpty: Bool {
        return lastUsernameSearch == nil
    }
    
    private var usersLimit: UInt
    
    private var lastUsernameSearch: String?
    private var lastRequestedUsername: String?
    
    // MARK: Initialization
    
    init(usersLimitPerFetch: UInt) {
        usersLimit = usersLimitPerFetch
    }
}

// MARK: - Public Methods

extension SearchService {
    func searchUsers(by username: String, completion: @escaping (Result<[User], Error>) -> Void) {
        FirebaseDatabaseService.isUsernamePrefixExist(username) { [weak self] result in
            switch result {
            case .success(let isExist):
                guard isExist else {
                    completion(.success([]))
                    
                    return
                }
                
                self?.lastUsernameSearch = username
                
                guard let usersLimit = self?.usersLimit else { return }
                
                FirebaseDatabaseService.fetchUsersFromBegin(startAtUsername: username, limit: usersLimit) { result in
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
            limit: usersLimit + 1) { [weak self] result in
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
    
    func refreshUsers(completion: @escaping (Result<[User], Error>) -> Void) {
        guard let lastUsernameSearch = lastUsernameSearch else { return }
        
        searchUsers(by: lastUsernameSearch, completion: completion)
    }
    
    func getLastUsernameSearch() -> String? {
        return lastUsernameSearch
    }
    
    func clearLastUsernameSearch() {
        lastUsernameSearch = nil
    }
}

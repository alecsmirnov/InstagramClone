//
//  SearchPresenter.swift
//  Instagram
//
//  Created by Admin on 15.02.2021.
//

final class SearchPresenter {
    // MARK: Properties
    
    weak var view: SearchViewControllerProtocol?
    weak var coordinator: SearchCoordinatorProtocol?
    
    var searchService: SearchServiceProtocol?
}

// MARK: - SearchView Output

extension SearchPresenter: SearchViewControllerOutputProtocol {
    func didPullToRefresh() {
        guard searchService?.previousSearchExist ?? false else {
            view?.endRefreshing()
            
            return
        }
        
        view?.removeAllUsers()
        view?.setupResultAppearance()
        
        searchService?.refreshPreviousSearch { [weak self] result in
            switch result {
            case .success(let users):
                self?.view?.endRefreshing()
                self?.applyUsersResult(users)
            case .failure(_):
                break
            }
        }
    }
    
    func didRequestUsers() {
        searchService?.requestNextUsers { [weak self] result in
            switch result {
            case .success(let users):
                self?.appendUsers(users)
            case .failure(_):
                break
            }
        }
    }
    
    func didSearchUser(by username: String) {
        view?.removeAllUsers()
        
        if username.isEmpty {
            view?.setupResultAppearance()
            
            searchService?.clearPreviousSearch()
        } else {
            view?.setupSearchAppearance()
            
            searchService?.searchUsers(by: username) { [weak self] result in
                switch result {
                case .success(let users):
                    self?.applyUsersResult(users)
                case .failure(_):
                    break
                }
            }
        }
    }
    
    func didSelectUser(_ user: User) {
        coordinator?.showProfileViewController(user: user)
    }
}

// MARK: - Private Methods

private extension SearchPresenter {
    func applyUsersResult(_ users: [User]) {
        guard !users.isEmpty else {
            view?.setupNoResultAppearance()
            
            searchService?.clearPreviousSearch()
            
            return
        }
        
        appendUsers(users)
    }
    
    func appendUsers(_ users: [User]) {
        guard !users.isEmpty else { return }
        
        view?.setupResultAppearance()
        view?.appendUsers(users)
        view?.insertNewRows(count: users.count)
    }
}

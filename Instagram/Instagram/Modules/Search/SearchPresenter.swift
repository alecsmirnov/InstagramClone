//
//  SearchPresenter.swift
//  Instagram
//
//  Created by Admin on 15.02.2021.
//

protocol ISearchPresenter: AnyObject {
    func didSearchUser(with username: String)
}

final class SearchPresenter {
    weak var viewController: ISearchViewController?
    var interactor: ISearchInteractor?
    var router: ISearchRouter?
}

// MARK: - ISearchPresenter

extension SearchPresenter: ISearchPresenter {
    func didSearchUser(with username: String) {
        viewController?.removeAllUsers()
        viewController?.setupResultAppearance()
        
        defer {
            viewController?.reloadData()
        }
        
        if !username.isEmpty {
            viewController?.setupSearchAppearance()
            
            interactor?.fetchUsers(by: username)
        }
    }
}

// MARK: - ISearchInteractorOutput

extension SearchPresenter: ISearchInteractorOutput {
    func fetchUserSuccess(_ user: User) {
        viewController?.appendUser(user)
        
        viewController?.setupResultAppearance()
        viewController?.reloadData()
    }
    
    func fetchUsersNoResult() {
        viewController?.setupNoResultAppearance()
        viewController?.reloadData()
    }
    
    func fetchUsersFailure() {
        
    }
}

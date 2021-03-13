//
//  SearchPresenter.swift
//  Instagram
//
//  Created by Admin on 15.02.2021.
//

protocol ISearchPresenter: AnyObject {
    func didPullToRefresh()
    func didRequestUsers()
    
    func didSearchUser(with username: String)
    func didSelectUser(_ user: User)
}

final class SearchPresenter {
    weak var viewController: ISearchViewController?
    var interactor: ISearchInteractor?
    var router: ISearchRouter?
    
    private var isRefreshing = false
}

// MARK: - ISearchPresenter

extension SearchPresenter: ISearchPresenter {
    func didPullToRefresh() {
        isRefreshing = true
        
        interactor?.refreshUsers()
    }
    
    func didRequestUsers() {
        interactor?.requestUsers()
    }
    
    func didSearchUser(with username: String) {
        viewController?.removeAllUsers()
        viewController?.setupResultAppearance()
        
        if !username.isEmpty {
            viewController?.setupSearchAppearance()
            
            interactor?.fetchUsers(by: username)
        }
        
        viewController?.reloadData()
    }
    
    func didSelectUser(_ user: User) {
        router?.showProfileViewController(user: user)
    }
}

// MARK: - ISearchInteractorOutput

extension SearchPresenter: ISearchInteractorOutput {
    func fetchUsersSuccess(_ users: [User]) {
        if isRefreshing {
            isRefreshing = false

            viewController?.endRefreshing()
            viewController?.removeAllUsers()
            viewController?.reloadData()
        }
        
        viewController?.setupResultAppearance()
        
        users.reversed().forEach { user in
            viewController?.appendUser(user)
        }
        
        viewController?.reloadData()
    }
    
    func fetchUsersNoResult() {
        viewController?.setupNoResultAppearance()
        viewController?.reloadData()
    }
    
    func fetchUsersFailure() {
        
    }
}

//
//  SearchPresenter.swift
//  Instagram
//
//  Created by Admin on 15.02.2021.
//

protocol ISearchPresenter: AnyObject {
    func viewWillDisappear()
    
    func didSearchUser(with username: String)
    func didSelectUser(_ user: User)
}

final class SearchPresenter {
    weak var viewController: ISearchViewController?
    var interactor: ISearchInteractor?
    var router: ISearchRouter?
}

// MARK: - ISearchPresenter

extension SearchPresenter: ISearchPresenter {
    func viewWillDisappear() {
        interactor?.removeObservation()
    }
    
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
    
    func didSelectUser(_ user: User) {
        router?.showProfileViewController(user: user)
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

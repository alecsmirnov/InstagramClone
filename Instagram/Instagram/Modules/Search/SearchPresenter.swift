//
//  SearchPresenter.swift
//  Instagram
//
//  Created by Admin on 15.02.2021.
//

protocol ISearchPresenter: AnyObject {
    
}

final class SearchPresenter {
    weak var viewController: ISearchViewController?
    var interactor: ISearchInteractor?
    var router: ISearchRouter?
}

// MARK: - ISearchPresenter

extension SearchPresenter: ISearchPresenter {
    
}

// MARK: - ISearchInteractorOutput

extension SearchPresenter: ISearchInteractorOutput {
    
}

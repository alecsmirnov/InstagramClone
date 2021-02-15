//
//  SearchInteractor.swift
//  Instagram
//
//  Created by Admin on 15.02.2021.
//

import Foundation

protocol ISearchInteractor: AnyObject {
    
}

protocol ISearchInteractorOutput: AnyObject {
    
}

final class SearchInteractor {
    weak var presenter: ISearchInteractorOutput?
}

// MARK: - ISearchInteractor

extension SearchInteractor: ISearchInteractor {
    
}

//
//  SearchAssembly.swift
//  Instagram
//
//  Created by Admin on 15.02.2021.
//

enum SearchAssembly {
    static func createSearchViewController(coordinator: SearchCoordinatorProtocol? = nil) -> SearchViewController {
        let viewController = SearchViewController()
        let presenter = SearchPresenter()
        
        viewController.output = presenter
        presenter.view = viewController
        presenter.coordinator = coordinator
        
        presenter.searchService = SearchService()
        
        return viewController
    }
}

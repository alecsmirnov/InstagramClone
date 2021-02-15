//
//  SearchAssembly.swift
//  Instagram
//
//  Created by Admin on 15.02.2021.
//

enum SearchAssembly {
    static func createSearchViewController() -> SearchViewController {
        let viewController = SearchViewController()
        
        let interactor = SearchInteractor()
        let presenter = SearchPresenter()
        let router = SearchRouter(viewController: viewController)
        
        viewController.presenter = presenter
        
        interactor.presenter = presenter
        
        presenter.viewController = viewController
        presenter.interactor = interactor
        presenter.router = router
        
        return viewController
    }
}

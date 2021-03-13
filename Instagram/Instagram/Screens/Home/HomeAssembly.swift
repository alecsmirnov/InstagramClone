//
//  HomeAssembly.swift
//  Instagram
//
//  Created by Admin on 14.01.2021.
//

enum HomeAssembly {
    static func createHomeViewController(coordinator: HomeCoordinatorProtocol? = nil) -> HomeViewController {
        let viewController = HomeViewController()
        
        let interactor = HomeInteractor()
        let presenter = HomePresenter()
        let router = HomeRouter(viewController: viewController)
        
        viewController.presenter = presenter
        
        interactor.presenter = presenter
        
        presenter.viewController = viewController
        presenter.interactor = interactor
        presenter.router = router
        
        presenter.coordinator = coordinator
        
        return viewController
    }
}

//
//  HomeAssembly.swift
//  Instagram
//
//  Created by Admin on 14.01.2021.
//

enum HomeAssembly {
    static func createHomeViewController(coordinator: HomeCoordinatorProtocol? = nil) -> HomeViewController {
        let viewController = HomeViewController()
        let presenter = HomePresenter()
        
        viewController.output = presenter
        presenter.view = viewController
        presenter.coordinator = coordinator
        
        presenter.feedService = FeedService()
        
        return viewController
    }
}

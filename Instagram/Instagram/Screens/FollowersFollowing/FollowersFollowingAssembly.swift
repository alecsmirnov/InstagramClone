//
//  FollowersFollowingAssembly.swift
//  Instagram
//
//  Created by Admin on 03.03.2021.
//

enum FollowersFollowingAssembly {    
    static func createFollowersViewController(user: User, followersCount: Int) -> FollowersFollowingViewController {
        let viewController = FollowersFollowingViewController()
        
        let interactor = FollowersFollowingInteractor()
        let presenter = FollowersFollowingPresenter(displayMode: .followers)
        let router = FollowersFollowingRouter(viewController: viewController)
        
        viewController.output = presenter
        
        interactor.presenter = presenter
        
        presenter.viewController = viewController
        presenter.interactor = interactor
        presenter.router = router
        
        presenter.userIdentifier = user.identifier
        presenter.usersCount = followersCount
        
        return viewController
    }
    
    static func createFollowingViewController(user: User, followingCount: Int) -> FollowersFollowingViewController {
        let viewController = FollowersFollowingViewController()
        
        let interactor = FollowersFollowingInteractor()
        let presenter = FollowersFollowingPresenter(displayMode: .following)
        let router = FollowersFollowingRouter(viewController: viewController)
        
        viewController.output = presenter
        
        interactor.presenter = presenter
        
        presenter.viewController = viewController
        presenter.interactor = interactor
        presenter.router = router
        
        presenter.userIdentifier = user.identifier
        presenter.usersCount = followingCount
        
        return viewController
    }
}

//
//  FollowersFollowingAssembly.swift
//  Instagram
//
//  Created by Admin on 03.03.2021.
//

enum FollowersFollowingDisplayMode {
    case followers
    case following
}

enum FollowUnfollowRemoveButtonState {
    case follow
    case unfollow
    case remove
    case none
}

enum FollowersFollowingAssembly {    
    static func createFollowersViewController(user: User, userStats: UserStats) -> FollowersFollowingViewController {
        let viewController = FollowersFollowingViewController()
        
        let interactor = FollowersFollowingInteractor()
        let presenter = FollowersFollowingPresenter()
        let router = FollowersFollowingRouter(viewController: viewController)
        
        viewController.presenter = presenter
        
        interactor.presenter = presenter
        
        presenter.viewController = viewController
        presenter.interactor = interactor
        presenter.router = router
        
        presenter.userIdentifier = user.identifier
        presenter.displayMode = .followers
        presenter.usersCount = userStats.followers
        
        return viewController
    }
    
    static func createFollowingViewController(user: User, userStats: UserStats) -> FollowersFollowingViewController {
        let viewController = FollowersFollowingViewController()
        
        let interactor = FollowersFollowingInteractor()
        let presenter = FollowersFollowingPresenter()
        let router = FollowersFollowingRouter(viewController: viewController)
        
        viewController.presenter = presenter
        
        interactor.presenter = presenter
        
        presenter.viewController = viewController
        presenter.interactor = interactor
        presenter.router = router
        
        presenter.userIdentifier = user.identifier
        presenter.displayMode = .following
        presenter.usersCount = userStats.following
        
        return viewController
    }
}

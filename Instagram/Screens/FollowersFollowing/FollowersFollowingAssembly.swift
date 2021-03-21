//
//  FollowersFollowingAssembly.swift
//  Instagram
//
//  Created by Admin on 03.03.2021.
//

enum FollowersFollowingAssembly {    
    static func createFollowersViewController(
        user: User,
        followersCount: Int,
        coordinator: FollowersFollowingCoordinatorProtocol? = nil
    ) -> FollowersFollowingViewController {
        let viewController = FollowersFollowingViewController()
        let presenter = FollowersFollowingPresenter(displayMode: .followers)
        
        viewController.output = presenter
        presenter.view = viewController
        presenter.coordinator = coordinator
        
        presenter.followersFollowingService = FollowersFollowingService()
        
        presenter.userIdentifier = user.identifier
        presenter.usersCount = followersCount
        
        return viewController
    }
    
    static func createFollowingViewController(
        user: User,
        followingCount: Int,
        coordinator: FollowersFollowingCoordinatorProtocol? = nil
    ) -> FollowersFollowingViewController {
        let viewController = FollowersFollowingViewController()
        let presenter = FollowersFollowingPresenter(displayMode: .following)
        
        viewController.output = presenter
        presenter.view = viewController
        presenter.coordinator = coordinator
        
        presenter.followersFollowingService = FollowersFollowingService()
        
        presenter.userIdentifier = user.identifier
        presenter.usersCount = followingCount
        
        return viewController
    }
}

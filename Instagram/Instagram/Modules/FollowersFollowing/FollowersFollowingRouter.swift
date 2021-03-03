//
//  FollowersFollowingRouter.swift
//  Instagram
//
//  Created by Admin on 03.03.2021.
//

protocol IFollowersFollowingRouter: AnyObject {
    
}

final class FollowersFollowingRouter {
    private weak var viewController: FollowersFollowingViewController?
    
    init(viewController: FollowersFollowingViewController) {
        self.viewController = viewController
    }
}

// MARK: - IFollowersFollowingRouter

extension FollowersFollowingRouter: IFollowersFollowingRouter {
    
}

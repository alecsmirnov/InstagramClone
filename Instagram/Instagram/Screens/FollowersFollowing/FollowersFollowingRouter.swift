//
//  FollowersFollowingRouter.swift
//  Instagram
//
//  Created by Admin on 03.03.2021.
//

protocol IFollowersFollowingRouter: AnyObject {
    func showProfileViewController(user: User)
}

final class FollowersFollowingRouter {
    private weak var viewController: FollowersFollowingViewController?
    
    init(viewController: FollowersFollowingViewController) {
        self.viewController = viewController
    }
}

// MARK: - IFollowersFollowingRouter

extension FollowersFollowingRouter: IFollowersFollowingRouter {
    func showProfileViewController(user: User) {
        let profileViewController = ProfileAssembly.createProfileViewController(user: user)
        
        viewController?.navigationController?.pushViewController(profileViewController, animated: true)
    }
}

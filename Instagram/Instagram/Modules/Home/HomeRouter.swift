//
//  HomeRouter.swift
//  Instagram
//
//  Created by Admin on 14.01.2021.
//

protocol IHomeRouter: AnyObject {
    func showProfileViewController(user: User)
}

final class HomeRouter {
    private weak var viewController: HomeViewController?
    
    init(viewController: HomeViewController) {
        self.viewController = viewController
    }
}

// MARK: - IHomeRouter

extension HomeRouter: IHomeRouter {
    func showProfileViewController(user: User) {
        let profileViewController = ProfileAssembly.createProfileViewController(user: user)
        
        viewController?.navigationController?.pushViewController(profileViewController, animated: true)
    }
}

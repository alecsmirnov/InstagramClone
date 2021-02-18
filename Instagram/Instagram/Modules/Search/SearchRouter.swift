//
//  SearchRouter.swift
//  Instagram
//
//  Created by Admin on 15.02.2021.
//

protocol ISearchRouter: AnyObject {
    func showProfileViewController(user: User)
}

final class SearchRouter {
    private weak var viewController: SearchViewController?
    
    init(viewController: SearchViewController) {
        self.viewController = viewController
    }
}

// MARK: - ISearchRouter

extension SearchRouter: ISearchRouter {
    func showProfileViewController(user: User) {
        let profileViewController = ProfileAssembly.createProfileViewController(user: user)
        
        viewController?.navigationController?.pushViewController(profileViewController, animated: true)
    }
}

//
//  CommentsRouter.swift
//  Instagram
//
//  Created by Admin on 26.02.2021.
//

protocol ICommentsRouter: AnyObject {
    func showProfileViewController(user: User)
}

final class CommentsRouter {
    private weak var viewController: CommentsViewController?
    
    init(viewController: CommentsViewController) {
        self.viewController = viewController
    }
}

// MARK: - ICommentsRouter

extension CommentsRouter: ICommentsRouter {
    func showProfileViewController(user: User) {
        let profileViewController = ProfileAssembly.createProfileViewController(user: user)
        
        viewController?.navigationController?.pushViewController(profileViewController, animated: true)
    }
}

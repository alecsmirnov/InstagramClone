//
//  CommentsRouter.swift
//  Instagram
//
//  Created by Admin on 26.02.2021.
//

protocol ICommentsRouter: AnyObject {
}

final class CommentsRouter {
    private weak var viewController: CommentsViewController?
    
    init(viewController: CommentsViewController) {
        self.viewController = viewController
    }
}

// MARK: - ICommentsRouter

extension CommentsRouter: ICommentsRouter {

}

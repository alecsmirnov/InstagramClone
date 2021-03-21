//
//  CommentsAssembly.swift
//  Instagram
//
//  Created by Admin on 26.02.2021.
//

enum CommentsAssembly {
    static func createCommentsViewController(
        userPost: UserPost,
        coordinator: CommentsCoordinatorProtocol? = nil
    ) -> CommentsViewController {
        let viewController = CommentsViewController()
        let presenter = CommentsPresenter()
        
        viewController.output = presenter
        presenter.view = viewController
        presenter.coordinator = coordinator
        
        presenter.commentsService = CommentsService()
        
        presenter.userPost = userPost
        
        return viewController
    }
}

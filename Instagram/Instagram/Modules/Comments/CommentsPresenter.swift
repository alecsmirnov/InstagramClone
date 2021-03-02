//
//  CommentsPresenter.swift
//  Instagram
//
//  Created by Admin on 26.02.2021.
//

protocol ICommentsPresenter: AnyObject {
    func viewDidLoad()
    
    func didRequestUserComments()
    
    func didPressSendButton(commentText: String)
}

final class CommentsPresenter {
    // MARK: Properties
    
    weak var viewController: ICommentsViewController?
    var interactor: ICommentsInteractor?
    var router: ICommentsRouter?
    
    var userPost: UserPost?
}

// MARK: - ICommentsPresenter

extension CommentsPresenter: ICommentsPresenter {
    func viewDidLoad() {
        if let postOwnerComment = userPost?.userComment {
            viewController?.appendUserComment(postOwnerComment)
            viewController?.reloadData()
        }
        
        if let userPost = userPost {
            interactor?.fetchUserComments(userPost: userPost)
        }
    }
    
    func didRequestUserComments() {
        guard let userPost = userPost else { return }
        
        interactor?.requestUserComments(userPost: userPost)
    }
    
    func didPressSendButton(commentText: String) {
        guard let userPost = userPost else { return }
        
        interactor?.sendComment(userPost: userPost, text: commentText)
    }
}

// MARK: - ICommentsInteractorOutput

extension CommentsPresenter: ICommentsInteractorOutput {
    func sendCommentSuccess() {
        guard let userPost = userPost else { return }
        
        interactor?.fetchSentUserComment(userPost: userPost)
    }
    
    func sendCommentFailure() {
        
    }
    
    func fetchUserCommentsSuccess(_ userComments: [UserComment]) {
        userComments.forEach { userComment in
            viewController?.appendUserComment(userComment)
            viewController?.insertNewRow()
        }
    }
    
    func fetchUserCommentsFailure() {
        
    }
}

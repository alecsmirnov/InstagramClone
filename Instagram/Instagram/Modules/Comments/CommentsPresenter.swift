//
//  CommentsPresenter.swift
//  Instagram
//
//  Created by Admin on 26.02.2021.
//

protocol ICommentsPresenter: AnyObject {
    func viewDidLoad()
    
    func didPressSendButton(commentText: String)
}

final class CommentsPresenter {
    weak var viewController: ICommentsViewController?
    var interactor: ICommentsInteractor?
    var router: ICommentsRouter?
    
    var postOwnerComment: UserComment?
    
    var postOwnerIdentifier: String? {
        return postOwnerComment?.user.identifier
    }
    
    var postIdentifier: String? {
        return postOwnerComment?.comment.postIdentifier
    }
}

// MARK: - ICommentsPresenter

extension CommentsPresenter: ICommentsPresenter {
    func viewDidLoad() {
        guard
            let postOwnerComment = postOwnerComment,
            let postOwnerIdentifier = postOwnerIdentifier,
            let postIdentifier = postIdentifier
        else {
            return
        }
        
        viewController?.appendUserComment(postOwnerComment)
        viewController?.reloadData()
        
        interactor?.observeUsersComments(postOwnerIdentifier: postOwnerIdentifier, postIdentifier: postIdentifier)
    }
    
    func didPressSendButton(commentText: String) {
        guard
            let postOwnerIdentifier = postOwnerIdentifier,
            let postIdentifier = postIdentifier
        else {
            return
        }
        
        interactor?.sendComment(
            postOwnerIdentifier: postOwnerIdentifier,
            postIdentifier: postIdentifier,
            text: commentText)
    }
}

// MARK: - ICommentsInteractorOutput

extension CommentsPresenter: ICommentsInteractorOutput {
    func sendCommentSuccess() {
        
    }
    
    func sendCommentFailure() {
        
    }
    
    func fetchUserCommentSuccess(_ userComment: UserComment) {
        viewController?.appendUserComment(userComment)
        viewController?.reloadData()
    }
    
    func fetchUserCommentFailure() {
        
    }
}

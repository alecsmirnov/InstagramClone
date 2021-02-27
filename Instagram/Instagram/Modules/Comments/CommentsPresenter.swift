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
    // MARK: Properties
    
    weak var viewController: ICommentsViewController?
    var interactor: ICommentsInteractor?
    var router: ICommentsRouter?
    
    var userPost: UserPost?
    
    var postOwnerComment: UserComment? {
        guard
            let user = userPost?.user,
            let comment = userPost?.comment
        else {
            return nil
        }
        
        let userComment = UserComment(user: user, comment: comment)
        
        return userComment
    }
    
    // MARK: Initialization
    
    deinit {
        interactor?.removeObserver()
    }
}

// MARK: - ICommentsPresenter

extension CommentsPresenter: ICommentsPresenter {
    func viewDidLoad() {
        if let postOwnerComment = postOwnerComment {
            viewController?.appendUserComment(postOwnerComment)
            viewController?.reloadData()
        }
        
        guard
            let postOwnerIdentifier = userPost?.postOwnerIdentifier,
            let postIdentifier = userPost?.postIdentifier
        else {
            return
        }
        
        interactor?.observeUsersComments(postOwnerIdentifier: postOwnerIdentifier, postIdentifier: postIdentifier)
    }
    
    func didPressSendButton(commentText: String) {
        guard
            let postOwnerIdentifier = userPost?.postOwnerIdentifier,
            let postIdentifier = userPost?.postIdentifier
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

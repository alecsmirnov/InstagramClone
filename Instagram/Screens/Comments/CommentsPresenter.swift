//
//  CommentsPresenter.swift
//  Instagram
//
//  Created by Admin on 26.02.2021.
//

final class CommentsPresenter {
    weak var view: CommentsViewControllerProtocol?
    weak var coordinator: CommentsCoordinatorProtocol?
    
    var commentsService: CommentsServiceProtocol?
    
    var userPost: UserPost?
}

// MARK: - CommentsView Output

extension CommentsPresenter: CommentsViewControllerOutputProtocol {
    func viewDidLoad() {
        if let postOwnerComment = userPost?.userComment {
            appendUserComment(postOwnerComment)
        }
        
        if let userPost = userPost {
            commentsService?.fetchUserComments(userPost: userPost) { [weak self] userComments in
                self?.appendUserComments(userComments)
            }
        }
    }
    
    func didRequestUserComments() {
        guard let userPost = userPost else { return }
        
        commentsService?.requestUserComments(userPost: userPost) { [weak self] userComments in
            self?.appendUserComments(userComments)
        }
    }
    
    func didSelectUser(_ user: User) {
        coordinator?.showProfileViewController(user: user)
    }
    
    func didTapSendButton(withText text: String) {
        guard let userPost = userPost else { return }
        
        commentsService?.sendComment(userPost: userPost, text: text) { [weak self] in
            self?.commentsService?.fetchSentUserComment(userPost: userPost) { userComment in
                self?.appendUserComment(userComment)
            }
        }
    }
}

// MARK: - Private Methods

extension CommentsPresenter {
    func appendUserComment(_ userComment: UserComment) {
        view?.appendUsersComments([userComment])
        view?.insertNewRows(count: 1)
    }
    
    func appendUserComments(_ userComments: [UserComment]) {
        view?.appendUsersComments(userComments)
        view?.insertNewRows(count: userComments.count)
    }
}

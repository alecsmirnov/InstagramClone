//
//  CommentsInteractor.swift
//  Instagram
//
//  Created by Admin on 26.02.2021.
//

protocol ICommentsInteractor: AnyObject {
    func sendComment(postOwnerIdentifier: String, postIdentifier: String, text: String)
    
    func observeUsersComments(postOwnerIdentifier: String, postIdentifier: String)
    func removeObserver()
}

protocol ICommentsInteractorOutput: AnyObject {
    func sendCommentSuccess()
    func sendCommentFailure()
    
    func fetchUserCommentSuccess(_ userComment: UserComment)
    func fetchUserCommentFailure()
}

final class CommentsInteractor {
    weak var presenter: ICommentsInteractorOutput?
    
    private var usersCommentsObserver: FirebaseObserver?
}

// MARK: - ICommentsInteractor

extension CommentsInteractor: ICommentsInteractor {
    func sendComment(postOwnerIdentifier: String, postIdentifier: String, text: String) {
        guard let senderIdentifier = FirebaseAuthService.currentUserIdentifier else { return }
        
        FirebasePostService.sendComment(
            postOwnerIdentifier: postOwnerIdentifier,
            postIdentifier: postIdentifier,
            senderIdentifier: senderIdentifier,
            text: text) { [self] error in
            if let error = error {
                presenter?.sendCommentFailure()
                
                print("Failed to send comment: \(error.localizedDescription)")
            } else {
                presenter?.sendCommentSuccess()
                
                print("Comment successfully sent")
            }
        }
    }
    
    func observeUsersComments(postOwnerIdentifier: String, postIdentifier: String) {
        usersCommentsObserver = FirebasePostService.observeComments(
            postOwnerIdentifier: postOwnerIdentifier,
            postIdentifier: postIdentifier) { [self] result in
            switch result {
            case .success(let comment):
                FirebaseUserService.fetchUser(withIdentifier: comment.senderIdentifier) { result in
                    switch result {
                    case .success(let user):
                        let userComment = UserComment(user: user, comment: comment)
                        
                        presenter?.fetchUserCommentSuccess(userComment)
                    case .failure(let error):
                        presenter?.fetchUserCommentFailure()
                        
                        print("Failed to fetch comment owner: \(error.localizedDescription)")
                    }
                }
            case .failure(let error):
                presenter?.fetchUserCommentFailure()
                
                print("Failed to fetch user comment: \(error.localizedDescription)")
            }
        }
    }
    
    func removeObserver() {
        usersCommentsObserver?.remove()
        usersCommentsObserver = nil
    }
}

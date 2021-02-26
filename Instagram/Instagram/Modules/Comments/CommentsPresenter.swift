//
//  CommentsPresenter.swift
//  Instagram
//
//  Created by Admin on 26.02.2021.
//

protocol ICommentsPresenter: AnyObject {

}

final class CommentsPresenter {
    weak var viewController: ICommentsViewController?
    var interactor: ICommentsInteractor?
    var router: ICommentsRouter?
}

// MARK: - ICommentsPresenter

extension CommentsPresenter: ICommentsPresenter {

}

// MARK: - ICommentsInteractorOutput

extension CommentsPresenter: ICommentsInteractorOutput {
    
}

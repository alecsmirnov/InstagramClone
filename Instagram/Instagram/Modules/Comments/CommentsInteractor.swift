//
//  CommentsInteractor.swift
//  Instagram
//
//  Created by Admin on 26.02.2021.
//

protocol ICommentsInteractor: AnyObject {
    
}

protocol ICommentsInteractorOutput: AnyObject {
    
}

final class CommentsInteractor {
    weak var presenter: ICommentsInteractorOutput?
}

// MARK: - ICommentsInteractor

extension CommentsInteractor: ICommentsInteractor {
    
}

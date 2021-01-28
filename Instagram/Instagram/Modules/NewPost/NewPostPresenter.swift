//
//  NewPostPresenter.swift
//  Instagram
//
//  Created by Admin on 28.01.2021.
//

protocol INewPostPresenter: AnyObject {
    
}

final class NewPostPresenter {
    weak var viewController: INewPostViewController?
    var interactor: INewPostInteractor?
    var router: INewPostRouter?
}

// MARK: - INewPostPresenter

extension NewPostPresenter: INewPostPresenter {
    
}

// MARK: - INewPostInteractorOutput

extension NewPostPresenter: INewPostInteractorOutput {
    
}

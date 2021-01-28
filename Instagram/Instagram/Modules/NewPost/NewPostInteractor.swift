//
//  NewPostInteractor.swift
//  Instagram
//
//  Created by Admin on 28.01.2021.
//

protocol INewPostInteractor: AnyObject {
    
}

protocol INewPostInteractorOutput: AnyObject {

}

final class NewPostInteractor {
    weak var presenter: INewPostInteractorOutput?
}

// MARK: - INewPostInteractor

extension NewPostInteractor: INewPostInteractor {
    
}

//
//  HomePresenter.swift
//  Instagram
//
//  Created by Admin on 14.01.2021.
//

protocol IHomePresenter: AnyObject {
    
}

final class HomePresenter {
    weak var viewController: IHomeViewController?
    var interactor: IHomeInteractor?
    var router: IHomeRouter?
}

// MARK: - IHomePresenter

extension HomePresenter: IHomePresenter {
    
}

// MARK: - IHomeInteractorOutput

extension HomePresenter: IHomeInteractorOutput {
    
}

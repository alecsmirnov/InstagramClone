//
//  HomePresenter.swift
//  Instagram
//
//  Created by Admin on 14.01.2021.
//

protocol IHomePresenter: AnyObject {
    func viewDidLoad()
}

final class HomePresenter {
    weak var viewController: IHomeViewController?
    var interactor: IHomeInteractor?
    var router: IHomeRouter?
}

// MARK: - IHomePresenter

extension HomePresenter: IHomePresenter {
    func viewDidLoad() {
        interactor?.fetchUserPosts()
    }
}

// MARK: - IHomeInteractorOutput

extension HomePresenter: IHomeInteractorOutput {
    func fetchUserPostSuccess(_ userPost: UserPost) {
        viewController?.appendUserPost(userPost)
    }
    
    func fetchUserPostFailure() {
        
    }
}

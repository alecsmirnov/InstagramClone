//
//  HomePresenter.swift
//  Instagram
//
//  Created by Admin on 14.01.2021.
//

protocol IHomePresenter: AnyObject {
    func viewDidLoad()
    
    func didPullToRefresh()
    func didSelectUser(_ user: User)
    func didPressLikeButton(_ userPost: UserPost)
    func didSelectUserPostComment(_ userPost: UserPost)
}

final class HomePresenter {
    // MARK: Properties
    
    weak var viewController: IHomeViewController?
    var interactor: IHomeInteractor?
    var router: IHomeRouter?
    
    private var isRefreshed = false
    
    // MARK: Initialization
    
    deinit {
        interactor?.removeAllObservers()
    }
}

// MARK: - IHomePresenter

extension HomePresenter: IHomePresenter {
    func viewDidLoad() {
        interactor?.observeUserPosts()
    }
    
    func didPullToRefresh() {
        interactor?.reloadAllObservers()
        
        isRefreshed = true
    }
    
    func didSelectUser(_ user: User) {
        router?.showProfileViewController(user: user)
    }
    
    func didPressLikeButton(_ userPost: UserPost) {
        interactor?.likePose(userPost)
    }
    
    func didSelectUserPostComment(_ userPost: UserPost) {
        router?.showCommentsViewController(userPost: userPost)
    }
}

// MARK: - IHomeInteractorOutput

extension HomePresenter: IHomeInteractorOutput {
    func fetchUserPostSuccess(_ userPost: UserPost) {
        if isRefreshed {
            isRefreshed = false
            
            viewController?.endRefreshing()
            viewController?.removeAllUserPosts()
        }
        
        viewController?.appendUserPost(userPost)
        viewController?.reloadData()
    }
    
    func fetchUserPostNoResult() {
        isRefreshed = false
        
        viewController?.endRefreshing()
    }
    
    func fetchUserPostFailure() {
        fetchUserPostNoResult()
    }
}

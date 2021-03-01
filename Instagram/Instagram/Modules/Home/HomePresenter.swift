//
//  HomePresenter.swift
//  Instagram
//
//  Created by Admin on 14.01.2021.
//

protocol IHomePresenter: AnyObject {
    func viewDidLoad()
    
    func didPullToRefresh()
    func didRequestPosts()
    
    func didSelectUser(_ user: User)
    func didPressLikeButton(at index: Int, userPost: UserPost)
    func didPressUnlikeButton(at index: Int, userPost: UserPost)
    func didSelectUserPostComment(_ userPost: UserPost)
}

final class HomePresenter {
    // MARK: Properties
    
    weak var viewController: IHomeViewController?
    var interactor: IHomeInteractor?
    var router: IHomeRouter?
    
    private var isRefreshing = false
    
    // MARK: Initialization
    
    deinit {
        interactor?.removeAllObservers()
    }
}

// MARK: - IHomePresenter

extension HomePresenter: IHomePresenter {
    func viewDidLoad() {
        interactor?.fetchUserPosts()
    }
    
    func didPullToRefresh() {
        isRefreshing = true
        
        interactor?.fetchUserPosts()
    }
    
    func didRequestPosts() {
        interactor?.requestUserPosts()
    }
    
    func didSelectUser(_ user: User) {
        router?.showProfileViewController(user: user)
    }
    
    func didPressLikeButton(at index: Int, userPost: UserPost) {
        interactor?.likePost(userPost, at: index)
    }
    
    func didPressUnlikeButton(at index: Int, userPost: UserPost) {
        interactor?.unlikePost(userPost, at: index)
    }
    
    func didSelectUserPostComment(_ userPost: UserPost) {
        router?.showCommentsViewController(userPost: userPost)
    }
}

// MARK: - IHomeInteractorOutput

extension HomePresenter: IHomeInteractorOutput {
    func fetchUserPostSuccess(_ userPost: UserPost) {
        if isRefreshing {
            isRefreshing = false

            viewController?.endRefreshing()
            viewController?.removeAllUserPosts()
            viewController?.reloadData()
        }
        
        viewController?.appendUserPost(userPost)
        viewController?.insertNewRow()
    }
    
    func fetchUserPostNoResult() {
        isRefreshing = false
        
        viewController?.endRefreshing()
    }
    
    func fetchUserPostFailure() {
        fetchUserPostNoResult()
    }
    
    func likePostSuccess(at index: Int) {
        viewController?.showUnlikeButton(at: index)
    }
    
    func likePostFailure(at index: Int) {
        
    }
    
    func unlikePostSuccess(at index: Int) {
        viewController?.showLikeButton(at: index)
    }
    
    func unlikePostFailure(at index: Int) {
        
    }
}

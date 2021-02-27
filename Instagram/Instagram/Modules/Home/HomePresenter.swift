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
    
    // TODO: For test. REMOVE
    private var isLiked = true
    
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
        if isLiked {
            interactor?.unlikePost(userPost)
        } else {
            interactor?.likePost(userPost)
        }
        
        isLiked.toggle()
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

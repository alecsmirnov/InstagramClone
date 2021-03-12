//
//  HomePresenter.swift
//  Instagram
//
//  Created by Admin on 14.01.2021.
//

protocol IHomePresenter: AnyObject {
    func viewDidLoad()
    
    func didPressCloseButton()
    
    func didPullToRefresh()
    func didRequestPosts()
    
    func didSelectUser(_ user: User)
    func didPressLikeButton(at index: Int, userPost: UserPost)
    func didPressUnlikeButton(at index: Int, userPost: UserPost)
    func didSelectUserPostComment(_ userPost: UserPost)
    func didPressAddToBookmarksButton(at index: Int, userPost: UserPost)
    func didPressRemoveFromBookmarksButton(at index: Int, userPost: UserPost)
}

final class HomePresenter {
    // MARK: Properties
    
    weak var viewController: IHomeViewController?
    var interactor: IHomeInteractor?
    var router: IHomeRouter?
    
    private var isRefreshing = false
    
    weak var coordinator: HomeCoordinatorProtocol?
    
    // MARK: Initialization
    
    deinit {
        interactor?.removeUserFeedObserver()
    }
}

// MARK: - IHomePresenter

extension HomePresenter: IHomePresenter {
    func viewDidLoad() {
        interactor?.fetchUserPosts()
        interactor?.observeUserFeed()
    }
    
    func didPressCloseButton() {
        coordinator?.closeTabBarController()
    }
    
    func didPullToRefresh() {
        isRefreshing = true
        
        interactor?.fetchUserPosts()
        interactor?.observeUserFeed()
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
    
    func didPressAddToBookmarksButton(at index: Int, userPost: UserPost) {
        interactor?.addPostToBookmarks(userPost, at: index)
    }
    
    func didPressRemoveFromBookmarksButton(at index: Int, userPost: UserPost) {
        interactor?.removePostFromBookmarks(userPost, at: index)
    }
}

// MARK: - IHomeInteractorOutput

extension HomePresenter: IHomeInteractorOutput {
    func fetchUserPostSuccess(_ userPosts: [UserPost]) {
        if isRefreshing {
            isRefreshing = false

            viewController?.endRefreshing()
            viewController?.removeAllUserPosts()
            viewController?.reloadData()
        }
        
        userPosts.reversed().forEach { userPost in
            viewController?.appendLastUserPost(userPost)
            viewController?.insertLastRow()
        }
    }
    
    func fetchUserPostNoResult() {
        isRefreshing = false
        
        viewController?.endRefreshing()
    }
    
    func fetchUserPostFailure() {
        fetchUserPostNoResult()
    }
    
    func observeUserFeedSuccess(_ userPost: UserPost) {
        viewController?.appendFirstUserPost(userPost)
        viewController?.insertFirstRow()
    }
    
    func observeUserFeedFailure() {
        
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
    
    func addPostToBookmarksSuccess(at index: Int) {
        viewController?.showBookmarkButton(at: index)
    }
    
    func addPostToBookmarksFailure(at index: Int) {
        
    }
    
    func removePostFromBookmarksSuccess(at index: Int) {
        viewController?.showNotBookmarkButton(at: index)
    }
    
    func removePostFromBookmarksFailure(at index: Int) {
        
    }
}

//
//  HomePresenter.swift
//  Instagram
//
//  Created by Admin on 14.01.2021.
//

final class HomePresenter {
    weak var view: HomeViewControllerProtocol?
    weak var coordinator: HomeCoordinatorProtocol?
    
    var feedService: FeedServiceProtocol?
}

// MARK: - HomeView Output

extension HomePresenter: HomeViewControllerOutputProtocol {
    func viewDidLoad() {
        feedService?.fetchUserPostsDescendingByDate() { [weak self] userPosts in
            guard !userPosts.isEmpty else { return }
            
            self?.appendUserPosts(userPosts)
        }
        
        observeUserFeed()
    }
    
    func didPullToRefresh() {
        feedService?.fetchUserPostsDescendingByDate() { [weak self] userPosts in
            self?.view?.endRefreshing()
            self?.view?.removeAllUserPosts()
            self?.view?.reloadData()
            
            if !userPosts.isEmpty {
                self?.appendUserPosts(userPosts)
            }
        }
        
        observeUserFeed()
    }
    
    func didRequestPosts() {
        feedService?.requestUserPosts() { [weak self] userPosts in
            self?.appendUserPosts(userPosts)
        }
    }
    
    func didSelectUser(_ user: User) {
        coordinator?.showProfileViewController(user: user)
    }
    
    func didTapLikeButton(at index: Int, userPost: UserPost) {
        feedService?.likePost(userPost, at: index) { [weak self] in
            self?.view?.showUnlikeButton(at: index)
        }
    }
    
    func didTapUnlikeButton(at index: Int, userPost: UserPost) {
        feedService?.unlikePost(userPost, at: index) { [weak self] in
            self?.view?.showLikeButton(at: index)
        }
    }
    
    func didTapCommentButton(userPost: UserPost) {
        coordinator?.showCommentsViewController(userPost: userPost)
    }
    
    func didTapAddToBookmarksButton(at index: Int, userPost: UserPost) {
        feedService?.addPostToBookmarks(userPost, at: index) { [weak self] in
            self?.view?.showBookmarkButton(at: index)
        }
    }
    
    func didTapRemoveFromBookmarksButton(at index: Int, userPost: UserPost) {
        feedService?.removePostFromBookmarks(userPost, at: index) { [weak self] in
            self?.view?.showNotBookmarkButton(at: index)
        }
    }
}

// MARK: - Private Methods

private extension HomePresenter {
    func appendUserPosts(_ userPosts: [UserPost]) {
        view?.appendUsersPosts(userPosts.reversed())
        view?.insertNewRows(count: userPosts.count)
    }
    
    func observeUserFeed() {
        feedService?.observeUserFeed() { [weak self] userPost in
            self?.view?.appendFirstUserPost(userPost)
            self?.view?.insertFirstRow()
        }
    }
}

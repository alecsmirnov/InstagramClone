//
//  HomeViewController.swift
//  Instagram
//
//  Created by Admin on 14.01.2021.
//

import UIKit

protocol HomeViewControllerProtocol: AnyObject {
    func appendFirstUserPost(_ userPost: UserPost)
    func appendUsersPosts(_ usersPosts: [UserPost])
    func removeAllUserPosts()
    
    func insertFirstRow()
    func insertNewRows(count: Int)
    func reloadData()
    func endRefreshing()
    
    func showLikeButton(at index: Int)
    func showUnlikeButton(at index: Int)
    
    func showNotBookmarkButton(at index: Int)
    func showBookmarkButton(at index: Int)
}

protocol HomeViewControllerOutputProtocol: AnyObject {
    func viewDidLoad()
    
    func didPullToRefresh()
    func didRequestPosts()
    
    func didSelectUser(_ user: User)
    func didTapLikeButton(at index: Int, userPost: UserPost)
    func didTapUnlikeButton(at index: Int, userPost: UserPost)
    func didTapCommentButton(userPost: UserPost)
    func didTapAddToBookmarksButton(at index: Int, userPost: UserPost)
    func didTapRemoveFromBookmarksButton(at index: Int, userPost: UserPost)
}

final class HomeViewController: CustomViewController<HomeView> {
    // MARK: Properties
    
    var output: HomeViewControllerOutputProtocol?
    
    // MARK: Constants
    
    private enum Images {
        static let logo = AppConstants.Images.logoMini
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customView?.output = self
        
        setupNavigationItemTitle()
        
        output?.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.titleView?.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationItem.titleView?.isHidden = true
    }
}

// MARK: - HomeViewController Interface

extension HomeViewController: HomeViewControllerProtocol {
    func appendFirstUserPost(_ userPost: UserPost) {
        customView?.appendFirstUserPost(userPost)
    }
    
    func appendUsersPosts(_ usersPosts: [UserPost]) {
        customView?.appendUsersPosts(usersPosts)
    }
    
    func insertFirstRow() {
        customView?.insertFirstRow()
    }
    
    func insertNewRows(count: Int) {
        customView?.insertNewRows(count: count)
    }
    
    func removeAllUserPosts() {
        customView?.removeAllUserPosts()
    }
    
    func reloadData() {
        customView?.reloadData()
    }
    
    func endRefreshing() {
        customView?.endRefreshing()
    }
    
    func showLikeButton(at index: Int) {
        customView?.showLikeButton(at: index)
    }
    
    func showUnlikeButton(at index: Int) {
        customView?.showUnlikeButton(at: index)
    }
    
    func showNotBookmarkButton(at index: Int) {
        customView?.showNotBookmarkButton(at: index)
    }
    
    func showBookmarkButton(at index: Int) {
        customView?.showBookmarkButton(at: index)
    }
}

// MARK: - HomeView Output

extension HomeViewController: HomeViewOutputProtocol {
    func didPullToRefresh() {
        output?.didPullToRefresh()
    }
    
    func didRequestPosts() {
        output?.didRequestPosts()
    }
    
    func didSelectUser(_ user: User) {
        output?.didSelectUser(user)
    }
    
    func didTapLikeButton(at index: Int, userPost: UserPost) {
        output?.didTapLikeButton(at: index, userPost: userPost)
    }
    
    func didTapUnlikeButton(at index: Int, userPost: UserPost) {
        output?.didTapUnlikeButton(at: index, userPost: userPost)
    }
    
    func didTapCommentButton(userPost: UserPost) {
        output?.didTapCommentButton(userPost: userPost)
    }
    
    func didTapAddToBookmarksButton(at index: Int, userPost: UserPost) {
        output?.didTapAddToBookmarksButton(at: index, userPost: userPost)
    }
    
    func didTapRemoveFromBookmarksButton(at index: Int, userPost: UserPost) {
        output?.didTapRemoveFromBookmarksButton(at: index, userPost: userPost)
    }
}

// MARK: - Appearance

private extension HomeViewController {
    func setupNavigationItemTitle() {
        navigationItem.titleView = UIImageView(image: Images.logo)
    }
}

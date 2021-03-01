//
//  HomeViewController.swift
//  Instagram
//
//  Created by Admin on 14.01.2021.
//

import UIKit

protocol IHomeViewController: AnyObject {
    func appendFirstUserPost(_ userPost: UserPost)
    func appendLastUserPost(_ userPost: UserPost)
    func removeAllUserPosts()
    
    func insertFirstRow()
    func insertLastRow()
    func reloadData()
    
    func endRefreshing()
    
    func showLikeButton(at index: Int)
    func showUnlikeButton(at index: Int)
}

final class HomeViewController: CustomViewController<HomeView> {
    // MARK: Properties
    
    var presenter: IHomePresenter?
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customView?.delegate = self
        
        presenter?.viewDidLoad()
        
        setupNavigationItemTitle()
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

// MARK: - IHomeViewController

extension HomeViewController: IHomeViewController {    
    func appendFirstUserPost(_ userPost: UserPost) {
        customView?.appendFirstUserPost(userPost)
    }
    
    func appendLastUserPost(_ userPost: UserPost) {
        customView?.appendLastUserPost(userPost)
    }
    
    func insertFirstRow() {
        customView?.insertFirstRow()
    }
    
    func insertLastRow() {
        customView?.insertLastRow()
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
}

// MARK: - Appearance

private extension HomeViewController {
    func setupNavigationItemTitle() {
        navigationItem.titleView = UIImageView(image: UIImage(named: "instagram_logo_black_mini"))
    }
}

// MARK: - HomeViewDelegate

extension HomeViewController: HomeViewDelegate {
    func homeViewDidPullToRefresh(_ homeView: HomeView) {
        presenter?.didPullToRefresh()
    }
    
    func homeViewDidRequestPosts(_ homeView: HomeView) {
        presenter?.didRequestPosts()
    }
    
    func homeView(_ homeView: HomeView, didSelectUser user: User) {
        presenter?.didSelectUser(user)
    }
    
    func homeView(_ homeView: HomeView, didPressLikeButtonAt index: Int, userPost: UserPost) {
        presenter?.didPressLikeButton(at: index, userPost: userPost)
    }
    
    func homeView(_ homeView: HomeView, didPressUnlikeButtonAt index: Int, userPost: UserPost) {
        presenter?.didPressUnlikeButton(at: index, userPost: userPost)
    }
    
    func homeView(_ homeView: HomeView, didPressCommentButton userPost: UserPost) {
        presenter?.didSelectUserPostComment(userPost)
    }
}

//
//  HomeViewController.swift
//  Instagram
//
//  Created by Admin on 14.01.2021.
//

import UIKit

protocol IHomeViewController: AnyObject {
    func appendUserPost(_ userPost: UserPost)
    func removeAllUserPosts()
    
    func reloadData()
    
    func endRefreshing()
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
    func appendUserPost(_ userPost: UserPost) {
        customView?.appendUserPost(userPost)
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
    
    func homeView(_ homeView: HomeView, didSelectUser user: User) {
        presenter?.didSelectUser(user)
    }
    
    func homeView(_ homeView: HomeView, didSelectUserPostComment userPost: UserPost) {
        presenter?.didSelectUserPostComment(userPost)
    }
}

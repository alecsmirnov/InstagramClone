//
//  ProfileViewController.swift
//  Instagram
//
//  Created by Admin on 21.01.2021.
//

import UIKit

protocol ProfileViewControllerProtocol: AnyObject {
    func enableMenu()
    
    func setUser(_ user: User)
    func setUserStats(_ userStats: UserStats)
    func appendFirstPost(_ post: Post)
    func appendPosts(_ posts: [Post])
    func removeAllPosts()
    
    func insertNewFirstItem()
    func insertNewLastItems(count: Int)
    func reloadData()
    
    func showEditButton()
    func showFollowButton()
    func showUnfollowButton()
}

protocol ProfileViewControllerOutputProtocol: AnyObject {
    func viewDidLoad()
    
    func didRequestPosts()
    
    func didTapFollowersButton()
    func didTapFollowingButton()
    func didTapEditButton()
    func didTapFollowButton()
    func didTapUnfollowButton()
    func didTapGridButton()
    func didTapBookmarkButton()
    func didSelectPost(_ post: Post)
    
    func didTapMenuButton()
}

final class ProfileViewController: CustomViewController<ProfileView> {
    // MARK: Properties
    
    var output: ProfileViewControllerOutputProtocol?
    
    // MARK: Constants
    
    private enum Images {
        static let menu = UIImage(named: "gear")
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customView?.output = self
        
        setupAppearance()
        
        output?.viewDidLoad()
    }
}

// MARK: - ProfileViewController Interface

extension ProfileViewController: ProfileViewControllerProtocol {
    func enableMenu() {
        setupMenuButton()
    }
    
    func setUser(_ user: User) {
        navigationItem.title = user.username
        
        customView?.setUser(user)
    }
    
    func setUserStats(_ userStats: UserStats) {
        customView?.setUserStats(userStats)
    }
    
    func appendFirstPost(_ post: Post) {
        customView?.appendFirstPost(post)
    }
    
    func appendPosts(_ posts: [Post]) {
        customView?.appendPosts(posts)
    }
    
    func removeAllPosts() {
        customView?.removeAllPosts()
    }
    
    func insertNewFirstItem() {
        customView?.insertNewFirstItem()
    }
    
    func insertNewLastItems(count: Int) {
        customView?.insertNewLastItems(count: count)
    }
    
    func reloadData() {
        customView?.reloadData()
    }
    
    func showEditButton() {
        customView?.showEditButton()
    }
    
    func showFollowButton() {
        customView?.showFollowButton()
    }
    
    func showUnfollowButton() {
        customView?.showUnfollowButton()
    }
}

// MARK: - ProfileView Output

extension ProfileViewController: ProfileViewOutputProtocol {
    func didRequestPosts() {
        output?.didRequestPosts()
    }
    
    func didTapFollowersButton() {
        output?.didTapFollowersButton()
    }
    
    func didTapFollowingButton() {
        output?.didTapFollowingButton()
    }
    
    func didTapEditButton() {
        output?.didTapEditButton()
    }
    
    func didTapFollowButton() {
        output?.didTapFollowButton()
    }
    
    func didTapUnfollowButton() {
        output?.didTapUnfollowButton()
    }
    
    func didTapGridButton() {
        output?.didTapGridButton()
    }
    
    func didTapBookmarkButton() {
        output?.didTapBookmarkButton()
    }
    
    func didSelectPost(_ post: Post) {
        output?.didSelectPost(post)
    }
}

// MARK: - Appearance

private extension ProfileViewController {
    func setupAppearance() {
        customizeBackButton()
    }
    
    func customizeBackButton() {
        let backBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: nil, action: nil)
        backBarButtonItem.tintColor = .black
        
        navigationController?.navigationBar.topItem?.backBarButtonItem = backBarButtonItem
    }
    
    func setupMenuButton() {
        let menuBarButtonItem = UIBarButtonItem(
            image: Images.menu?.withRenderingMode(.alwaysOriginal),
            style: .plain,
            target: self,
            action: #selector(didTapMenuButton))
        
        navigationItem.rightBarButtonItem = menuBarButtonItem
    }
}

// MARK: - Button Actions

private extension ProfileViewController {
    @objc func didTapMenuButton() {
        output?.didTapMenuButton()
    }
}

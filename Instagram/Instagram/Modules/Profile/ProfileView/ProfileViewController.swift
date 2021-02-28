//
//  ProfileViewController.swift
//  Instagram
//
//  Created by Admin on 21.01.2021.
//

import UIKit

protocol IProfileViewController: AnyObject {
    func setUser(_ user: User)
    func setPosts(_ posts: [Post])
    func appendPost(_ post: Post)
    
    func reloadData()
    
    func showEditButton()
    func showFollowButton()
    func showUnfollowButton()
}

final class ProfileViewController: CustomViewController<ProfileView> {
    // MARK: Properties
    
    var presenter: IProfilePresenter?
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customView?.delegate = self
        
        presenter?.viewDidLoad()
        
        setupAppearance()
    }
}

// MARK: - IProfileViewController

extension ProfileViewController: IProfileViewController {
    func setUser(_ user: User) {
        navigationItem.title = user.username
        
        customView?.setUser(user)
    }
    
    func setPosts(_ posts: [Post]) {
        customView?.setPosts(posts)
    }
    
    func appendPost(_ post: Post) {
        customView?.appendPost(post)
    }
    
    func reloadData() {
        customView?.reloadData()
    }
    
    func showEditButton() {
        customView?.editFollowButtonState = .edit
    }
    
    func showFollowButton() {
        customView?.editFollowButtonState = .follow
    }
    
    func showUnfollowButton() {
        customView?.editFollowButtonState = .unfollow
    }
}

// MARK: - Appearance

private extension ProfileViewController {
    func setupAppearance() {
        customizeBackButton()
        setupMenuButton()
    }
    
    func customizeBackButton() {
        let backBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: nil, action: nil)
        
        backBarButtonItem.tintColor = .black
        
        navigationController?.navigationBar.topItem?.backBarButtonItem = backBarButtonItem
    }
    
    func setupMenuButton() {
        let menuBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "xmark.square"),
            style: .plain,
            target: self,
            action: #selector(didPressCloseButton))
        
        navigationItem.rightBarButtonItem = menuBarButtonItem
    }
}

// MARK: - Actions

private extension ProfileViewController {
    @objc func didPressCloseButton() {
        presenter?.didPressMenuButton()
    }
}

// MARK: - ProfileViewDelegate

extension ProfileViewController: ProfileViewDelegate {
    func profileViewDidRequestPost(_ view: ProfileView) {
        presenter?.didRequestPost()
    }
    
    func profileViewDidPressFollowersButton(_ view: ProfileView) {
        
    }
    
    func profileViewDidPressFollowingButton(_ view: ProfileView) {
        
    }
    
    func profileViewDidPressEditButton(_ view: ProfileView) {
        presenter?.didPressEditButton()
    }
    
    func profileViewDidPressFollowButton(_ view: ProfileView) {
        presenter?.didPressFollowButton()
    }
    
    func profileViewDidPressUnfollowButton(_ view: ProfileView) {        
        presenter?.didPressUnfollowButton()
    }
}

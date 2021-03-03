//
//  FollowersFollowingViewController.swift
//  Instagram
//
//  Created by Admin on 03.03.2021.
//

import UIKit

protocol IFollowersFollowingViewController: AnyObject {    
    func showFollowersCount(_ followers: Int)
    func showFollowingCount(_ following: Int)
    
    func appendUser(_ user: User, userState: FollowUnfollowRemoveButtonState)
    func updateUser(at index: Int, userState: FollowUnfollowRemoveButtonState)
    
    func reloadData()
    func reloadRow(at index: Int)
}

final class FollowersFollowingViewController: CustomViewController<FollowersFollowingView> {
    // MARK: Properties
    
    var presenter: IFollowersFollowingPresenter?
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customView?.delegate = self
        
        presenter?.viewDidLoad()
        
        setupAppearance()
    }
}

// MARK: - Appearance

private extension FollowersFollowingViewController {
    func setupAppearance() {
        customizeBackButton()
    }
    
    func customizeBackButton() {
        let backBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: nil, action: nil)
        
        backBarButtonItem.tintColor = .black
        
        navigationController?.navigationBar.topItem?.backBarButtonItem = backBarButtonItem
    }
}

// MARK: - IFollowersFollowingViewController

extension FollowersFollowingViewController: IFollowersFollowingViewController {
    func showFollowersCount(_ followers: Int) {
        navigationItem.title = "\(followers) followers"
    }
    
    func showFollowingCount(_ following: Int) {
        navigationItem.title = "\(following) following"
    }
    
    func appendUser(_ user: User, userState: FollowUnfollowRemoveButtonState) {
        customView?.appendUser(user, userState: userState)
    }
    
    func updateUser(at index: Int, userState: FollowUnfollowRemoveButtonState) {
        customView?.updateUser(at: index, userState: userState)
    }
    
    func reloadData() {
        customView?.reloadData()
    }
    
    func reloadRow(at index: Int) {
        customView?.reloadRow(at: index)
    }
}

// MARK: - FollowersFollowingViewDelegate

extension FollowersFollowingViewController: FollowersFollowingViewDelegate {
    func followersFollowingView(
        _ followersFollowingView: FollowersFollowingView,
        didPressFollowButtonAt index: Int,
        user: User
    ) {
        presenter?.didPressFollowButton(at: index, user: user)
    }
    
    func followersFollowingView(
        _ followersFollowingView: FollowersFollowingView,
        didPressUnfollowButtonAt index: Int,
        user: User
    ) {
        presenter?.didPressUnfollowButton(at: index, user: user)
    }
    
    func followersFollowingView(
        _ followersFollowingView: FollowersFollowingView,
        didPressRemoveButtonAt index: Int,
        user: User
    ) {
        presenter?.didPressRemoveButton(at: index, user: user)
    }
}

//
//  FollowersFollowingViewController.swift
//  Instagram
//
//  Created by Admin on 03.03.2021.
//

import UIKit

protocol IFollowersFollowingViewController: AnyObject {
    func setDisplayMode(_ displayMode: FollowersFollowingDisplayMode, usersCount: Int)
    
    func appendUser(_ user: User, buttonState: FollowUnfollowRemoveButtonState)
    func changeButtonState(_ buttonState: FollowUnfollowRemoveButtonState, at index: Int)
    func removeAllUsers()
    
    func reloadData()
    func endRefreshing()
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
    func setDisplayMode(_ displayMode: FollowersFollowingDisplayMode, usersCount: Int) {
        var titleText: String
        
        switch displayMode {
        case .followers:
            titleText = "followers"
        case .following:
            titleText = "following"
        }
        
        navigationItem.title = "\(usersCount) \(titleText)"
    }
    
    func appendUser(_ user: User, buttonState: FollowUnfollowRemoveButtonState) {
        customView?.appendUser(user, buttonState: buttonState)
    }
    
    func changeButtonState(_ buttonState: FollowUnfollowRemoveButtonState, at index: Int) {
        customView?.changeButtonState(buttonState, at: index)
    }
    
    func removeAllUsers() {
        customView?.removeAllUsers()
    }
    
    func insertNewRow() {
        customView?.insertNewRow()
    }
    
    func reloadData() {
        customView?.reloadData()
    }
    
    func endRefreshing() {
        customView?.endRefreshing()
    }
}

// MARK: - FollowersFollowingViewDelegate

extension FollowersFollowingViewController: FollowersFollowingViewDelegate {
    func followersFollowingViewDidPullToRefresh(_ followersFollowingView: FollowersFollowingView) {
        presenter?.didPullToRefresh()
    }
    
    func followersFollowingViewDidRequestUsers(_ followersFollowingView: FollowersFollowingView) {
        presenter?.didRequestUsers()
    }
    
    func followersFollowingView(_ followersFollowingView: FollowersFollowingView, didSelectUser user: User) {
        presenter?.didSelectUser(user)
    }
    
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

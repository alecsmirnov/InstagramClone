//
//  FollowersFollowingViewController.swift
//  Instagram
//
//  Created by Admin on 03.03.2021.
//

import UIKit

protocol FollowersFollowingViewControllerProtocol: AnyObject {
    func setTitle(text: String, usersCount: Int)

    func setupFollowersAppearance()
    func setupFollowingAppearance()
    func setupUsersAppearance()

    func appendUsers(_ users: [User])
    func removeAllUsers()

    func setupFollowButton(at index: Int)
    func setupUnfollowButton(at index: Int)
    func setupRemoveButton(at index: Int)
    func setupNoButton(at index: Int)

    func insertNewRows(count: Int)
    func reloadData()
    func endRefreshing()
}

protocol FollowersFollowingViewControllerOutputProtocol: AnyObject {
    func viewDidLoad()
    
    func didPullToRefresh()
    func didRequestUsers()
    
    func didSelectUser(_ user: User)
    func didTapFollowButton(at index: Int, for user: User)
    func didTapUnfollowButton(at index: Int, for user: User)
    func didTapRemoveButton(at index: Int, for user: User)
}

final class FollowersFollowingViewController: CustomViewController<FollowersFollowingView> {
    // MARK: Properties
    
    var output: FollowersFollowingViewControllerOutputProtocol?
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customView?.output = self
        
        setupAppearance()
        
        output?.viewDidLoad()
    }
}

// MARK: - FollowersFollowingViewController Interface

extension FollowersFollowingViewController: FollowersFollowingViewControllerProtocol {
    func setTitle(text: String, usersCount: Int) {
        navigationItem.title = "\(usersCount) \(text)"
    }
    
    func setupFollowersAppearance() {
        customView?.setupFollowersAppearance()
    }
    
    func setupFollowingAppearance() {
        customView?.setupFollowingAppearance()
    }
    
    func setupUsersAppearance() {
        customView?.setupUsersAppearance()
    }
    
    func appendUsers(_ users: [User]) {
        customView?.appendUsers(users)
    }
    
    func setupFollowButton(at index: Int) {
        customView?.setupFollowButton(at: index)
    }
    
    func setupUnfollowButton(at index: Int) {
        customView?.setupUnfollowButton(at: index)
    }
    
    func setupRemoveButton(at index: Int) {
        customView?.setupRemoveButton(at: index)
    }
    
    func setupNoButton(at index: Int) {
        customView?.setupNoButton(at: index)
    }
    
    func insertNewRows(count: Int) {
        customView?.insertNewRows(count: count)
    }
    
    func removeAllUsers() {
        customView?.removeAllUsers()
    }
    
    func reloadData() {
        customView?.reloadData()
    }
    
    func endRefreshing() {
        customView?.endRefreshing()
    }
}

// MARK: - FollowersFollowingView Output

extension FollowersFollowingViewController: FollowersFollowingViewOutputProtocol {
    func didPullToRefresh() {
        output?.didPullToRefresh()
    }
    
    func didRequestUsers() {
        output?.didRequestUsers()
    }
    
    func didSelectUser(_ user: User) {
        output?.didSelectUser(user)
    }
    
    func didTapFollowButton(at index: Int, for user: User) {
        output?.didTapFollowButton(at: index, for: user)
    }
    
    func didTapUnfollowButton(at index: Int, for user: User) {
        output?.didTapUnfollowButton(at: index, for: user)
    }
    
    func didTapRemoveButton(at index: Int, for user: User) {
        output?.didTapRemoveButton(at: index, for: user)
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

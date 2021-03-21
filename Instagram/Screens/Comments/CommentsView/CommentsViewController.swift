//
//  CommentsViewController.swift
//  Instagram
//
//  Created by Admin on 26.02.2021.
//

import UIKit

protocol CommentsViewControllerProtocol: AnyObject {
    func appendUsersComments(_ usersComments: [UserComment])
    func insertNewRows(count: Int)
}

protocol CommentsViewControllerOutputProtocol: AnyObject {
    func viewDidLoad()
    
    func didRequestUserComments()
    
    func didSelectUser(_ user: User)
    func didTapSendButton(withText text: String)
}

final class CommentsViewController: CustomViewController<CommentsView> {
    // MARK: Properties
    
    var output: CommentsViewControllerOutputProtocol?
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customView?.output = self
        
        setupAppearance()
        
        output?.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        tabBarController?.tabBar.isHidden = false
    }
}

// MARK: - CommentsViewController Interface

extension CommentsViewController: CommentsViewControllerProtocol {
    func appendUsersComments(_ usersComments: [UserComment]) {
        customView?.appendUsersComments(usersComments)
    }
    
    func insertNewRows(count: Int) {
        customView?.insertNewRows(count: count)
    }
}

// MARK: - CommentsView Output

extension CommentsViewController: CommentsViewOutputProtocol{
    func didRequestUserComments() {
        output?.didRequestUserComments()
    }
    
    func didSelectUser(_ user: User) {
        output?.didSelectUser(user)
    }
    
    func didTapSendButton(withText text: String) {
        output?.didTapSendButton(withText: text)
    }
}

// MARK: - Appearance

private extension CommentsViewController {
    func setupAppearance() {
        navigationItem.title = "Comments"
        
        customizeBackButton()
    }
    
    func customizeBackButton() {
        let backBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: nil, action: nil)
        
        backBarButtonItem.tintColor = .black
        
        navigationController?.navigationBar.topItem?.backBarButtonItem = backBarButtonItem
    }
}

//
//  CommentsViewController.swift
//  Instagram
//
//  Created by Admin on 26.02.2021.
//

import UIKit

protocol ICommentsViewController: AnyObject {
    func appendUserComment(_ userComment: UserComment)
    
    func reloadData()
}

final class CommentsViewController: CustomViewController<CommentsView> {
    // MARK: Properties
    
    var presenter: ICommentsPresenter?
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customView?.delegate = self
        
        presenter?.viewDidLoad()
        
        setupAppearance()
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

// MARK: - ICommentsViewController

extension CommentsViewController: ICommentsViewController {
    func appendUserComment(_ userComment: UserComment) {
        customView?.appendUserComment(userComment)
    }
    
    func reloadData() {
        customView?.reloadData()
    }
}

// MARK: - Appearance

private extension CommentsViewController {
    func setupAppearance() {
        navigationItem.title = "Comments"
        
        customizeBackButton()
        setupSendButton()
    }
    
    func customizeBackButton() {
        let backBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: nil, action: nil)
        
        backBarButtonItem.tintColor = .black
        
        navigationController?.navigationBar.topItem?.backBarButtonItem = backBarButtonItem
    }
    
    func setupSendButton() {
        let sendBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "paperplane")?.withRenderingMode(.alwaysOriginal),
            style: .plain,
            target: self,
            action: nil)
        
        navigationItem.rightBarButtonItem = sendBarButtonItem
    }
}

// MARK: - CommentsViewDelegate

extension CommentsViewController: CommentsViewDelegate {
    func commentsView(_ commentsView: CommentsView, didPressSendButton commentText: String) {
        presenter?.didPressSendButton(commentText: commentText)
    }
}

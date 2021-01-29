//
//  ProfileViewController.swift
//  Instagram
//
//  Created by Admin on 21.01.2021.
//

import UIKit

protocol IProfileViewController: AnyObject {
    func setUser(_ user: User)
}

final class ProfileViewController: CustomViewController<ProfileView> {
    // MARK: Properties
    
    var presenter: IProfilePresenter?
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter?.viewDidLoad()
        
        setupMenuButton()
    }
}

// MARK: - IProfileViewController

extension ProfileViewController: IProfileViewController {
    func setUser(_ user: User) {
        navigationItem.title = user.username
        
        customView?.setUser(user)
    }
}

// MARK: - Appearance

private extension ProfileViewController {
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

//
//  EditProfileUsernameViewController.swift
//  Instagram
//
//  Created by Admin on 07.03.2021.
//

import UIKit

protocol IEditProfileUsernameViewController: AnyObject {
    
}

final class EditProfileUsernameViewController: CustomViewController<EditProfileUsernameView> {
    // MARK: - Properties
    
    var presenter: IEditProfileUsernamePresenter?
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customView?.delegate = self
        
        presenter?.viewDidLoad()
        
        setupAppearance()
    }
}

// MARK: - Appearance

private extension EditProfileUsernameViewController {
    func setupAppearance() {
        navigationItem.title = "Username"
        
        setupCloseButton()
        setupEditButton()
    }
    
    func setupCloseButton() {
        let closeBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "xmark")?.withRenderingMode(.alwaysOriginal),
            style: .plain,
            target: self,
            action: #selector(didPressCloseButton))

        navigationItem.leftBarButtonItem = closeBarButtonItem
    }
    
    @objc func didPressCloseButton() {
        presenter?.didPressCloseButton()
    }
    
    func setupEditButton() {
        let editBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "checkmark"),
            style: .plain,
            target: self,
            action: #selector(didPressEditButton))

        navigationItem.rightBarButtonItem = editBarButtonItem
    }
    
    @objc func didPressEditButton() {
        presenter?.didPressEditButton()
    }
}

// MARK: - IEditProfileUsernameViewController

extension EditProfileUsernameViewController: IEditProfileUsernameViewController {
    
}

// MARK: - EditProfileUsernameViewDelegate

extension EditProfileUsernameViewController: EditProfileUsernameViewDelegate {
    func editProfileUsernameView(
        _ editProfileUsernameView: EditProfileUsernameView,
        usernameDidChange username: String?
    ) {
        
    }
    
    func editProfileUsernameViewEnableEditButton(_ editProfileUsernameView: EditProfileUsernameView) {
        navigationItem.rightBarButtonItem?.isEnabled = true
    }
    
    func editProfileUsernameViewDisableEditButton(_ editProfileUsernameView: EditProfileUsernameView) {
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
}

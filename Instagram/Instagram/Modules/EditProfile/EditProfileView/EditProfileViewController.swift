//
//  EditProfileViewController.swift
//  Instagram
//
//  Created by Admin on 06.03.2021.
//

import UIKit

protocol IEditProfileViewController: AnyObject {
    func setUser(_ user: User)
}

final class EditProfileViewController: CustomViewController<EditProfileView> {
    // MARK: Properties
    
    var presenter: IEditProfilePresenter?
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customView?.delegate = self
        
        setupAppearance()
        
        presenter?.viewDidLoad()
    }
}

// MARK: - Appearance

private extension EditProfileViewController {
    func setupAppearance() {
        navigationItem.title = "Edit profile"
        
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

// MARK: - IEditProfileViewController

extension EditProfileViewController: IEditProfileViewController {
    func setUser(_ user: User) {
        customView?.setUser(user)
    }
}

// MARK: - EditProfileViewDelegate

extension EditProfileViewController: EditProfileViewDelegate {
    func editProfileViewDidPressUsernameTextField(_ editProfileView: EditProfileView) {
        let editProfileUsernameViewController = EditProfileUsernameViewController()
        
        navigationController?.pushViewController(editProfileUsernameViewController, animated: true)
    }
    
    func editProfileViewDidPressBioTextField(_ editProfileView: EditProfileView) {
        presenter?.didPressBioTextField()
    }
}

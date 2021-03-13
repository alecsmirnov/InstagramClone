//
//  EditProfileViewController.swift
//  Instagram
//
//  Created by Admin on 06.03.2021.
//

import UIKit

protocol IEditProfileViewController: AnyObject {
    func setUser(_ user: User)
    
    func showAlreadyInUseUsernameAlert()
}

final class EditProfileViewController: CustomViewController<EditProfileView> {
    // MARK: Properties
    
    var presenter: IEditProfilePresenter?
    
    private lazy var timeoutAlert = TimeoutAlert(presentationController: self)
    
    // MARK: Constants
    
    private enum Constants {
        static let alertTimeout: TimeInterval = 0.5
    }
    
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
        customView?.endEditing(true)
        
        guard let username = customView?.username else { return }
        
        presenter?.didPressEditButton(
            fullName: customView?.name,
            username: username,
            website: customView?.website,
            bio: customView?.bio,
            profileImage: customView?.profileImage)
    }
}

// MARK: - IEditProfileViewController

extension EditProfileViewController: IEditProfileViewController {
    func setUser(_ user: User) {
        customView?.user = user
    }
    
    func showAlreadyInUseUsernameAlert() {
        timeoutAlert.showAlert(title: nil, message: "Username already in use", timeout: Constants.alertTimeout)
    }
}

// MARK: - EditProfileViewDelegate

extension EditProfileViewController: EditProfileViewDelegate {
    func editProfileViewDidPressUsernameTextField(_ editProfileView: EditProfileView) {
        presenter?.didPressUsernameTextField()
    }
    
    func editProfileViewDidPressBioTextField(_ editProfileView: EditProfileView) {
        presenter?.didPressBioTextField()
    }
}

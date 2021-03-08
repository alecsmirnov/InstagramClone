//
//  EditProfileUsernameViewController.swift
//  Instagram
//
//  Created by Admin on 07.03.2021.
//

import UIKit

protocol IEditProfileUsernameViewController: AnyObject {
    func setUsername(_ username: String)
    
    func enableEditButton()
    func disableEditButton()
    
    func showActivityIndicator()
    func hideActivityIndicator()
    
    func showInvalidUsernameAlert()
    func showAlreadyInUseUsernameAlert()
}

final class EditProfileUsernameViewController: CustomViewController<EditProfileUsernameView> {
    // MARK: Properties
    
    var presenter: IEditProfileUsernamePresenter?
    
    private lazy var timeoutAlert = TimeoutAlert(presentationController: self)
    
    // MARK: Constants
    
    private enum Constants {
        static let alertTimeout: TimeInterval = 0.5
    }
    
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
        guard let username = customView?.username else { return }
        
        presenter?.didPressEditButton(with: username)
    }
}

// MARK: - IEditProfileUsernameViewController

extension EditProfileUsernameViewController: IEditProfileUsernameViewController {
    func setUsername(_ username: String) {
        customView?.username = username
    }
    
    func enableEditButton() {
        navigationItem.rightBarButtonItem?.isEnabled = true
    }
    
    func disableEditButton() {
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    func showActivityIndicator() {
        customView?.showActivityIndicator()
    }
    
    func hideActivityIndicator() {
        customView?.hideActivityIndicator()
    }
}

// MARK: - EditProfileUsernameViewDelegate

extension EditProfileUsernameViewController: EditProfileUsernameViewDelegate {
    func editProfileUsernameView(
        _ editProfileUsernameView: EditProfileUsernameView,
        usernameDidChange username: String?
    ) {
        presenter?.didChangeUsername(username ?? "")
    }
    
    func editProfileUsernameViewEnableEditButton(_ editProfileUsernameView: EditProfileUsernameView) {
        enableEditButton()
    }
    
    func editProfileUsernameViewDisableEditButton(_ editProfileUsernameView: EditProfileUsernameView) {
        disableEditButton()
    }
    
    func showInvalidUsernameAlert() {
        timeoutAlert.showAlert(title: nil, message: "Invalid username", timeout: Constants.alertTimeout)
    }
    
    func showAlreadyInUseUsernameAlert() {
        timeoutAlert.showAlert(title: nil, message: "Username already in use", timeout: Constants.alertTimeout)
    }
}

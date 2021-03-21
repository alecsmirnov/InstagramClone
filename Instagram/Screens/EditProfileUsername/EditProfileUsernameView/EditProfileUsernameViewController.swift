//
//  EditProfileUsernameViewController.swift
//  Instagram
//
//  Created by Admin on 07.03.2021.
//

import UIKit

protocol EditProfileUsernameViewControllerProtocol: AnyObject {
    func setUsername(_ username: String)
    
    func enableEditButton()
    func disableEditButton()
    
    func showActivityIndicator()
    func hideActivityIndicator()
    
    func showInvalidUsernameAlert()
    func showAlreadyInUseUsernameAlert()
}

protocol EditProfileUsernameViewControllerOutputProtocol: AnyObject {
    func viewDidLoad()
    
    func didTapCloseButton()
    func didTapEditButton(withUsername username: String)
    func didChangeUsername(_ username: String)
}

final class EditProfileUsernameViewController: CustomViewController<EditProfileUsernameView> {
    // MARK: Properties
    
    var output: EditProfileUsernameViewControllerOutputProtocol?
    
    private lazy var timeoutAlert = TimeoutAlert(presentationController: self)
    
    // MARK: Constants
    
    private enum Constants {
        static let alertTimeout: TimeInterval = 0.5
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customView?.output = self
        
        setupAppearance()
        
        output?.viewDidLoad()
    }
}

// MARK: - EditProfileUsernameViewController Interface

extension EditProfileUsernameViewController: EditProfileUsernameViewControllerProtocol {
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
    
    func showInvalidUsernameAlert() {
        timeoutAlert.showAlert(title: nil, message: "Invalid username", timeout: Constants.alertTimeout)
    }
    
    func showAlreadyInUseUsernameAlert() {
        timeoutAlert.showAlert(title: nil, message: "Username already in use", timeout: Constants.alertTimeout)
    }
}

// MARK: - EditProfileUsernameViewDelegate

extension EditProfileUsernameViewController: EditProfileUsernameViewOutputProtocol {
    func usernameDidChange(_ username: String?) {
        output?.didChangeUsername(username ?? "")
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
            image: EditProfileConstants.Images.close,
            style: .plain,
            target: self,
            action: #selector(didTapCloseButton))

        navigationItem.leftBarButtonItem = closeBarButtonItem
    }
    
    func setupEditButton() {
        let editBarButtonItem = UIBarButtonItem(
            image: EditProfileConstants.Images.edit,
            style: .plain,
            target: self,
            action: #selector(didTapEditButton))

        navigationItem.rightBarButtonItem = editBarButtonItem
    }
}

// MARK: - Button Actions

private extension EditProfileUsernameViewController {
    @objc func didTapCloseButton() {
        output?.didTapCloseButton()
    }
    
    @objc func didTapEditButton() {
        guard let username = customView?.username else { return }
        
        output?.didTapEditButton(withUsername: username)
    }
}

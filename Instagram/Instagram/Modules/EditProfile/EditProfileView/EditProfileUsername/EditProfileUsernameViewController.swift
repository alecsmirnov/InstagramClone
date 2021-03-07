//
//  EditProfileUsernameViewController.swift
//  Instagram
//
//  Created by Admin on 07.03.2021.
//

import UIKit

final class EditProfileUsernameViewController: CustomViewController<EditProfileUsernameView> {
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        navigationController?.popViewController(animated: true)
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
        //presenter?.didPressEditButton()
    }
}

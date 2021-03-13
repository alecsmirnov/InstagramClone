//
//  EditProfileBioViewController.swift
//  Instagram
//
//  Created by Admin on 07.03.2021.
//

import UIKit

protocol IEditProfileBioViewController: AnyObject {
    func setBio(_ bio: String?)
    func setCharacterLimit(_ limit: Int)
}

final class EditProfileBioViewController: CustomViewController<EditProfileBioView> {
    // MARK: - Properties
    
    var presenter: IEditProfileBioPresenter?
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customView?.delegate = self
        
        presenter?.viewDidLoad()
        
        setupAppearance()
    }
}

// MARK: - Appearance

private extension EditProfileBioViewController {
    func setupAppearance() {
        navigationItem.title = "Bio"
        
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
        presenter?.didPressEditButton(with: customView?.bio)
    }
}

// MARK: - IEditProfileBioViewController

extension EditProfileBioViewController: IEditProfileBioViewController {
    func setBio(_ bio: String?) {
        customView?.bio = bio
    }
    
    func setCharacterLimit(_ limit: Int) {
        customView?.characterLimit = limit
    }
}

// MARK: - EditProfileBioViewDelegate

extension EditProfileBioViewController: EditProfileBioViewDelegate {
    func editProfileBioViewEnableEditButton(_ editProfileBioView: EditProfileBioView) {
        navigationItem.rightBarButtonItem?.isEnabled = true
    }
    
    func editProfileBioViewDisableEditButton(_ editProfileBioView: EditProfileBioView) {
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
}

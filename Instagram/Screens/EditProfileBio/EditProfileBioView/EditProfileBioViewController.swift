//
//  EditProfileBioViewController.swift
//  Instagram
//
//  Created by Admin on 07.03.2021.
//

import UIKit

protocol EditProfileBioViewControllerProtocol: AnyObject {
    func setBio(_ bio: String?)
    func setCharacterLimit(_ limit: Int)
}

protocol EditProfileBioViewControllerOutputProtocol: AnyObject {
    func viewDidLoad()
    
    func didTapCloseButton()
    func didTapEditButton(withBio bio: String?)
}

final class EditProfileBioViewController: CustomViewController<EditProfileBioView> {
    // MARK: Properties
    
    var output: EditProfileBioViewControllerOutputProtocol?
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customView?.output = self
        
        output?.viewDidLoad()
        
        setupAppearance()
    }
}

// MARK: - EditProfileBioViewController Interface

extension EditProfileBioViewController: EditProfileBioViewControllerProtocol {
    func setBio(_ bio: String?) {
        customView?.bio = bio
    }
    
    func setCharacterLimit(_ limit: Int) {
        customView?.characterLimit = limit
    }
}

// MARK: - EditProfileBioView Output

extension EditProfileBioViewController: EditProfileBioViewOutputProtocol {
    func characterLimitReached() {
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    func characterLimitResets() {
        navigationItem.rightBarButtonItem?.isEnabled = true
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

// MARK: - Actions

private extension EditProfileBioViewController {
    @objc func didTapCloseButton() {
        output?.didTapCloseButton()
    }
    
    @objc func didTapEditButton() {
        output?.didTapEditButton(withBio: customView?.bio)
    }
}

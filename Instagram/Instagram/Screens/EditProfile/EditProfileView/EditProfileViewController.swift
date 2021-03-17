//
//  EditProfileViewController.swift
//  Instagram
//
//  Created by Admin on 06.03.2021.
//

import UIKit

protocol EditProfileViewControllerProtocol: AnyObject {
    func setUser(_ user: User)
    
    func showLoadingView()
    func hideLoadingView(completion: (() -> Void)?)
    
    func showAlreadyInUseUsernameAlert()
    func showUnknownAlert()
}

protocol EditProfileViewControllerOutputProtocol: AnyObject {
    func viewDidLoad()
    
    func didTapCloseButton()
    func didTapEditButton(
        fullName: String?,
        username: String,
        website: String?,
        bio: String?,
        profileImage: UIImage?)
    func didTapUsernameTextField()
    func didTapBioTextField()
}

final class EditProfileViewController: CustomViewController<EditProfileView> {
    // MARK: Properties
    
    var output: EditProfileViewControllerOutputProtocol?
    
    private lazy var imagePicker = ImagePicker(presentationController: self, delegate: self)
    private lazy var timeoutAlert = TimeoutAlert(presentationController: self)
    private lazy var alertController = SimpleAlert(presentationController: self)
    
    // MARK: Constants
    
    private enum Images {
        static let close = UIImage(systemName: "xmark")?.withRenderingMode(.alwaysOriginal)
        static let edit = UIImage(systemName: "checkmark")
    }
    
    private enum Constants {
        static let alertTimeout: TimeInterval = 0.5
    }
    
    // MARK: Subviews
    
    private lazy var spinnerView = SpinnerView()
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customView?.output = self
        
        setupAppearance()
        
        output?.viewDidLoad()
    }
}

// MARK: - EditProfileViewController Interface

extension EditProfileViewController: EditProfileViewControllerProtocol {
    func setUser(_ user: User) {
        customView?.user = user
    }
    
    func showLoadingView() {
        navigationController?.view.addSubview(spinnerView)
        spinnerView.show()
    }
    
    func hideLoadingView(completion: (() -> Void)?) {
        spinnerView.hide { [weak self] in
            self?.spinnerView.removeFromSuperview()
            
            completion?()
        }
    }
    
    func showAlreadyInUseUsernameAlert() {
        timeoutAlert.showAlert(title: nil, message: "Username already in use", timeout: Constants.alertTimeout)
    }
    
    func showUnknownAlert() {
        alertController.showAlert(title: "Can't update user", message: "Sorry, something goes wrong. Please try again")
    }
}

// MARK: - EditProfileView Output

extension EditProfileViewController: EditProfileViewOutputProtocol {
    func didTapProfileImageButton() {
        imagePicker.takePhoto()
    }
    
    func didTapUsernameTextField() {        
        output?.didTapUsernameTextField()
    }
    
    func didTapBioTextField() {
        output?.didTapBioTextField()
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
            image: Images.close,
            style: .plain,
            target: self,
            action: #selector(didTapCloseButton))

        navigationItem.leftBarButtonItem = closeBarButtonItem
    }
    
    func setupEditButton() {
        let editBarButtonItem = UIBarButtonItem(
            image: Images.edit,
            style: .plain,
            target: self,
            action: #selector(didTapEditButton))

        navigationItem.rightBarButtonItem = editBarButtonItem
    }
}

// MARK: - Actions

private extension EditProfileViewController {
    @objc func didTapCloseButton() {
        output?.didTapCloseButton()
    }
    
    @objc func didTapEditButton() {
        guard let username = customView?.username else { return }
        
        customView?.endEditing(true)
        
        output?.didTapEditButton(
            fullName: customView?.name,
            username: username,
            website: customView?.website,
            bio: customView?.bio,
            profileImage: customView?.profileImage)
    }
}

// MARK: - ImagePickerDelegate

extension EditProfileViewController: ImagePickerDelegate {
    func imagePicker(_ imagePicker: ImagePicker, didSelectImage image: UIImage?) {
        customView?.profileImage = image
    }
}

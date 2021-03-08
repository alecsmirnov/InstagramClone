//
//  EditProfileRouter.swift
//  Instagram
//
//  Created by Admin on 06.03.2021.
//

protocol IEditProfileRouter: AnyObject {
    func closeEditProfileViewController()
    
    func showEditProfileUsernameViewController(username: String, delegate: EditProfileUsernamePresenterDelegate)
    func showEditProfileBioViewController(bio: String?, delegate: EditProfileBioPresenterDelegate)
}

final class EditProfileRouter {
    private weak var viewController: EditProfileViewController?
    
    init(viewController: EditProfileViewController) {
        self.viewController = viewController
    }
}

// MARK: - IEditProfileRouter

extension EditProfileRouter: IEditProfileRouter {
    func closeEditProfileViewController() {
        viewController?.dismiss(animated: true)
    }
    
    func showEditProfileUsernameViewController(username: String, delegate: EditProfileUsernamePresenterDelegate) {
        let navigationViewController = EditProfileUsernameAssembly.createEditProfileUsernameNavigationViewController(
            username: username,
            delegate: delegate)
        
        navigationViewController.modalPresentationStyle = .fullScreen
        navigationViewController.modalTransitionStyle = .crossDissolve
        
        viewController?.present(navigationViewController, animated: true)
    }
    
    func showEditProfileBioViewController(bio: String?, delegate: EditProfileBioPresenterDelegate) {
        let editProfileBioNavigationController = EditProfileBioAssembly.createEditProfileBioNavigationViewController(
            bio: bio,
            delegate: delegate)
        
        editProfileBioNavigationController.modalPresentationStyle = .fullScreen
        editProfileBioNavigationController.modalTransitionStyle = .crossDissolve
        
        viewController?.present(editProfileBioNavigationController, animated: true)
    }
}

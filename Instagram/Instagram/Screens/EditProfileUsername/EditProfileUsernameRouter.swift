//
//  EditProfileUsernameRouter.swift
//  Instagram
//
//  Created by Admin on 08.03.2021.
//

protocol IEditProfileUsernameRouter: AnyObject {
    func closeEditProfileUsernameViewController()
}

final class EditProfileUsernameRouter {
    private weak var viewController: EditProfileUsernameViewController?
    
    init(viewController: EditProfileUsernameViewController) {
        self.viewController = viewController
    }
}

// MARK: - IEditProfileUsernameRouter

extension EditProfileUsernameRouter: IEditProfileUsernameRouter {
    func closeEditProfileUsernameViewController() {
        viewController?.dismiss(animated: true)
    }
}


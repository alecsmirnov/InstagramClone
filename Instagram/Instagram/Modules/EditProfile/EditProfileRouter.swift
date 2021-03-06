//
//  EditProfileRouter.swift
//  Instagram
//
//  Created by Admin on 06.03.2021.
//

protocol IEditProfileRouter: AnyObject {
    func closeEditProfileViewController()
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
}

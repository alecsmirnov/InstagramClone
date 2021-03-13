//
//  EditProfileBioRouter.swift
//  Instagram
//
//  Created by Admin on 08.03.2021.
//

protocol IEditProfileBioRouter: AnyObject {
    func closeEditProfileBioViewController()
}

final class EditProfileBioRouter {
    private weak var viewController: EditProfileBioViewController?
    
    init(viewController: EditProfileBioViewController) {
        self.viewController = viewController
    }
}

// MARK: - IEditProfileBioRouter

extension EditProfileBioRouter: IEditProfileBioRouter {
    func closeEditProfileBioViewController() {
        viewController?.dismiss(animated: true)
    }
}

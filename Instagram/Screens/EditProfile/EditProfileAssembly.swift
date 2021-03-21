//
//  EditProfileAssembly.swift
//  Instagram
//
//  Created by Admin on 06.03.2021.
//

import UIKit

enum EditProfileAssembly {
    static func createEditProfileNavigationViewController(
        user: User,
        coordinator: EditProfileCoordinatorProtocol? = nil
    ) -> UINavigationController {
        let editProfileViewController = createEditProfileViewController(user: user, coordinator: coordinator)
        let navigationController = UINavigationController(rootViewController: editProfileViewController)
        
        return navigationController
    }
    
    private static func createEditProfileViewController(
        user: User,
        coordinator: EditProfileCoordinatorProtocol? = nil
    ) -> EditProfileViewController {
        let viewController = EditProfileViewController()
        let presenter = EditProfilePresenter()
        
        viewController.output = presenter
        presenter.view = viewController
        presenter.coordinator = coordinator
        
        presenter.editProfileService = EditProfileService()
        
        presenter.user = user
        
        return viewController
    }
}

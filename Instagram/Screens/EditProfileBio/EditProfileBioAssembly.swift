//
//  EditProfileBioAssembly.swift
//  Instagram
//
//  Created by Admin on 08.03.2021.
//

import UIKit

enum EditProfileBioAssembly {
    static func createEditProfileBioNavigationViewController(
        bio: String?,
        delegate: EditProfileBioPresenterDelegate,
        coordinator: EditProfileBioCoordinatorProtocol? = nil
    ) -> UINavigationController {
        let editProfileBioViewController = createEditProfileBioViewController(
            bio: bio,
            delegate: delegate,
            coordinator: coordinator)
        let navigationController = UINavigationController(rootViewController: editProfileBioViewController)
        
        return navigationController
    }
    
    private static func createEditProfileBioViewController(
        bio: String?,
        delegate: EditProfileBioPresenterDelegate,
        coordinator: EditProfileBioCoordinatorProtocol?
    ) -> EditProfileBioViewController {
        let viewController = EditProfileBioViewController()
        let presenter = EditProfileBioPresenter()
        
        viewController.output = presenter
        presenter.view = viewController
        presenter.coordinator = coordinator
        
        presenter.delegate = delegate
        
        presenter.bio = bio
        
        return viewController
    }
}

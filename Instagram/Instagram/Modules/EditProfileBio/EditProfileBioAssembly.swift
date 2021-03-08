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
        delegate: EditProfileBioPresenterDelegate
    ) -> UINavigationController {
        let editProfileBioViewController = createEditProfileBioViewController(bio: bio, delegate: delegate)
        let navigationController = UINavigationController(rootViewController: editProfileBioViewController)
        
        return navigationController
    }
    
    private static func createEditProfileBioViewController(
        bio: String?,
        delegate: EditProfileBioPresenterDelegate
    ) -> EditProfileBioViewController {
        let viewController = EditProfileBioViewController()
        
        let presenter = EditProfileBioPresenter()
        let router = EditProfileBioRouter(viewController: viewController)
        
        viewController.presenter = presenter
        
        presenter.viewController = viewController
        presenter.router = router
        
        presenter.bio = bio
        presenter.delegate = delegate
        
        return viewController
    }
}

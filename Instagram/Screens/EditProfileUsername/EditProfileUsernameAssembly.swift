//
//  EditProfileUsernameAssembly.swift
//  Instagram
//
//  Created by Admin on 08.03.2021.
//

import UIKit

enum EditProfileUsernameAssembly {
    static func createEditProfileUsernameNavigationViewController(
        username: String,
        currentUsername: String,
        delegate: EditProfileUsernamePresenterDelegate,
        coordinator: EditProfileUsernameCoordinatorProtocol? = nil
    ) -> UINavigationController {
        let editProfileUsernameViewController = createEditProfileUsernameViewController(
            username: username,
            currentUsername: currentUsername,
            delegate: delegate,
            coordinator: coordinator)
        let navigationController = UINavigationController(rootViewController: editProfileUsernameViewController)
        
        return navigationController
    }
    
    private static func createEditProfileUsernameViewController(
        username: String,
        currentUsername: String,
        delegate: EditProfileUsernamePresenterDelegate,
        coordinator: EditProfileUsernameCoordinatorProtocol?
    ) -> EditProfileUsernameViewController {
        let viewController = EditProfileUsernameViewController()
        let presenter = EditProfileUsernamePresenter()
        
        viewController.output = presenter
        presenter.view = viewController
        presenter.coordinator = coordinator
        
        presenter.delegate = delegate
        
        presenter.editProfileUsernameService = EditProfileService()
        
        presenter.username = username
        presenter.currentUsername = currentUsername
        
        return viewController
    }
}

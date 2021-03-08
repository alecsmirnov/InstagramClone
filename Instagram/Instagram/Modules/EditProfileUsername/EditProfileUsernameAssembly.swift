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
        delegate: EditProfileUsernamePresenterDelegate
    ) -> UINavigationController {
        let editProfileUsernameViewController = createEditProfileUsernameViewController(
            username: username,
            currentUsername: currentUsername,
            delegate: delegate)
        let navigationController = UINavigationController(rootViewController: editProfileUsernameViewController)
        
        return navigationController
    }
    
    private static func createEditProfileUsernameViewController(
        username: String,
        currentUsername: String,
        delegate: EditProfileUsernamePresenterDelegate
    ) -> EditProfileUsernameViewController {
        let viewController = EditProfileUsernameViewController()
        
        let interactor = EditProfileUsernameInteractor()
        let presenter = EditProfileUsernamePresenter()
        let router = EditProfileUsernameRouter(viewController: viewController)
        
        viewController.presenter = presenter
        
        interactor.presenter = presenter
        
        presenter.viewController = viewController
        presenter.interactor = interactor
        presenter.router = router
        
        presenter.username = username
        presenter.currentUsername = currentUsername
        presenter.delegate = delegate
        
        return viewController
    }
}

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
        delegate: EditProfilePresenterDelegate
    ) -> UINavigationController {
        let editProfileViewController = createEditProfileViewController(user: user, delegate: delegate)
        let navigationController = UINavigationController(rootViewController: editProfileViewController)
        
        return navigationController
    }
    
    static func createEditProfileViewController(
        user: User,
        delegate: EditProfilePresenterDelegate
    ) -> EditProfileViewController {
        let viewController = EditProfileViewController()
        
        let interactor = EditProfileInteractor()
        let presenter = EditProfilePresenter()
        let router = EditProfileRouter(viewController: viewController)
        
        viewController.presenter = presenter
        
        interactor.presenter = presenter
        
        presenter.viewController = viewController
        presenter.interactor = interactor
        presenter.router = router
        
        presenter.user = user
        presenter.delegate = delegate
        
        return viewController
    }
}

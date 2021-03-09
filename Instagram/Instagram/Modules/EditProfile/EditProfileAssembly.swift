//
//  EditProfileAssembly.swift
//  Instagram
//
//  Created by Admin on 06.03.2021.
//

import UIKit

enum EditProfileAssembly {
    static func createEditProfileNavigationViewController(user: User) -> UINavigationController {
        let editProfileViewController = createEditProfileViewController(user: user)
        let navigationController = UINavigationController(rootViewController: editProfileViewController)
        
        return navigationController
    }
    
    private static func createEditProfileViewController(user: User) -> EditProfileViewController {
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
        
        return viewController
    }
}

//
//  EditProfileAssembly.swift
//  Instagram
//
//  Created by Admin on 06.03.2021.
//

import UIKit

enum EditProfileAssembly {
    static func createEditProfileNavigationViewController() -> UINavigationController {
        let editProfileViewController = createEditProfileViewController()
        let navigationController = UINavigationController(rootViewController: editProfileViewController)
        
        return navigationController
    }
    
    static func createEditProfileViewController() -> EditProfileViewController {
        let viewController = EditProfileViewController()
        
        let interactor = EditProfileInteractor()
        let presenter = EditProfilePresenter()
        let router = EditProfileRouter(viewController: viewController)
        
        viewController.presenter = presenter
        
        interactor.presenter = presenter
        
        presenter.viewController = viewController
        presenter.interactor = interactor
        presenter.router = router
        
        return viewController
    }
}

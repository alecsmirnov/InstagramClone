//
//  EditProfileAssembly.swift
//  Instagram
//
//  Created by Admin on 06.03.2021.
//

import UIKit

enum EditProfileAssembly {
    static func createEditProfileNavigationViewController(
        delegate: EditProfilePresenterDelegate
    ) -> UINavigationController {
        let editProfileViewController = createEditProfileViewController(delegate: delegate)
        let navigationController = UINavigationController(rootViewController: editProfileViewController)
        
        return navigationController
    }
    
    static func createEditProfileViewController(delegate: EditProfilePresenterDelegate) -> EditProfileViewController {
        let viewController = EditProfileViewController()
        
        let interactor = EditProfileInteractor()
        let presenter = EditProfilePresenter()
        let router = EditProfileRouter(viewController: viewController)
        
        viewController.presenter = presenter
        
        interactor.presenter = presenter
        
        presenter.viewController = viewController
        presenter.interactor = interactor
        presenter.router = router
        
        presenter.delegate = delegate
        
        return viewController
    }
}

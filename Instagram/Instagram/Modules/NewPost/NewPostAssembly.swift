//
//  NewPostAssembly.swift
//  Instagram
//
//  Created by Admin on 28.01.2021.
//

import UIKit

enum NewPostAssembly {
    static func createNewPostNavigationController(coordinator: NewPostCoordinator? = nil) -> UINavigationController {
        return UINavigationController(rootViewController: createNewPostViewController(coordinator: coordinator))
    }
    
    static func createNewPostViewController(coordinator: NewPostCoordinator? = nil) -> NewPostViewController {
        let viewController = NewPostViewController()
        
        let interactor = NewPostInteractor()
        let presenter = NewPostPresenter()
        let router = NewPostRouter(viewController: viewController)
        
        viewController.presenter = presenter
        
        interactor.presenter = presenter
        
        presenter.viewController = viewController
        presenter.interactor = interactor
        presenter.router = router
        
        return viewController
    }
}

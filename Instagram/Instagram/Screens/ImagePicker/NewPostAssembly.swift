//
//  ImagePickerAssembly.swift
//  Instagram
//
//  Created by Admin on 28.01.2021.
//

import UIKit

enum ImagePickerAssembly {
    static func createNewPostNavigationController(
        coordinator: NewPostCoordinatorProtocol? = nil
    ) -> UINavigationController {
        return UINavigationController(rootViewController: createNewPostViewController(coordinator: coordinator))
    }
    
    static func createNewPostViewController(coordinator: NewPostCoordinatorProtocol? = nil) -> ImagePickerViewController {
        let viewController = ImagePickerViewController()
        let presenter = ImagePickerPresenter()
        
        viewController.output = presenter
        presenter.view = viewController
        presenter.coordinator = coordinator
        
        return viewController
    }
}

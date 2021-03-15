//
//  SharePostAssembly.swift
//  Instagram
//
//  Created by Admin on 01.02.2021.
//

import UIKit

enum SharePostAssembly {
    static func createSharePostViewController(
        image: UIImage,
        coordinator: SharePostCoordinatorProtocol? = nil
    )-> SharePostViewController {
        let viewController = SharePostViewController()
        let presenter = SharePostPresenter()
        
        viewController.output = presenter
        presenter.view = viewController
        presenter.coordinator = coordinator
        
        presenter.image = image
        
        return viewController
    }
}

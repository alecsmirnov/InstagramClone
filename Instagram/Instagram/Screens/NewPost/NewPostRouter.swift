//
//  NewPostRouter.swift
//  Instagram
//
//  Created by Admin on 28.01.2021.
//

import UIKit

protocol INewPostRouter: AnyObject {
    func closeNewPostViewController()
    func showSharePostViewController(mediaFile: UIImage)
}

final class NewPostRouter {
    private weak var viewController: NewPostViewController?
    
    init(viewController: NewPostViewController) {
        self.viewController = viewController
    }
}

// MARK: - INewPostRouter

extension NewPostRouter: INewPostRouter {
    func closeNewPostViewController() {
        viewController?.dismiss(animated: true)
    }
    
    func showSharePostViewController(mediaFile: UIImage) {
        let sharePostViewController = SharePostAssembly.createSharePostViewController(mediaFile: mediaFile)
        
        viewController?.navigationController?.pushViewController(sharePostViewController, animated: true)
    }
}

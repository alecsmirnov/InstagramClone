//
//  NewPostCoordinator.swift
//  Instagram
//
//  Created by Admin on 13.03.2021.
//

import UIKit

protocol ImagePickerCoordinatorProtocol: AnyObject {
    func closeImagePickerViewController()
    func showSharePostViewController(withImage image: UIImage)
}

protocol SharePostCoordinatorProtocol: AnyObject {
    func closeSharePostViewController()
}

protocol NewPostCoordinatorDelegate: AnyObject {
    func newPostCoordinatorDidClose(_ newPostCoordinator: NewPostCoordinator)
}

final class NewPostCoordinator: CoordinatorProtocol {
    // MARK: Properties
    
    var navigationController: UINavigationController
    var childCoordinators: [CoordinatorProtocol] = []
    
    private weak var presenterController: UIViewController?
    private weak var delegate: NewPostCoordinatorDelegate?
    
    // MARK: Lifecycle
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    convenience init(presenterController: UIViewController?, delegate: NewPostCoordinatorDelegate?) {
        self.init(navigationController: UINavigationController())
        
        self.presenterController = presenterController
        self.delegate = delegate
    }
}

// MARK: - Interface

extension NewPostCoordinator {
    func start() {
        let imagePickerNavigationController = ImagePickerAssembly.createImagePickerNavigationController(
            coordinator: self)
        
        imagePickerNavigationController.modalPresentationStyle = .fullScreen
        
        navigationController = imagePickerNavigationController
        presenterController?.present(imagePickerNavigationController, animated: true)
    }
    
    func closePresentedController() {
        presenterController?.dismiss(animated: true)
        
        delegate?.newPostCoordinatorDidClose(self)
    }
}

// MARK: - ImagePickerCoordinatorProtocol

extension NewPostCoordinator: ImagePickerCoordinatorProtocol {
    func closeImagePickerViewController() {
        closePresentedController()
    }
    
    func showSharePostViewController(withImage image: UIImage) {
        let sharePostViewController = SharePostAssembly.createSharePostViewController(image: image, coordinator: self)
        
        navigationController.pushViewController(sharePostViewController, animated: true)
    }
}

// MARK: - SharePostCoordinatorProtocol

extension NewPostCoordinator: SharePostCoordinatorProtocol {
    func closeSharePostViewController() {
        closePresentedController()
    }
}

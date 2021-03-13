//
//  NewPostCoordinator.swift
//  Instagram
//
//  Created by Admin on 13.03.2021.
//

import UIKit

protocol NewPostCoordinatorProtocol: AnyObject {
    func closeNewPostViewController()
    func showSharePostViewController()
}

protocol NewPostCoordinatorDelegate: AnyObject {
    func newPostCoordinatorDidClose(_ newPostCoordinator: NewPostCoordinator)
}

final class NewPostCoordinator: Coordinator {
    // MARK: Properties
    
    var childCoordinators: [Coordinator] = []
    
    var navigationController: UINavigationController
    
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
        let newPostViewController = NewPostAssembly.createNewPostNavigationController(coordinator: self)
        
        newPostViewController.modalPresentationStyle = .fullScreen

        presenterController?.present(newPostViewController, animated: true)
    }
}

// MARK: - NewPostCoordinatorProtocol

extension NewPostCoordinator: NewPostCoordinatorProtocol {
    func closeNewPostViewController() {
        presenterController?.dismiss(animated: true)
        
        delegate?.newPostCoordinatorDidClose(self)
    }
    
    func showSharePostViewController() {
        
    }
}

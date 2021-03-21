//
//  SearchCoordinator.swift
//  Instagram
//
//  Created by Admin on 13.03.2021.
//

import UIKit

protocol SearchCoordinatorProtocol: AnyObject {
    func showProfileViewController(user: User)
}

final class SearchCoordinator: NSObject, CoordinatorProtocol {
    // MARK: Properties
    
    var navigationController: UINavigationController
    var childCoordinators: [CoordinatorProtocol] = []
    
    private weak var presenterController: UIViewController?
    
    // MARK: Lifecycle
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    convenience init(presenterController: UIViewController?) {
        self.init(navigationController: UINavigationController())
        
        self.presenterController = presenterController
    }
}

// MARK: - Interface

extension SearchCoordinator {
    func start() {
        let searchViewController = SearchAssembly.createSearchViewController(coordinator: self)
        
        navigationController.delegate = self
        navigationController.pushViewController(searchViewController, animated: false)
    }
}

// MARK: - SearchCoordinatorProtocol

extension SearchCoordinator: SearchCoordinatorProtocol {
    func showProfileViewController(user: User) {
        let profileCoordinator = ProfileCoordinator(
            navigationController: navigationController,
            presenterController: presenterController,
            delegate: nil)
        
        profileCoordinator.user = user
        profileCoordinator.start(animated: true)
        
        appendChildCoordinator(profileCoordinator)
    }
}

// MARK: - UINavigationControllerDelegate

extension SearchCoordinator: UINavigationControllerDelegate {
    func navigationController(
        _ navigationController: UINavigationController,
        didShow viewController: UIViewController,
        animated: Bool
    ) {
        guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) else {
            return
        }

        guard !navigationController.viewControllers.contains(fromViewController) else {
            return
        }
        
        // Not as right as I would like :\
        guard
            let profileViewController = fromViewController as? ProfileViewController,
            let presenter = profileViewController.output as? ProfilePresenter,
            let childCoordinator = presenter.coordinator as? CoordinatorProtocol
        else {
            return
        }
        
        removeChildCoordinator(childCoordinator)
    }
}

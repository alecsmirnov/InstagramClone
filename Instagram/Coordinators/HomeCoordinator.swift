//
//  HomeCoordinator.swift
//  Instagram
//
//  Created by Admin on 13.03.2021.
//

import UIKit

protocol HomeCoordinatorProtocol: AnyObject {
    func showProfileViewController(user: User)
    func showCommentsViewController(userPost: UserPost)
}

protocol CommentsCoordinatorProtocol: AnyObject {
    func showProfileViewController(user: User)
}

final class HomeCoordinator: NSObject, CoordinatorProtocol {
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
    
    convenience override init() {
        self.init(navigationController: UINavigationController())
    }
}

// MARK: - Interface

extension HomeCoordinator {
    func start() {
        let homeViewController = HomeAssembly.createHomeViewController(coordinator: self)
        
        navigationController.delegate = self
        navigationController.pushViewController(homeViewController, animated: false)
    }
}

// MARK: - HomeCoordinatorProtocol

extension HomeCoordinator: HomeCoordinatorProtocol {
    func showProfileViewController(user: User) {
        let profileCoordinator = ProfileCoordinator(
            navigationController: navigationController,
            presenterController: presenterController,
            delegate: nil)
        
        profileCoordinator.user = user
        profileCoordinator.start(animated: true)
        
        appendChildCoordinator(profileCoordinator)
    }
    
    func showCommentsViewController(userPost: UserPost) {
        let commentsViewController = CommentsAssembly.createCommentsViewController(
            userPost: userPost,
            coordinator: self)
        
        navigationController.pushViewController(commentsViewController, animated: true)
    }
}

// MARK: - CommentsCoordinatorProtocol

extension HomeCoordinator: CommentsCoordinatorProtocol {}

// MARK: - UINavigationControllerDelegate

extension HomeCoordinator: UINavigationControllerDelegate {
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

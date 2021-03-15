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

final class SearchCoordinator: CoordinatorProtocol {
    // MARK: Properties
    
    var navigationController: UINavigationController
    var childCoordinators: [CoordinatorProtocol] = []
    
    // MARK: Lifecycle
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    convenience init() {
        self.init(navigationController: UINavigationController())
    }
}

// MARK: - Interface

extension SearchCoordinator {
    func start() {
        let searchViewController = SearchAssembly.createSearchViewController(coordinator: self)
        
        navigationController.pushViewController(searchViewController, animated: false)
    }
}

// MARK: - SearchCoordinatorProtocol

extension SearchCoordinator: SearchCoordinatorProtocol {
    func showProfileViewController(user: User) {
        
    }
}

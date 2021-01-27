//
//  TabBarController.swift
//  Instagram
//
//  Created by Admin on 27.01.2021.
//

import UIKit

final class TabBarController: UITabBarController {
    // MARK: Actions
    
    var shouldSelectViewController: ((UITabBarController, UIViewController) -> Bool)?
    var didSelectViewController: ((UITabBarController, UIViewController) -> Void)?
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        delegate = self
    }
}

// MARK: - UITabBarControllerDelegate

extension TabBarController: UITabBarControllerDelegate {
    func tabBarController(
        _ tabBarController: UITabBarController,
        shouldSelect viewController: UIViewController
    ) -> Bool {
        return shouldSelectViewController?(tabBarController, viewController) ?? true
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        didSelectViewController?(tabBarController, viewController)
    }
}

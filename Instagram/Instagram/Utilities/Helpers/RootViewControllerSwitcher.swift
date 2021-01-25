//
//  RootViewControllerSwitcher.swift
//  Instagram
//
//  Created by Admin on 25.01.2021.
//

import UIKit

enum RootViewControllerSwitcher {
    static func setRootViewController(_ viewController: UIViewController, animationDuration: TimeInterval = 0.25) {
        guard let window = UIApplication.shared.windows.first else { return }
        
        window.rootViewController = viewController
        window.makeKeyAndVisible()

        UIView.transition(with: window, duration: animationDuration, options: .transitionCrossDissolve, animations: {})
    }
}

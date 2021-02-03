//
//  LaunchAssembly.swift
//  Instagram
//
//  Created by Admin on 25.01.2021.
//

import UIKit

enum LaunchAssembly {
    static func createRootViewController() -> UIViewController {
        let rootViewController: UIViewController
        
        if FirebaseAuthService.isUserSignedIn {
            rootViewController = TabBarAssembly.createTabBarController()
        } else {
            rootViewController = LoginAssembly.createLoginViewController()
        }
        
        return rootViewController
    }
}

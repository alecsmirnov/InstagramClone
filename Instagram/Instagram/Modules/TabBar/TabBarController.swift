//
//  TabBarController.swift
//  Instagram
//
//  Created by Admin on 14.01.2021.
//

import UIKit

final class TabBarController: UITabBarController {
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: Initialization
    
    init(viewControllers: [UIViewController]) {
        super.init(nibName: nil, bundle: nil)
        
        setupTabBarAppearance(viewControllers: viewControllers)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Appearance

private extension TabBarController {
    func setupTabBarAppearance(viewControllers: [UIViewController]) {        
        self.viewControllers = viewControllers
    }
}

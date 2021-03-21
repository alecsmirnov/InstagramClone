//
//  MainTabBarController.swift
//  Instagram
//
//  Created by Admin on 27.01.2021.
//

import UIKit

final class MainTabBarController: UITabBarController {
    // MARK: Properties
    
    var didSelectPlusTabItem: (() -> Void)?
    
    // MARK: Constants
    
    enum TabBarItem: Int {
        case home
        case search
        case plus
        case like
        case profile
    }
    
    private let tabBarItems = [
        UITabBarItem(title: nil, image: Images.home, selectedImage: Images.homeSelected),
        UITabBarItem(title: nil, image: Images.search, selectedImage: Images.searchSelected),
        UITabBarItem(title: nil, image: Images.plus, selectedImage: nil),
        UITabBarItem(title: nil, image: Images.like, selectedImage: Images.likeSelected),
        UITabBarItem(title: nil, image: Images.profile, selectedImage: Images.profileSelected)
    ]
    
    private enum Metrics {
        static let tabBarImageVerticalInset: CGFloat = 5.5
    }
    
    private enum Colors {
        static let tint = UIColor.black
    }
    
    private enum Images {
        static let home = UIImage(named: "home_unselected")
        static let homeSelected = UIImage(named: "home_selected")
        
        static let search = UIImage(named: "search_unselected")
        static let searchSelected = UIImage(named: "search_selected")
        
        static let plus = UIImage(named: "plus_unselected")
        
        static let like = UIImage(named: "like_unselected")
        static let likeSelected = UIImage(named: "like_selected")
        
        static let profile = UIImage(named: "profile_unselected")
        static let profileSelected = UIImage(named: "profile_selected")
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupAppearance()
    }
}

// MARK: - Public Methods

extension MainTabBarController {
    func appendNavigationController(_ navigationController: UINavigationController, item: TabBarItem) {
        customizeNavigationController(navigationController, item: item)
        
        viewControllers = (viewControllers ?? []) + [navigationController]
    }
}

// MARK: - Appearance

private extension MainTabBarController {
    func setupAppearance() {
        delegate = self
        
        tabBar.tintColor = Colors.tint
    }
    
    private func customizeNavigationController(
        _ navigationController: UINavigationController,
        item: TabBarItem
    ) {        
        navigationController.tabBarItem = tabBarItems[item.rawValue]
        navigationController.tabBarItem.imageInsets = UIEdgeInsets(
            top: Metrics.tabBarImageVerticalInset,
            left: 0,
            bottom: -Metrics.tabBarImageVerticalInset,
            right: 0)
    }
}

// MARK: - UITabBarControllerDelegate

extension MainTabBarController: UITabBarControllerDelegate {
    func tabBarController(
        _ tabBarController: UITabBarController,
        shouldSelect viewController: UIViewController
    ) -> Bool {
        guard
            let index = tabBarController.viewControllers?.firstIndex(of: viewController),
            let item = TabBarItem(rawValue: index)
        else {
            return true
        }
        
        if item == .plus {
            didSelectPlusTabItem?()
            
            return false
        }
        
        return true
    }
}

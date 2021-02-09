//
//  HomeViewController.swift
//  Instagram
//
//  Created by Admin on 14.01.2021.
//

import UIKit

protocol IHomeViewController: AnyObject {
    
}

final class HomeViewController: CustomViewController<HomeView> {
    // MARK: Properties
    
    var presenter: IHomePresenter?
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationItemTitle()
    }
}

// MARK: - IHomeViewController

extension HomeViewController: IHomeViewController {
    
}

// MARK: - Appearance

private extension HomeViewController {
    func setupNavigationItemTitle() {
        navigationItem.titleView = UIImageView(image: UIImage(named: "instagram_logo_black_mini"))
    }
}

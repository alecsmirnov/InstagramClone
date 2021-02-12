//
//  HomeViewController.swift
//  Instagram
//
//  Created by Admin on 14.01.2021.
//

import UIKit

protocol IHomeViewController: AnyObject {
    func appendUserPost(_ userPost: UserPost)
}

final class HomeViewController: CustomViewController<HomeView> {
    // MARK: Properties
    
    var presenter: IHomePresenter?
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter?.viewDidLoad()
        
        setupNavigationItemTitle()
    }
}

// MARK: - IHomeViewController

extension HomeViewController: IHomeViewController {    
    func appendUserPost(_ userPost: UserPost) {
        customView?.appendUserPost(userPost)
    }
}

// MARK: - Appearance

private extension HomeViewController {
    func setupNavigationItemTitle() {
        navigationItem.titleView = UIImageView(image: UIImage(named: "instagram_logo_black_mini"))
    }
}

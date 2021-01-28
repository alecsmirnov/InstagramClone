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
    }
}

// MARK: - IHomeViewController

extension HomeViewController: IHomeViewController {
    
}

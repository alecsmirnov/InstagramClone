//
//  ProfileViewController.swift
//  Instagram
//
//  Created by Admin on 21.01.2021.
//

import UIKit

protocol IProfileViewController: AnyObject {
    func setTitle(text: String)
}

final class ProfileViewController: CustomViewController<ProfileView> {
    // MARK: Properties
    
    var presenter: IProfilePresenter?
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTitle(text: "test title")
    }
}

// MARK: - IProfileViewController

extension ProfileViewController: IProfileViewController {
    func setTitle(text: String) {
        navigationItem.title = text
    }
}

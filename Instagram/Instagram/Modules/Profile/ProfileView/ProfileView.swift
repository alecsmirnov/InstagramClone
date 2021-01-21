//
//  ProfileView.swift
//  Instagram
//
//  Created by Admin on 21.01.2021.
//

import UIKit

final class ProfileView: UIView {
    // MARK: Properties
    
    // MARK: Subviews
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    // MARK: Initialization
    
    init() {
        super.init(frame: .zero)
        
        setupAppearance()
//        setupLayout()
//        setupActions()
//        setupGestures()
//        setupKeyboardEvents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Appearance

private extension ProfileView {
    func setupAppearance() {
        backgroundColor = .systemBackground
        
    }
}

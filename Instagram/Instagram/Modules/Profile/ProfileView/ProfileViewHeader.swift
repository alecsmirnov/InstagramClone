//
//  ProfileViewHeader.swift
//  Instagram
//
//  Created by Admin on 21.01.2021.
//

import UIKit

final class ProfileViewHeader: UICollectionReusableView {
    // MARK: Properties
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    // MARK: Constants
    
    private enum Metrics {
        static let profileImageViewSize: CGFloat = 80
        static let profileImageViewTopSpace: CGFloat = 16
        static let profileImageViewLeadingSpace: CGFloat = 16
    }
    
    // MARK: Subviews
    
    private let profileImageView = UIImageView()
    
    // MARK: Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupAppearance()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public Methods

extension ProfileViewHeader {
    func setUser(_ user: User) {
        if let profileImageURL = user.profileImageURL {
            profileImageView.download(urlString: profileImageURL)
        }
    }
}

// MARK: - Appearance

private extension ProfileViewHeader {
    func setupAppearance() {
        backgroundColor = .cyan
        
        setupProfileImageViewAppearance()
    }
    
    func setupProfileImageViewAppearance() {
        profileImageView.layer.cornerRadius = Metrics.profileImageViewSize / 2
        profileImageView.layer.masksToBounds = true
        
        profileImageView.layer.borderColor = UIColor.gray.cgColor
        profileImageView.layer.borderWidth = 1
    }
}

// MARK: - Layout

private extension ProfileViewHeader {
    func setupLayout() {
        setupSubviews()
        
        setupProfileImageViewLayout()
    }
    
    func setupSubviews() {
        addSubview(profileImageView)
    }
    
    func setupProfileImageViewLayout() {
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(
                equalTo: safeAreaLayoutGuide.topAnchor,
                constant: Metrics.profileImageViewTopSpace),
            profileImageView.leadingAnchor.constraint(
                equalTo: safeAreaLayoutGuide.leadingAnchor,
                constant: Metrics.profileImageViewLeadingSpace),
            profileImageView.heightAnchor.constraint(equalToConstant: Metrics.profileImageViewSize),
            profileImageView.widthAnchor.constraint(equalToConstant: Metrics.profileImageViewSize),
        ])
    }
}

//
//  ProfileHeaderCollectionViewCell.swift
//  Instagram
//
//  Created by Admin on 22.01.2021.
//

import UIKit

final class ProfileHeaderCollectionViewCell: UICollectionViewCell {
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
    
    private let textLabel = UILabel()
    
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

// MARK: - Appearance

private extension ProfileHeaderCollectionViewCell {
    func setupAppearance() {
        backgroundColor = .cyan
        
        setupTextLabelAppearance()
    }
    
    func setupTextLabelAppearance() {
        textLabel.numberOfLines = 0
        textLabel.text = "Test\nTest 2\nTest 3\nTest 4"
    }
}

// MARK: - Layout

private extension ProfileHeaderCollectionViewCell {
    func setupLayout() {
        setupSubviews()
        
        setupTextLabelLayout()
    }
    
    func setupSubviews() {
        contentView.addSubview(textLabel)
    }
    
    func setupTextLabelLayout() {
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            textLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            textLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            textLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
}

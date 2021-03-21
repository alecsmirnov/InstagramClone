//
//  UserCell.swift
//  Instagram
//
//  Created by Admin on 15.02.2021.
//

import UIKit

final class UserCell: UICollectionViewCell {
    // MARK: Properties
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    private var profileImageDataTask: URLSessionDataTask?
    
    // MARK: Constants
    
    private enum Metrics {
        static let profileImageViewSize: CGFloat = 50
        static let profileImageViewBorderWidth: CGFloat = 1
        static let profileImageViewVerticalSpace: CGFloat = 8
        static let profileImageViewLeadingSpace: CGFloat = 16
        
        static let stackViewLeadingSpace: CGFloat = 12
        static let stackViewSpacing: CGFloat = 4
    }
    
    private enum Colors {
        static let profileImageViewBorder = AppConstants.Colors.profileImageBorder
    }
    
    // MARK: Subviews
    
    private let profileImageView = UIImageView()
    
    private let stackView = UIStackView()
    private let usernameLabel = UILabel()
    private let fullNameLabel = UILabel()
    
    // MARK: Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupAppearance()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        profileImageDataTask?.cancel()
        profileImageView.image = nil
    }
}

// MARK: - Public Methods

extension UserCell {
    func configure(with user: User) {
        if let profileImageURL = user.profileImageURL {
            profileImageDataTask = profileImageView.download(urlString: profileImageURL)
        }
        
        usernameLabel.text = user.username
        fullNameLabel.text = user.fullName
        
        fullNameLabel.isHidden = (user.fullName == nil)
    }
}

// MARK: - Appearance

private extension UserCell {
    func setupAppearance() {
        setupProfileImageViewAppearance()
        setupStackViewAppearance()
    }
    
    func setupProfileImageViewAppearance() {
        profileImageView.layer.cornerRadius = Metrics.profileImageViewSize / 2
        profileImageView.layer.masksToBounds = true
        
        profileImageView.layer.borderWidth = Metrics.profileImageViewBorderWidth
        profileImageView.layer.borderColor = Colors.profileImageViewBorder.cgColor
    }

    func setupStackViewAppearance() {
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = Metrics.stackViewSpacing
        
        usernameLabel.font = .boldSystemFont(ofSize: usernameLabel.font.pointSize)
        fullNameLabel.textColor = .systemGray
    }
}

// MARK: - Layout

private extension UserCell {
    func setupLayout() {
        setupSubviews()
        
        setupProfileImageViewLayout()
        setupStackViewLayout()
    }
    
    func setupSubviews() {
        contentView.addSubview(profileImageView)
        contentView.addSubview(stackView)
        
        stackView.addArrangedSubview(usernameLabel)
        stackView.addArrangedSubview(fullNameLabel)
    }
    
    func setupProfileImageViewLayout() {
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: Metrics.profileImageViewVerticalSpace),
            profileImageView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: Metrics.profileImageViewLeadingSpace),
            profileImageView.heightAnchor.constraint(equalToConstant: Metrics.profileImageViewSize),
            profileImageView.widthAnchor.constraint(equalToConstant: Metrics.profileImageViewSize),
        ])
        
        let profileImageViewBottomConstraint = profileImageView.bottomAnchor.constraint(
            equalTo: contentView.bottomAnchor,
            constant: -Metrics.profileImageViewVerticalSpace)
        
        profileImageViewBottomConstraint.priority = .defaultLow
        profileImageViewBottomConstraint.isActive = true
    }
    
    func setupStackViewLayout() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(
                equalTo: profileImageView.trailingAnchor,
                constant: Metrics.stackViewLeadingSpace),
            stackView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -Metrics.profileImageViewLeadingSpace),
            stackView.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
        ])
    }
}

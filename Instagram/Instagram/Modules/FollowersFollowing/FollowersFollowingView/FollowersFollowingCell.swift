//
//  FollowersFollowingCell.swift
//  Instagram
//
//  Created by Admin on 03.03.2021.
//

import UIKit

protocol FollowersFollowingCellDelegate: AnyObject {
    //func followersFollowingCell(_ followersFollowingCell: FollowersFollowingCell, didSelectUser user: User)
    func followersFollowingCellDidPressFollowButton(_ followersFollowingCell: FollowersFollowingCell)
    func followersFollowingCellDidPressUnfollowButton(_ followersFollowingCell: FollowersFollowingCell)
    func followersFollowingCellDidPressRemoveButton(_ followersFollowingCell: FollowersFollowingCell)
}

enum FollowUnfollowRemoveButtonState {
    case follow
    case unfollow
    case remove
}

final class FollowersFollowingCell: UICollectionViewCell {
    // MARK: Properties
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    weak var delegate: FollowersFollowingCellDelegate?
    
    private var followUnfollowRemoveButtonState: FollowUnfollowRemoveButtonState? {
        didSet {
            guard let followUnfollowRemoveButtonState = followUnfollowRemoveButtonState else { return }
            
            switch followUnfollowRemoveButtonState {
            case .follow:
                followUnfollowRemoveButton.setTitle(ButtonTitles.follow, for: .normal)
            case .unfollow:
                followUnfollowRemoveButton.setTitle(ButtonTitles.unfollow, for: .normal)
            case .remove:
                followUnfollowRemoveButton.setTitle(ButtonTitles.remove, for: .normal)
            }
        }
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
        
        static let followUnfollowRemoveButtonWidth: CGFloat = 90
        static let followUnfollowRemoveButtonCornerRadius: CGFloat = 4
        static let followUnfollowRemoveButtonBorderWidth: CGFloat = 0.5
        static let followUnfollowRemoveButtonFont: CGFloat = 15
        static let followUnfollowRemoveButtonEdgeInset: CGFloat = 8
    }
    
    private enum ButtonTitles {
        static let follow = "Follow"
        static let unfollow = "Unfollow"
        static let remove = "Remove"
    }
    
    private enum Colors {
        static let profileImageViewBorder = UIColor.systemGray5
        static let unfollowRemoveButtonBorder = UIColor.lightGray
    }
    
    // MARK: Subviews
    
    private let profileImageView = UIImageView()
    private let followUnfollowRemoveButton = UIButton(type: .system)
    
    private let stackView = UIStackView()
    private let usernameLabel = UILabel()
    private let fullNameLabel = UILabel()
    
    // MARK: Lifecycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        profileImageDataTask?.cancel()
        profileImageView.image = nil
    }
    
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

extension FollowersFollowingCell {
    func configure(with user: User, userState: FollowUnfollowRemoveButtonState) {
        if let profileImageURL = user.profileImageURL {
            profileImageDataTask = profileImageView.download(urlString: profileImageURL)
        }
        
        usernameLabel.text = user.username
        fullNameLabel.text = user.fullName
        
        fullNameLabel.isHidden = (user.fullName == nil)
        
        followUnfollowRemoveButtonState = userState
    }
    
    func changeUserState(_ userState: FollowUnfollowRemoveButtonState) {
        followUnfollowRemoveButtonState = userState
    }
}

// MARK: - Appearance

private extension FollowersFollowingCell {
    func setupAppearance() {
        setupProfileImageViewAppearance()
        setupStackViewAppearance()
        setupFollowUnfollowRemoveButtonAppearance()
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
    
    func setupFollowUnfollowRemoveButtonAppearance() {
        followUnfollowRemoveButton.setTitleColor(.black, for: .normal)
        followUnfollowRemoveButton.titleLabel?.font = .boldSystemFont(ofSize: Metrics.followUnfollowRemoveButtonFont)
        followUnfollowRemoveButton.layer.cornerRadius = Metrics.followUnfollowRemoveButtonCornerRadius
        followUnfollowRemoveButton.layer.borderWidth = Metrics.followUnfollowRemoveButtonBorderWidth
        followUnfollowRemoveButton.layer.borderColor = Colors.unfollowRemoveButtonBorder.cgColor
        followUnfollowRemoveButton.contentEdgeInsets = UIEdgeInsets(
            top: Metrics.followUnfollowRemoveButtonEdgeInset - 2,
            left: Metrics.followUnfollowRemoveButtonEdgeInset,
            bottom: Metrics.followUnfollowRemoveButtonEdgeInset - 2,
            right: Metrics.followUnfollowRemoveButtonEdgeInset)
        
        followUnfollowRemoveButton.addTarget(
            self,
            action: #selector(didPressFollowUnfollowRemoveButton),
            for: .touchUpInside)
    }
    
    @objc func didPressFollowUnfollowRemoveButton() {
        guard let followUnfollowRemoveButtonState = followUnfollowRemoveButtonState else { return }
        
        switch followUnfollowRemoveButtonState {
        case .follow:
            delegate?.followersFollowingCellDidPressFollowButton(self)
        case .unfollow:
            delegate?.followersFollowingCellDidPressUnfollowButton(self)
        case .remove:
            delegate?.followersFollowingCellDidPressRemoveButton(self)
        }
    }
}

// MARK: - Layout

private extension FollowersFollowingCell {
    func setupLayout() {
        setupSubviews()
        
        setupProfileImageViewLayout()
        setupStackViewLayout()
        setupFollowUnfollowRemoveButtonLayout()
    }
    
    func setupSubviews() {
        contentView.addSubview(profileImageView)
        contentView.addSubview(stackView)
        contentView.addSubview(followUnfollowRemoveButton)
        
        stackView.addArrangedSubview(usernameLabel)
        stackView.addArrangedSubview(fullNameLabel)
    }
    
    func setupProfileImageViewLayout() {
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let profileImageViewBottomConstraint = profileImageView.bottomAnchor.constraint(
            equalTo: contentView.bottomAnchor,
            constant: -Metrics.profileImageViewVerticalSpace)
        
        profileImageViewBottomConstraint.priority = .defaultLow
        
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: Metrics.profileImageViewVerticalSpace),
            profileImageViewBottomConstraint,
            profileImageView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: Metrics.profileImageViewLeadingSpace),
            profileImageView.heightAnchor.constraint(equalToConstant: Metrics.profileImageViewSize),
            profileImageView.widthAnchor.constraint(equalToConstant: Metrics.profileImageViewSize),
        ])
    }
    
    func setupStackViewLayout() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(
                equalTo: profileImageView.trailingAnchor,
                constant: Metrics.stackViewLeadingSpace),
            stackView.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
        ])
    }
    
    func setupFollowUnfollowRemoveButtonLayout() {
        followUnfollowRemoveButton.translatesAutoresizingMaskIntoConstraints = false
        followUnfollowRemoveButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        NSLayoutConstraint.activate([
            followUnfollowRemoveButton.leadingAnchor.constraint(
                equalTo: stackView.trailingAnchor,
                constant: Metrics.stackViewLeadingSpace),
            followUnfollowRemoveButton.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -Metrics.profileImageViewLeadingSpace),
            followUnfollowRemoveButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            followUnfollowRemoveButton.widthAnchor.constraint(equalToConstant: Metrics.followUnfollowRemoveButtonWidth),
        ])
    }
}

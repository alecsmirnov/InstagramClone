//
//  UserFollowerCell.swift
//  Instagram
//
//  Created by Admin on 03.03.2021.
//

import UIKit

protocol FollowersFollowingCellDelegate: AnyObject {
    func followersFollowingCellDidTapFollowButton(_ followersFollowingCell: UserFollowerCell)
    func followersFollowingCellDidTapUnfollowButton(_ followersFollowingCell: UserFollowerCell)
    func followersFollowingCellDidTapRemoveButton(_ followersFollowingCell: UserFollowerCell)
}

final class UserFollowerCell: UICollectionViewCell {
    // MARK: Properties
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    weak var delegate: FollowersFollowingCellDelegate?
    
    var followUnfollowRemoveButtonState: FollowUnfollowRemoveButtonState = .none {
        didSet {
            switch followUnfollowRemoveButtonState {
            case .follow:
                activateFollowUnfollowRemoveButtonLayout()
                setupFollowButtonAppearance()
            case .unfollow:
                activateFollowUnfollowRemoveButtonLayout()
                setupUnfollowButtonAppearance()
            case .remove:
                activateFollowUnfollowRemoveButtonLayout()
                setupRemoveButtonAppearance()
            case .none:
                deactivateFollowUnfollowRemoveButtonLayout()
            }
        }
    }
    
    private var stackViewLeadingConstraint: NSLayoutConstraint?
    private var followUnfollowRemoveButtonConstraints = [NSLayoutConstraint]()
    
    private var profileImageDataTask: URLSessionDataTask?
    
    // MARK: Constants
    
    enum FollowUnfollowRemoveButtonState {
        case follow
        case unfollow
        case remove
        case none
    }
    
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupAppearance()
        setupLayout()
        setupButtonActions()
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

extension UserFollowerCell {
    func configureFollower(with user: User) {
        configure(with: user)
        
        followUnfollowRemoveButtonState = .remove
    }
    
    func configureFollowing(with user: User) {
        configure(with: user)
        
        followUnfollowRemoveButtonState = .unfollow
    }
    
    func configureUser(with user: User) {
        configure(with: user)
        
        guard let userKind = user.kind else { return }
        
        switch userKind {
        case .following:
            followUnfollowRemoveButtonState = .unfollow
        case .notFollowing:
            followUnfollowRemoveButtonState = .follow
        case .current:
            followUnfollowRemoveButtonState = .none
        }
    }
}

// MARK: - Private Methods

private extension UserFollowerCell {
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

private extension UserFollowerCell {
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
    
    func setupRemoveButtonAppearance() {
        followUnfollowRemoveButton.additionalStyle(title: "Remove", fontSize: Metrics.followUnfollowRemoveButtonFont)
    }
    
    func setupFollowButtonAppearance() {
        followUnfollowRemoveButton.mainStyle(title: "Follow", fontSize: Metrics.followUnfollowRemoveButtonFont)
    }
    
    func setupUnfollowButtonAppearance() {
        followUnfollowRemoveButton.additionalStyle(title: "Unfollow", fontSize: Metrics.followUnfollowRemoveButtonFont)
    }
}

// MARK: - Layout

private extension UserFollowerCell {
    func setupLayout() {
        setupSubviews()
        
        setupProfileImageViewLayout()
        setupStackViewLayout()
        prepareFollowUnfollowRemoveButtonLayout()
    }
    
    func setupSubviews() {
        contentView.addSubview(profileImageView)
        contentView.addSubview(stackView)
        
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
        
        stackViewLeadingConstraint = stackView.trailingAnchor.constraint(
            equalTo: contentView.trailingAnchor,
            constant: -Metrics.profileImageViewLeadingSpace)
        stackViewLeadingConstraint?.isActive = true
    }
    
    func prepareFollowUnfollowRemoveButtonLayout() {
        followUnfollowRemoveButton.translatesAutoresizingMaskIntoConstraints = false
        followUnfollowRemoveButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        followUnfollowRemoveButtonConstraints.append(contentsOf: [
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
    
    func activateFollowUnfollowRemoveButtonLayout() {
        stackViewLeadingConstraint?.isActive = false
        
        contentView.addSubview(followUnfollowRemoveButton)
        NSLayoutConstraint.activate(followUnfollowRemoveButtonConstraints)
    }
    
    func deactivateFollowUnfollowRemoveButtonLayout() {
        NSLayoutConstraint.deactivate(followUnfollowRemoveButtonConstraints)
        followUnfollowRemoveButton.removeFromSuperview()
        
        stackViewLeadingConstraint?.isActive = true
    }
}

// MARK: - Button Actions

private extension UserFollowerCell {
    func setupButtonActions() {
        followUnfollowRemoveButton.addTarget(
            self,
            action: #selector(didTapFollowUnfollowRemoveButton),
            for: .touchUpInside)
    }
    
    @objc func didTapFollowUnfollowRemoveButton() {
        switch followUnfollowRemoveButtonState {
        case .follow:
            delegate?.followersFollowingCellDidTapFollowButton(self)
        case .unfollow:
            delegate?.followersFollowingCellDidTapUnfollowButton(self)
        case .remove:
            delegate?.followersFollowingCellDidTapRemoveButton(self)
        case .none:
            break
        }
    }
}

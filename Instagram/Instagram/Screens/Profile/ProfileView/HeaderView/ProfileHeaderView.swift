//
//  ProfileHeaderView.swift
//  Instagram
//
//  Created by Admin on 21.01.2021.
//

import UIKit

protocol ProfileHeaderViewOutputProtocol: AnyObject {
    func didTapFollowersButton()
    func didTapFollowingButton()
    func didTapEditFollowButton()
    func didTapGridButton()
    func didTapBookmarkButton()
}

final class ProfileHeaderView: UICollectionReusableView {
    // MARK: Properties
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    weak var output: ProfileHeaderViewOutputProtocol?
    
    private var bioLabelTopConstraint: NSLayoutConstraint?
    private var websiteLabelTopConstraint: NSLayoutConstraint?
    private var separatorViewTopConstraint: NSLayoutConstraint?
    
    // MARK: Constants
    
    private enum Metrics {
        static let profileImageViewSize: CGFloat = AppConstants.Metrics.profileImageMediumSize
        static let profileImageViewBorderWidth: CGFloat = AppConstants.Metrics.profileImageBorderWidth
        
        static let profileInfoVerticalSpace: CGFloat = 16
        static let profileInfoHorizontalSpace: CGFloat = 18
        
        static let editFollowButtonFont: CGFloat = 15
        
        static let separatorViewWidth: CGFloat = 1
        static let bottomSeparatorViewBottomSpace: CGFloat = 1
        
        static let toolbarStackViewHeight: CGFloat = 44
        
        static let bioLabelTopSpace: CGFloat = 2
        static let websiteLabelTopSpace: CGFloat = 4
        
        static let userStatsCountersFontSize: CGFloat = 17
        static let userStatsTitlesFontSize: CGFloat = 15
        
        static let fullNameFontSize: CGFloat = 17
        static let bioFontSize: CGFloat = 16
        static let websiteFontSize: CGFloat = 16
    }
    
    private enum Images {
        static let grid = UIImage(systemName: "squareshape.split.3x3")
        static let bookmark = UIImage(systemName: "bookmark")
    }
    
    private enum Colors {
        static let profileImageViewBorder = AppConstants.Colors.profileImageBorder
        static let separatorViewBackground = AppConstants.Colors.separatorViewBackground
        
        static let userStatsStackViewTitle = UIColor.systemGray
        
        static let toolbarStackViewButtonTint = UIColor(white: 0, alpha: 0.4)
    }
    
    // MARK: Subviews
    
    private let profileImageView = UIImageView()
    
    private let userStatsStackView = UIStackView()
    private let postsButton = UIButton(type: .custom)
    private let followersButton = UIButton(type: .custom)
    private let followingButton = UIButton(type: .custom)
    
    private let editFollowButton = UIButton(type: .system)
    
    private let fullNameLabel = UILabel()
    private let bioLabel = UILabel()
    private let websiteLabel = UILabel()
    
    private let separatorView = UIView()
    
    private let toolbarStackView = UIStackView()
    private let gridButton = UIButton(type: .system)
    private let bookmarkButton = UIButton(type: .system)
    
    private let bottomSeparatorView = UIView()
    
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
}

// MARK: - Public Methods

extension ProfileHeaderView {
    func setUser(_ user: User) {
        fullNameLabel.text = user.fullName
        bioLabel.text = user.bio
        websiteLabel.text = user.website
        
        bioLabelTopConstraint?.constant = (user.bio == nil) ? 0 : Metrics.bioLabelTopSpace
        websiteLabelTopConstraint?.constant = (user.website == nil) ? 0 : Metrics.websiteLabelTopSpace
        
        if user.fullName != nil || user.bio != nil || user.website != nil {
            separatorViewTopConstraint?.constant = Metrics.profileInfoVerticalSpace
        } else {
            separatorViewTopConstraint?.constant = 0
        }
        
        if let profileImageURL = user.profileImageURL {
            profileImageView.download(urlString: profileImageURL)
        }
    }
    
    func setUserStats(_ userStats: UserStats) {
        setPostsButtonTitle(count: userStats.posts)
        setFollowersButtonTitle(count: userStats.followers)
        setFollowingButtonTitle(count: userStats.following)
    }
    
    func setupEditFollowButtonEditStyle() {
        editFollowButton.additionalStyle(title: "Edit Profile", fontSize: Metrics.editFollowButtonFont)
    }
    
    func setupEditFollowButtonFollowStyle() {
        editFollowButton.mainStyle(title: "Follow", fontSize: Metrics.editFollowButtonFont)
    }
    
    func setupEditFollowButtonUnfollowStyle() {
        editFollowButton.additionalStyle(title: "Unfollow", fontSize: Metrics.editFollowButtonFont)
    }
}

// MARK: - Appearance

private extension ProfileHeaderView {
    func setupAppearance() {
        setupProfileImageViewAppearance()
        setupUserStatsStackViewAppearance()
        setupPostsButtonAppearance()
        setupFollowersButtonAppearance()
        setupFollowingButtonAppearance()
        setupEditFollowButtonAppearance()
        setupFullNameLabelAppearance()
        setupBioLabelAppearance()
        setupWebsiteLabelAppearance()
        setupSeparatorsViewAppearance()
        setupToolbarStackViewAppearance()
        setupGridButtonAppearance()
        setupBookmarkButtonAppearance()
    }
    
    func setupProfileImageViewAppearance() {
        profileImageView.layer.cornerRadius = Metrics.profileImageViewSize / 2
        profileImageView.layer.masksToBounds = true
        profileImageView.layer.borderColor = Colors.profileImageViewBorder.cgColor
        profileImageView.layer.borderWidth = Metrics.profileImageViewBorderWidth
    }
    
    func setupUserStatsStackViewAppearance() {
        userStatsStackView.axis = .horizontal
        userStatsStackView.distribution = .fillEqually
    }
    
    func setupPostsButtonAppearance() {
        postsButton.titleLabel?.textAlignment = .center
        postsButton.titleLabel?.numberOfLines = 2
        postsButton.isUserInteractionEnabled = false
        
        setPostsButtonTitle(count: 0)
    }
    
    func setupFollowersButtonAppearance() {
        followersButton.titleLabel?.textAlignment = .center
        followersButton.titleLabel?.numberOfLines = 2
        
        setFollowersButtonTitle(count: 0)
    }
    
    func setupFollowingButtonAppearance() {
        followingButton.titleLabel?.textAlignment = .center
        followingButton.titleLabel?.numberOfLines = 2
        
        setFollowingButtonTitle(count: 0)
    }
    
    func setupEditFollowButtonAppearance() {
        editFollowButton.additionalStyle(title: "", fontSize: Metrics.editFollowButtonFont)
    }
    
    func setupFullNameLabelAppearance() {
        fullNameLabel.font = .boldSystemFont(ofSize: Metrics.fullNameFontSize)
    }
    
    func setupBioLabelAppearance() {
        bioLabel.font = .systemFont(ofSize: Metrics.bioFontSize)
        bioLabel.numberOfLines = 0
    }
    
    func setupWebsiteLabelAppearance() {
        websiteLabel.font = .systemFont(ofSize: Metrics.websiteFontSize)
        websiteLabel.textColor = .link
    }
    
    func setupSeparatorsViewAppearance() {
        separatorView.backgroundColor = Colors.separatorViewBackground
        bottomSeparatorView.backgroundColor = Colors.separatorViewBackground
    }
    
    func setupToolbarStackViewAppearance() {
        toolbarStackView.axis = .horizontal
        toolbarStackView.distribution = .fillEqually
    }
    
    func setupGridButtonAppearance() {
        gridButton.setImage(Images.grid, for: .normal)
        gridButton.tintColor = .black
    }
    
    func setupBookmarkButtonAppearance() {
        bookmarkButton.setImage(Images.bookmark, for: .normal)
        bookmarkButton.tintColor = Colors.toolbarStackViewButtonTint
    }
}

// MARK: - Appearance Helpers

private extension ProfileHeaderView {
    func setPostsButtonTitle(count: Int) {
        setUserStatsButtonAppearance(postsButton, count: count, text: "posts")
    }
    
    func setFollowersButtonTitle(count: Int) {
        setUserStatsButtonAppearance(followersButton, count: count, text: "followers")
    }
    
    func setFollowingButtonTitle(count: Int) {
        setUserStatsButtonAppearance(followingButton, count: count, text: "following")
    }
    
    func setUserStatsButtonAppearance(_ button: UIButton, count: Int, text: String) {
        button.twoPartTitle(
            firstPartText: String(count),
            firstPartFont: .boldSystemFont(ofSize: Metrics.userStatsCountersFontSize),
            firstPartColor: .black,
            secondPartText: text,
            secondPartFont: .systemFont(ofSize: Metrics.userStatsTitlesFontSize),
            secondPartColor: Colors.userStatsStackViewTitle,
            partDivider: "\n")
    }
}

// MARK: - Layout

private extension ProfileHeaderView {
    func setupLayout() {
        setupSubviews()
        
        setupProfileImageViewLayout()
        setupUserStatsStackViewLayout()
        setupEditFollowButtonLayout()
        setupFullNameLabelLayout()
        setupBioLabelLayout()
        setupWebsiteLabelLayout()
        setupSeparatorViewLayout()
        setupToolbarStackViewLayout()
        setupBottomSeparatorViewLayout()
    }
    
    func setupSubviews() {
        addSubview(profileImageView)
        addSubview(userStatsStackView)
        addSubview(editFollowButton)
        addSubview(fullNameLabel)
        addSubview(bioLabel)
        addSubview(websiteLabel)
        addSubview(separatorView)
        addSubview(toolbarStackView)
        addSubview(bottomSeparatorView)
        
        userStatsStackView.addArrangedSubview(postsButton)
        userStatsStackView.addArrangedSubview(followersButton)
        userStatsStackView.addArrangedSubview(followingButton)
        
        toolbarStackView.addArrangedSubview(gridButton)
        toolbarStackView.addArrangedSubview(bookmarkButton)
    }
    
    func setupProfileImageViewLayout() {
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(
                equalTo: safeAreaLayoutGuide.topAnchor,
                constant: Metrics.profileInfoVerticalSpace),
            profileImageView.leadingAnchor.constraint(
                equalTo: safeAreaLayoutGuide.leadingAnchor,
                constant: Metrics.profileInfoHorizontalSpace),
            profileImageView.heightAnchor.constraint(equalToConstant: Metrics.profileImageViewSize),
            profileImageView.widthAnchor.constraint(equalToConstant: Metrics.profileImageViewSize),
        ])
    }
    
    func setupUserStatsStackViewLayout() {
        userStatsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            userStatsStackView.topAnchor.constraint(equalTo: profileImageView.topAnchor),
            userStatsStackView.leadingAnchor.constraint(
                equalTo: profileImageView.trailingAnchor,
                constant: Metrics.profileInfoHorizontalSpace),
            userStatsStackView.trailingAnchor.constraint(
                equalTo: safeAreaLayoutGuide.trailingAnchor,
                constant: -Metrics.profileInfoHorizontalSpace),
        ])
    }
    
    func setupEditFollowButtonLayout() {
        editFollowButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            editFollowButton.topAnchor.constraint(equalTo: userStatsStackView.bottomAnchor),
            editFollowButton.bottomAnchor.constraint(equalTo: profileImageView.bottomAnchor),
            editFollowButton.leadingAnchor.constraint(equalTo: userStatsStackView.leadingAnchor),
            editFollowButton.trailingAnchor.constraint(equalTo: userStatsStackView.trailingAnchor),
        ])
    }
    
    func setupFullNameLabelLayout() {
        fullNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            fullNameLabel.topAnchor.constraint(
                equalTo: profileImageView.bottomAnchor,
                constant: Metrics.profileInfoVerticalSpace),
            fullNameLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor),
            fullNameLabel.trailingAnchor.constraint(equalTo: editFollowButton.trailingAnchor),
        ])
    }
    
    func setupBioLabelLayout() {
        bioLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            bioLabel.leadingAnchor.constraint(equalTo: fullNameLabel.leadingAnchor),
            bioLabel.trailingAnchor.constraint(equalTo: fullNameLabel.trailingAnchor),
        ])
        
        bioLabelTopConstraint = bioLabel.topAnchor.constraint(equalTo: fullNameLabel.bottomAnchor)
        bioLabelTopConstraint?.isActive = true
    }
    
    func setupWebsiteLabelLayout() {
        websiteLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            websiteLabel.leadingAnchor.constraint(equalTo: fullNameLabel.leadingAnchor),
            websiteLabel.trailingAnchor.constraint(equalTo: fullNameLabel.trailingAnchor),
        ])
        
        websiteLabelTopConstraint = websiteLabel.topAnchor.constraint(equalTo: bioLabel.bottomAnchor)
        websiteLabelTopConstraint?.isActive = true
    }
    
    func setupSeparatorViewLayout() {
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            separatorView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: Metrics.separatorViewWidth),
        ])
        
        separatorViewTopConstraint = separatorView.topAnchor.constraint(equalTo: websiteLabel.bottomAnchor)
        separatorViewTopConstraint?.isActive = true
    }
    
    func setupToolbarStackViewLayout() {
        toolbarStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            toolbarStackView.topAnchor.constraint(equalTo: separatorView.bottomAnchor),
            toolbarStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            toolbarStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            toolbarStackView.heightAnchor.constraint(equalToConstant: Metrics.toolbarStackViewHeight),
        ])
    }
    
    func setupBottomSeparatorViewLayout() {
        bottomSeparatorView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            bottomSeparatorView.topAnchor.constraint(equalTo: toolbarStackView.bottomAnchor),
            bottomSeparatorView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            bottomSeparatorView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            bottomSeparatorView.heightAnchor.constraint(equalToConstant: Metrics.separatorViewWidth),
        ])
        
        let bottomConstraint = bottomSeparatorView.bottomAnchor.constraint(
            equalTo: safeAreaLayoutGuide.bottomAnchor,
            constant: -Metrics.bottomSeparatorViewBottomSpace)
        
        bottomConstraint.priority = .defaultLow
        bottomConstraint.isActive = true
    }
}

// MARK: - Button Actions

private extension ProfileHeaderView {
    func setupButtonActions() {
        followersButton.addTarget(self, action: #selector(didTapFollowersButton), for: .touchUpInside)
        followingButton.addTarget(self, action: #selector(didTapFollowingButton), for: .touchUpInside)
        editFollowButton.addTarget(self, action: #selector(didTapEditFollowButton), for: .touchUpInside)
        gridButton.addTarget(self, action: #selector(didTapGridButton), for: .touchUpInside)
        bookmarkButton.addTarget(self, action: #selector(didTapBookmarkButton), for: .touchUpInside)
    }
    
    @objc func didTapFollowersButton() {
        output?.didTapFollowersButton()
    }
    
    @objc func didTapFollowingButton() {
        output?.didTapFollowingButton()
    }
    
    @objc func didTapEditFollowButton() {
        output?.didTapEditFollowButton()
    }
    
    @objc func didTapGridButton() {
        gridButton.tintColor = .black
        bookmarkButton.tintColor = Colors.toolbarStackViewButtonTint
        
        output?.didTapGridButton()
    }

    @objc func didTapBookmarkButton() {
        bookmarkButton.tintColor = .black
        gridButton.tintColor = Colors.toolbarStackViewButtonTint
        
        output?.didTapBookmarkButton()
    }
}

//
//  ProfileHeaderView.swift
//  Instagram
//
//  Created by Admin on 21.01.2021.
//

import UIKit

protocol ProfileHeaderViewDelegate: AnyObject {
    func profileHeaderViewDidPressFollowersButton(_ view: ProfileHeaderView)
    func profileHeaderViewDidPressFollowingButton(_ view: ProfileHeaderView)
    func profileHeaderViewD(
        _ view: ProfileHeaderView,
        didPressEditFollowButtonWith status: ProfileHeaderView.EditFollowButtonStatus)
}

final class ProfileHeaderView: UICollectionReusableView {
    // MARK: Properties
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    weak var delegate: ProfileHeaderViewDelegate?
    
    var isCurrentUserProfile: Bool = true {
        didSet {
            
        }
    }
    
    private var isFollower = false
    
    // MARK: Constants
    
    enum EditFollowButtonStatus {
        case edit
        case follow
        case unfollow
    }
    
    private enum Metrics {
        static let profileInfoVerticalSpace: CGFloat = 16
        static let profileInfoHorizontalSpace: CGFloat = 12
        
        static let profileImageViewSize: CGFloat = 80
        static let profileImageViewBorderWidth: CGFloat = 1
        
        static let editFollowButtonCornerRadius: CGFloat = 4
        static let editFollowButtonBorderWidth: CGFloat = 0.5
        static let editFollowButtonFont: CGFloat = 15
        
        static let separatorViewWidth: CGFloat = 0.6
        
        static let toolbarStackViewHeight: CGFloat = 44
        
        static let bioTopInset: CGFloat = 2
        static let websiteTopInset: CGFloat = 4
        
        static let fullNameFontSize: CGFloat = 17
        static let bioFontSize: CGFloat = 16
        static let websiteFontSize: CGFloat = 16
    }
    
    private enum UserStatsStackViewTitles {
        static let posts = "posts"
        static let followers = "followers"
        static let following = "following"
    }
    
    private enum EditFollowButtonTitles {
        static let edit = "Edit Profile"
        static let follow = "Follow"
        static let unfollow = "Unfollow"
    }
    
    private enum ToolbarStackViewImages {
        static let grid = UIImage(systemName: "squareshape.split.3x3")
        static let list = UIImage(systemName: "list.dash")
        static let bookmark = UIImage(systemName: "bookmark")
    }
    
    private enum Colors {
        static let profileImageViewBorder = UIColor.lightGray
        static let userStatsStackViewTitle = UIColor.systemGray
        static let editFollowButtonBorder = UIColor.lightGray
        static let separatorView = UIColor.lightGray
        static let toolbarStackViewButtonTint = UIColor(white: 0, alpha: 0.4)
    }
    
    // MARK: Subviews
    
    private let profileImageView = UIImageView()
    
    private let userStatsStackView = UIStackView()
    private let postsButton = TwoPartsButton()
    private let followersButton = TwoPartsButton()
    private let followingButton = TwoPartsButton()
    
    private let editFollowButton = UIButton(type: .system)
    
    private let userInfoStackView = UIStackView()
    private let fullNameLabel = UILabel()
    private let bioTextView = SelfSizedTextView()
    private let websiteTextView = SelfSizedTextView()
    
    private let separatorView = UIView()
    
    private let toolbarStackView = UIStackView()
    private let gridButton = UIButton(type: .system)
    private let listButton = UIButton(type: .system)
    private let bookmarkButton = UIButton(type: .system)
    
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

extension ProfileHeaderView {
    func setUser(_ user: User) {
        fullNameLabel.text = user.fullName
        
        if let profileImageURL = user.profileImageURL {
            profileImageView.download(urlString: profileImageURL)
        }
    }
}

// MARK: - Appearance

private extension ProfileHeaderView {
    func setupAppearance() {
        setupProfileImageViewAppearance()
        setupUserStatsStackViewAppearance()
        setupEditFollowButtonAppearance()
        
        setupUserInfoStackViewAppearance()
        setupFullNameLabelAppearance()
        setupBioTextViewAppearance()
        setupWebsiteTextViewAppearance()
        
        setupSeparatorViewAppearance()
        
        setupToolbarStackViewAppearance()
        setupGridButtonAppearance()
        setupListButtonAppearance()
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
        
        postsButton.secondPartColor = Colors.userStatsStackViewTitle
        followersButton.secondPartColor = Colors.userStatsStackViewTitle
        followingButton.secondPartColor = Colors.userStatsStackViewTitle

        postsButton.secondPartText = UserStatsStackViewTitles.posts
        followersButton.secondPartText = UserStatsStackViewTitles.followers
        followingButton.secondPartText = UserStatsStackViewTitles.following
        
        postsButton.firstPartFont = .boldSystemFont(ofSize: 16)
        followersButton.firstPartFont = .boldSystemFont(ofSize: 16)
        followingButton.firstPartFont = .boldSystemFont(ofSize: 16)
        
        postsButton.titleLabel?.textAlignment = .center
        followersButton.titleLabel?.textAlignment = .center
        followingButton.titleLabel?.textAlignment = .center
        
        postsButton.titleLabel?.numberOfLines = 2
        followersButton.titleLabel?.numberOfLines = 2
        followingButton.titleLabel?.numberOfLines = 2
        
        postsButton.divider = "\n"
        followersButton.divider = "\n"
        followingButton.divider = "\n"
        
        // TEMP
        
        postsButton.firstPartText = "0"
        followersButton.firstPartText = "0"
        followingButton.firstPartText = "0"
    }
    
    func setupEditFollowButtonAppearance() {
        editFollowButton.setTitle(EditFollowButtonTitles.edit, for: .normal)
        editFollowButton.setTitleColor(.black, for: .normal)
        editFollowButton.titleLabel?.font = .boldSystemFont(ofSize: Metrics.editFollowButtonFont)
        //editFollowButton.backgroundColor = .blue
        editFollowButton.layer.cornerRadius = Metrics.editFollowButtonCornerRadius
        editFollowButton.layer.borderWidth = Metrics.editFollowButtonBorderWidth
        editFollowButton.layer.borderColor = Colors.editFollowButtonBorder.cgColor
    }
    
    func setupUserInfoStackViewAppearance() {
        userInfoStackView.axis = .vertical
    }
    
    func setupFullNameLabelAppearance() {
        fullNameLabel.text = "test user"
        fullNameLabel.font = .boldSystemFont(ofSize: Metrics.fullNameFontSize)
    }
    
    func setupBioTextViewAppearance() {
        //bioTextView.text = "shoop da whoop\nahahaahahahaaha\naaaaaaaaaaaaaaaaaaaaaaaaaa"
        bioTextView.textContainerInset = UIEdgeInsets(top: Metrics.bioTopInset, left: 0, bottom: 0, right: 0)
        bioTextView.font = .systemFont(ofSize: Metrics.bioFontSize)
        bioTextView.dataDetectorTypes = .all
    }
    
    func setupWebsiteTextViewAppearance() {
        websiteTextView.text = "http://google.com/"
        websiteTextView.textContainerInset = UIEdgeInsets(top: Metrics.websiteTopInset, left: 0, bottom: 0, right: 0)
        websiteTextView.font = .systemFont(ofSize: Metrics.websiteFontSize)
        websiteTextView.dataDetectorTypes = .link
        websiteTextView.isUserInteractionEnabled = true
        websiteTextView.isSelectable = true
    }
    
    func setupSeparatorViewAppearance() {
        separatorView.backgroundColor = Colors.separatorView
    }
    
    func setupToolbarStackViewAppearance() {
        toolbarStackView.axis = .horizontal
        toolbarStackView.distribution = .fillEqually
    }
    
    func setupGridButtonAppearance() {
        gridButton.setImage(ToolbarStackViewImages.grid, for: .normal)
        gridButton.tintColor = Colors.toolbarStackViewButtonTint
    }
    
    func setupListButtonAppearance() {
        listButton.setImage(ToolbarStackViewImages.list, for: .normal)
        listButton.tintColor = Colors.toolbarStackViewButtonTint
    }
    
    func setupBookmarkButtonAppearance() {
        bookmarkButton.setImage(ToolbarStackViewImages.bookmark, for: .normal)
        bookmarkButton.tintColor = Colors.toolbarStackViewButtonTint
    }
}

// MARK: - Layout

private extension ProfileHeaderView {
    func setupLayout() {
        setupSubviews()
        
        setupProfileImageViewLayout()
        setupUserStatsStackViewLayout()
        setupEditFollowButtonLayout()
        setupUserInfoStackViewLayout()
        setupSeparatorViewLayout()
        setupToolbarStackViewLayout()
    }
    
    func setupSubviews() {
        addSubview(profileImageView)
        addSubview(userStatsStackView)
        addSubview(editFollowButton)
        addSubview(userInfoStackView)
        addSubview(separatorView)
        addSubview(toolbarStackView)
        
        userStatsStackView.addArrangedSubview(postsButton)
        userStatsStackView.addArrangedSubview(followersButton)
        userStatsStackView.addArrangedSubview(followingButton)
        
        userInfoStackView.addArrangedSubview(fullNameLabel)
        userInfoStackView.addArrangedSubview(bioTextView)
        userInfoStackView.addArrangedSubview(websiteTextView)
        
        toolbarStackView.addArrangedSubview(gridButton)
        toolbarStackView.addArrangedSubview(listButton)
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
    
    func setupUserInfoStackViewLayout() {
        userInfoStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            userInfoStackView.topAnchor.constraint(
                equalTo: profileImageView.bottomAnchor,
                constant: Metrics.profileInfoVerticalSpace),
            userInfoStackView.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor),
            userInfoStackView.trailingAnchor.constraint(equalTo: editFollowButton.trailingAnchor),
        ])
    }
    
    func setupSeparatorViewLayout() {
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            separatorView.topAnchor.constraint(
                equalTo: userInfoStackView.bottomAnchor,
                constant: Metrics.profileInfoVerticalSpace),
            separatorView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: Metrics.separatorViewWidth),
        ])
    }
    
    func setupToolbarStackViewLayout() {
        toolbarStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            toolbarStackView.topAnchor.constraint(equalTo: separatorView.bottomAnchor),
            toolbarStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            toolbarStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            toolbarStackView.heightAnchor.constraint(equalToConstant: Metrics.toolbarStackViewHeight),
        ])
        
        let bottomConstraint = toolbarStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        
        bottomConstraint.priority = UILayoutPriority(750)
        bottomConstraint.isActive = true
    }
}

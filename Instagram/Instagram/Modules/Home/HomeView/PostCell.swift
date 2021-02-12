//
//  PostCell.swift
//  Instagram
//
//  Created by Admin on 09.02.2021.
//

import UIKit

final class PostCell: UICollectionViewCell {
    // MARK: Properties
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    private var imageDataTask: URLSessionDataTask?
    
    private var imageViewHeightConstraint: NSLayoutConstraint?
    
    // MARK: Constants
    
    private enum Metrics {
        static let profileImageButtonSize: CGFloat = 36
        static let profileImageButtonTopSpace: CGFloat = 16
        static let profileImageButtonBottomSpace: CGFloat = 14
        static let profileImageButtonLeadingSpace: CGFloat = 16
        static let profileImageButtonTrailingSpace: CGFloat = 14
        
        static let buttonsViewTopSpace: CGFloat = 14
        static let buttonsViewBottomSpace: CGFloat = 10
        static let buttonsViewItemsSpace: CGFloat = 12
    }
    
    private enum Images {
        static let options = UIImage(systemName: "ellipsis")
        static let like = UIImage(systemName: "heart")
        static let comment = UIImage(systemName: "bubble.right")
        static let send = UIImage(systemName: "paperplane")
        static let bookmark = UIImage(systemName: "bookmark")
    }
    
    // MARK: Subviews
    
    private let headerView = UIView()
    private let profileImageButton = UIButton(type: .system)
    private let usernameButton = UIButton(type: .system)
    private let optionsButton = UIButton(type: .system)
    
    private let imageView = UIImageView()
    
    private let buttonsView = UIView()
    private let likeButton = UIButton(type: .system)
    private let commentButton = UIButton(type: .system)
    private let sendButton = UIButton(type: .system)
    private let bookmarkButton = UIButton(type: .system)
    
    private let captionLabel = ReadMoreLabel()
    
    private let timestampLabel = UILabel()
    
    // MARK: Lifecycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageDataTask?.cancel()
        imageView.image = nil
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

extension PostCell {
    func configure(with post: Post) {
        imageDataTask = imageView.download(urlString: post.imageURL)
        
        captionLabel.text = post.caption
        timestampLabel.text = Date(timeIntervalSince1970: post.timestamp).description
        
        // TODO: Get aspect ratio from image download completion
        // TODO: Hide cell until image is loaded
        
        configureImageViewHeight(aspectRatio: post.imageAspectRatio)
    }
    
    func configure(with user: User) {
        
    }
}

// MARK: - Appearance

private extension PostCell {
    func setupAppearance() {
        setupProfileImageButtonAppearance()
        setupUsernameButtonAppearance()
        setupOptionsButtonAppearance()
        
        setupImageViewAppearance()
        
        setupButtonsViewItemsAppearance()
        
        setupTimestampLabelAppearance()
//        setupLikeButtonAppearance()
//        setupCommentButtonAppearance()
//        setupSendButtonAppearance()
//        setupBookmarkButtonAppearance()
    }
    
    func setupProfileImageButtonAppearance() {
        profileImageButton.layer.cornerRadius = Metrics.profileImageButtonSize / 2
        profileImageButton.layer.masksToBounds = true
        
        profileImageButton.layer.borderWidth = 1
        profileImageButton.layer.borderColor = UIColor.systemGray4.cgColor
    }
    
    func setupUsernameButtonAppearance() {
        usernameButton.setTitle("username", for: .normal)
        usernameButton.setTitleColor(.black, for: .normal)
        usernameButton.titleLabel?.font = .boldSystemFont(ofSize: usernameButton.titleLabel?.font.pointSize ?? 0)
    }
    
    func setupOptionsButtonAppearance() {
        optionsButton.setImage(Images.options?.withRenderingMode(.alwaysOriginal), for: .normal)
    }
    
    func setupImageViewAppearance() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
    }
    
    func setupButtonsViewItemsAppearance() {
        likeButton.setImage(Images.like?.withRenderingMode(.alwaysOriginal), for: .normal)
        commentButton.setImage(Images.comment?.withRenderingMode(.alwaysOriginal), for: .normal)
        sendButton.setImage(Images.send?.withRenderingMode(.alwaysOriginal), for: .normal)
        bookmarkButton.setImage(Images.bookmark?.withRenderingMode(.alwaysOriginal), for: .normal)
    }
    
    func setupTimestampLabelAppearance() {
        timestampLabel.textColor = .systemGray
    }
    
//    func setupLikeButtonAppearance() {
//        likeButton.setImage(Images.like?.withRenderingMode(.alwaysOriginal), for: .normal)
//    }
//
//    func setupCommentButtonAppearance() {
//        commentButton.setImage(Images.comment?.withRenderingMode(.alwaysOriginal), for: .normal)
//    }
//
//    func setupSendButtonAppearance() {
//        sendButton.setImage(Images.send?.withRenderingMode(.alwaysOriginal), for: .normal)
//    }
//
//    func setupBookmarkButtonAppearance() {
//        bookmarkButton.setImage(Images.bookmark?.withRenderingMode(.alwaysOriginal), for: .normal)
//    }
}

// MARK: - Layout

private extension PostCell {
    func setupLayout() {
        setupSubviews()
        
        setupHeaderViewLayout()
        setupProfileImageButtonLayout()
        setupUsernameButtonLayout()
        setupOptionsButtonLayout()
        
        setupImageViewLayout()
        
        setupButtonsViewLayout()
        setupLikeButtonLayout()
        setupCommentButtonLayout()
        setupSendButtonLayout()
        setupBookmarkButtonLayout()
        
        setupCaptionLabelLayout()
        
        setupTimestampLabelLayout()
    }
    
    func setupSubviews() {
        contentView.addSubview(headerView)
        contentView.addSubview(imageView)
        contentView.addSubview(buttonsView)
        contentView.addSubview(captionLabel)
        contentView.addSubview(timestampLabel)
        
        headerView.addSubview(profileImageButton)
        headerView.addSubview(usernameButton)
        headerView.addSubview(optionsButton)
        
        buttonsView.addSubview(likeButton)
        buttonsView.addSubview(commentButton)
        buttonsView.addSubview(sendButton)
        buttonsView.addSubview(bookmarkButton)
    }
    
    func setupHeaderViewLayout() {
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
    
    func setupProfileImageButtonLayout() {
        profileImageButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            profileImageButton.topAnchor.constraint(
                equalTo: headerView.topAnchor,
                constant: Metrics.profileImageButtonTopSpace),
            profileImageButton.bottomAnchor.constraint(
                equalTo: headerView.bottomAnchor,
                constant: -Metrics.profileImageButtonBottomSpace),
            profileImageButton.leadingAnchor.constraint(
                equalTo: headerView.leadingAnchor,
                constant: Metrics.profileImageButtonLeadingSpace),
            profileImageButton.heightAnchor.constraint(equalToConstant: Metrics.profileImageButtonSize),
            profileImageButton.widthAnchor.constraint(equalToConstant: Metrics.profileImageButtonSize),
        ])
    }
    
    func setupUsernameButtonLayout() {
        usernameButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            usernameButton.centerYAnchor.constraint(equalTo: profileImageButton.centerYAnchor),
            usernameButton.leadingAnchor.constraint(
                equalTo: profileImageButton.trailingAnchor,
                constant: Metrics.profileImageButtonTrailingSpace),
        ])
    }
    
    func setupOptionsButtonLayout() {
        optionsButton.translatesAutoresizingMaskIntoConstraints = false
        optionsButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        NSLayoutConstraint.activate([
            optionsButton.centerYAnchor.constraint(equalTo: usernameButton.centerYAnchor),
            optionsButton.leadingAnchor.constraint(
                greaterThanOrEqualTo: usernameButton.trailingAnchor,
                constant: Metrics.profileImageButtonTrailingSpace),
            optionsButton.trailingAnchor.constraint(
                equalTo: headerView.trailingAnchor,
                constant: -Metrics.profileImageButtonLeadingSpace),
        ])
    }
    
    func setupImageViewLayout() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let imageViewTopConstraint = imageView.topAnchor.constraint(equalTo: headerView.bottomAnchor)
        let imageViewBottomConstraint = imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        
        imageViewTopConstraint.priority = .defaultLow
        imageViewBottomConstraint.priority = .defaultLow
        
        NSLayoutConstraint.activate([
            imageViewTopConstraint,
            imageViewBottomConstraint,
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.widthAnchor.constraint(equalToConstant: bounds.width),
        ])
    }
    
    func configureImageViewHeight(aspectRatio: CGFloat) {
        imageViewHeightConstraint?.isActive = false
        
        imageViewHeightConstraint = imageView.heightAnchor.constraint(
            equalTo: imageView.widthAnchor,
            multiplier: 1 / aspectRatio)
        
        imageViewHeightConstraint?.isActive = true
        
        contentView.layoutIfNeeded()
    }
    
    func setupButtonsViewLayout() {
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            buttonsView.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            buttonsView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            buttonsView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
    
    func setupLikeButtonLayout() {
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            likeButton.topAnchor.constraint(equalTo: buttonsView.topAnchor, constant: Metrics.buttonsViewTopSpace),
            likeButton.bottomAnchor.constraint(
                equalTo: buttonsView.bottomAnchor,
                constant: -Metrics.buttonsViewBottomSpace),
            likeButton.leadingAnchor.constraint(equalTo: profileImageButton.leadingAnchor),
        ])
    }
    
    func setupCommentButtonLayout() {
        commentButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            commentButton.leadingAnchor.constraint(
                equalTo: likeButton.trailingAnchor,
                constant: Metrics.buttonsViewItemsSpace),
            commentButton.centerYAnchor.constraint(equalTo: likeButton.centerYAnchor),
        ])
    }
    
    func setupSendButtonLayout() {
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            sendButton.leadingAnchor.constraint(
                equalTo: commentButton.trailingAnchor,
                constant: Metrics.buttonsViewItemsSpace),
            sendButton.centerYAnchor.constraint(equalTo: commentButton.centerYAnchor),
        ])
    }
    
    func setupBookmarkButtonLayout() {
        bookmarkButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            bookmarkButton.trailingAnchor.constraint(equalTo: optionsButton.trailingAnchor),
            bookmarkButton.centerYAnchor.constraint(equalTo: sendButton.centerYAnchor),
        ])
    }
    
    func setupCaptionLabelLayout() {
        captionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            captionLabel.topAnchor.constraint(equalTo: buttonsView.bottomAnchor, constant: 0),
            captionLabel.leadingAnchor.constraint(equalTo: profileImageButton.leadingAnchor),
            captionLabel.trailingAnchor.constraint(equalTo: optionsButton.leadingAnchor),
        ])
    }
    
    func setupTimestampLabelLayout() {
        timestampLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            timestampLabel.topAnchor.constraint(equalTo: captionLabel.bottomAnchor, constant: 14),
            timestampLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -22),
            timestampLabel.leadingAnchor.constraint(equalTo: profileImageButton.leadingAnchor),
            timestampLabel.trailingAnchor.constraint(equalTo: optionsButton.trailingAnchor),
        ])
    }
}

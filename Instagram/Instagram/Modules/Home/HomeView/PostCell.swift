//
//  PostCell.swift
//  Instagram
//
//  Created by Admin on 09.02.2021.
//

import UIKit

protocol PostCellDelegate: AnyObject {
    func postCellDidPressProfileImageButton(_ postCell: PostCell)
    func postCellDidPressOptionsButton(_ postCell: PostCell)
    
    func postCellDidPressLikeButton(_ postCell: PostCell)
    func postCellDidPressUnlikeButton(_ postCell: PostCell)
    func postCellDidPressCommentButton(_ postCell: PostCell)
    func postCellDidPressSendButton(_ postCell: PostCell)
    func postCellDidPressBookmarkButton(_ postCell: PostCell)
    func postCellDidPressNotBookmarkButton(_ postCell: PostCell)
}

final class PostCell: UICollectionViewCell {
    // MARK: Properties
    
    weak var delegate: PostCellDelegate?
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    var isLiked = false {
        didSet {
            if isLiked {
                setupUnlikeButton()
            } else {
                setupLikeButton()
            }
        }
    }
    
    var isBookmarked = false {
        didSet {
            if isBookmarked {
                bookmarkButton.setImage(Images.notBookmarked, for: .normal)
            } else {
                bookmarkButton.setImage(Images.bookmarked?.withRenderingMode(.alwaysOriginal), for: .normal)
            }
        }
    }
    
    private var profileImageDataTask: URLSessionDataTask?
    private var imageDataTask: URLSessionDataTask?
    
    private var imageViewHeightConstraint: NSLayoutConstraint?
    private var captionLabelTopConstraint: NSLayoutConstraint?
    private var timestampLabelTopConstraint: NSLayoutConstraint?
    
    // MARK: Constants
    
    private enum Metrics {
        static let profileImageButtonSize: CGFloat = 36
        static let profileImageButtonBorderWidth: CGFloat = 1
        
        static let profileImageButtonTopSpace: CGFloat = 16
        static let profileImageButtonBottomSpace: CGFloat = 14
        static let profileImageButtonLeadingSpace: CGFloat = 16
        static let profileImageButtonTrailingSpace: CGFloat = 14
        
        static let buttonsViewTopSpace: CGFloat = 14
        static let buttonsViewBottomSpace: CGFloat = 10
        static let buttonsViewItemsSpace: CGFloat = 12
        
        static let likesCountLabelBottomSpace: CGFloat = 8
        
        static let timestampLabelTopSpace: CGFloat = 6
        static let timestampLabelBottomSpace: CGFloat = 22
    }
    
    private enum Colors {
        static let profileImageButtonBorder = UIColor.systemGray5
        static let timestampLabelText = UIColor.systemGray
    }
    
    private enum Images {
        static let options = UIImage(systemName: "ellipsis")
        static let like = UIImage(systemName: "heart")
        static let likeFill = UIImage(systemName: "heart.fill")
        static let comment = UIImage(systemName: "bubble.right")
        static let send = UIImage(systemName: "paperplane")
        static let bookmarked = UIImage(systemName: "bookmark")
        static let notBookmarked = UIImage(systemName: "bookmark.fill")
    }
    
    // MARK: Subviews
    
    private let headerView = UIView()
    private let profileImageButton = UIButton(type: .custom)
    private let usernameButton = UIButton(type: .custom)
    private let optionsButton = UIButton(type: .system)
    
    private let imageView = UIImageView()
    
    private let buttonsView = UIView()
    private let likeButton = UIButton(type: .system)
    private let commentButton = UIButton(type: .system)
    private let sendButton = UIButton(type: .system)
    private let bookmarkButton = UIButton(type: .system)
    
    private var likesCountLabel = UILabel()
    
    private let captionLabel = UILabel()
    private let timestampLabel = UILabel()
    
    // MARK: Lifecycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        profileImageDataTask?.cancel()
        imageDataTask?.cancel()
        
        profileImageButton.setImage(nil, for: .normal)
        imageView.image = nil
        
        captionLabel.attributedText = nil
    }
    
    // MARK: Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupAppearance()
        setupLayout()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public Methods

extension PostCell {
    func configure(with userPost: UserPost) {
        if let profileImageURL = userPost.user.profileImageURL {
            profileImageDataTask = profileImageButton.imageDownload(urlString: profileImageURL)
        }
        
        imageDataTask = imageView.download(urlString: userPost.post.imageURL)
        
        configureImageViewHeight(aspectRatio: userPost.post.imageAspectRatio)
        
        usernameButton.setTitle(userPost.user.username, for: .normal)
        
        if let caption = userPost.post.caption {
            captionLabel.attributedText = makeAttributedCaption(caption, withUsername: userPost.user.username)
        }
        
        timestampLabelTopConstraint?.constant = (userPost.post.caption != nil) ? Metrics.timestampLabelTopSpace : 0
        
        if let timeAgo = Date(timeIntervalSince1970: userPost.post.timestamp).timeAgo() {
            timestampLabel.text = timeAgo + " ago"
        }
        
        isLiked = userPost.post.isLiked
        
        if 0 < userPost.post.likesCount {
            likesCountLabel.text = userPost.post.likesCount.description + " likes"

            captionLabelTopConstraint?.constant = Metrics.likesCountLabelBottomSpace
        } else {
            likesCountLabel.text = nil

            captionLabelTopConstraint?.constant = 0
        }
        
        isBookmarked = userPost.post.isBookmarked
    }
}

// MARK: - Private Methods

private extension PostCell {
    func setupLikeButton() {
        likeButton.setImage(Images.like?.withRenderingMode(.alwaysOriginal), for: .normal)
        likeButton.tintColor = .clear
    }
    
    func setupUnlikeButton() {
        likeButton.setImage(Images.likeFill, for: .normal)
        likeButton.tintColor = .red
    }
    
    func makeAttributedCaption(_ caption: String, withUsername username: String) -> NSAttributedString {
        let usernameAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: captionLabel.font.pointSize),
            .foregroundColor: UIColor.black
        ]
        let captionAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: captionLabel.font.pointSize)
        ]
        
        let attributedText = NSMutableAttributedString(string: username, attributes: usernameAttributes)
        let captionAttributedText = NSAttributedString(string: caption, attributes: captionAttributes)

        attributedText.append(NSAttributedString(string: " "))
        attributedText.append(captionAttributedText)
        
        return attributedText
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
        setupLikeCountLabelAppearance()
        setupTimestampLabelAppearance()
    }
    
    func setupProfileImageButtonAppearance() {
        profileImageButton.contentMode = .scaleAspectFill
        profileImageButton.layer.masksToBounds = true
        profileImageButton.layer.cornerRadius = Metrics.profileImageButtonSize / 2
        profileImageButton.layer.borderWidth = Metrics.profileImageButtonBorderWidth
        profileImageButton.layer.borderColor = Colors.profileImageButtonBorder.cgColor
    }
    
    func setupUsernameButtonAppearance() {
        usernameButton.setTitleColor(.black, for: .normal)
        usernameButton.titleLabel?.font = .boldSystemFont(ofSize: UIFont.labelFontSize)
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
        bookmarkButton.tintColor = .black
        
        isBookmarked = false
    }
    
    func setupLikeCountLabelAppearance() {
        likesCountLabel.text = "0 likes"
        likesCountLabel.font = .boldSystemFont(ofSize: likesCountLabel.font.pointSize)
    }
    
    func setupTimestampLabelAppearance() {
        timestampLabel.textColor = Colors.timestampLabelText
        timestampLabel.font = .systemFont(ofSize: captionLabel.font.pointSize - 2)
    }
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
        
        setupLikeCountLabelLayout()
        setupCaptionLabelLayout()
        setupTimestampLabelLayout()
    }
    
    func setupSubviews() {
        contentView.addSubview(headerView)
        contentView.addSubview(imageView)
        contentView.addSubview(buttonsView)
        contentView.addSubview(likesCountLabel)
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
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
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
    
    func setupLikeCountLabelLayout() {
        likesCountLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            likesCountLabel.topAnchor.constraint(equalTo: buttonsView.bottomAnchor),
            likesCountLabel.leadingAnchor.constraint(equalTo: profileImageButton.leadingAnchor),
            likesCountLabel.trailingAnchor.constraint(equalTo: optionsButton.leadingAnchor),
        ])
    }
    
    func setupCaptionLabelLayout() {
        captionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            captionLabel.leadingAnchor.constraint(equalTo: profileImageButton.leadingAnchor),
            captionLabel.trailingAnchor.constraint(equalTo: optionsButton.leadingAnchor),
        ])
        
        captionLabelTopConstraint = captionLabel.topAnchor.constraint(equalTo: likesCountLabel.bottomAnchor)
        captionLabelTopConstraint?.isActive = true
    }
    
    func setupTimestampLabelLayout() {
        timestampLabel.translatesAutoresizingMaskIntoConstraints = false
        
        timestampLabelTopConstraint = timestampLabel.topAnchor.constraint(equalTo: captionLabel.bottomAnchor)
        timestampLabelTopConstraint?.isActive = true
        
        let timestampLabelBottomConstraint = timestampLabel.bottomAnchor.constraint(
            equalTo: contentView.bottomAnchor,
            constant: -Metrics.timestampLabelBottomSpace)
        
        timestampLabelBottomConstraint.priority = .defaultLow
        timestampLabelBottomConstraint.isActive = true
        
        NSLayoutConstraint.activate([
            timestampLabel.leadingAnchor.constraint(equalTo: profileImageButton.leadingAnchor),
            timestampLabel.trailingAnchor.constraint(equalTo: optionsButton.trailingAnchor),
        ])
    }
}

// MARK: - Actions

private extension PostCell {
    func setupActions() {
        profileImageButton.addTarget(self, action: #selector(didPressProfileImageButton), for: .touchUpInside)
        usernameButton.addTarget(self, action: #selector(didPressProfileImageButton), for: .touchUpInside)
        optionsButton.addTarget(self, action: #selector(didPressOptionsButton), for: .touchUpInside)
        
        likeButton.addTarget(self, action: #selector(didPressLikeButton), for: .touchUpInside)
        commentButton.addTarget(self, action: #selector(didPressCommentButton), for: .touchUpInside)
        sendButton.addTarget(self, action: #selector(didPressSendButton), for: .touchUpInside)
        bookmarkButton.addTarget(self, action: #selector(didPressBookmarkButton), for: .touchUpInside)
    }
    
    @objc func didPressProfileImageButton() {
        delegate?.postCellDidPressProfileImageButton(self)
    }
    
    @objc func didPressOptionsButton() {
        delegate?.postCellDidPressOptionsButton(self)
    }
    
    @objc func didPressLikeButton() {
        if isLiked {
            delegate?.postCellDidPressUnlikeButton(self)
        } else {
            delegate?.postCellDidPressLikeButton(self)
        }
    }
    
    @objc func didPressCommentButton() {
        delegate?.postCellDidPressCommentButton(self)
    }
    
    @objc func didPressSendButton() {
        delegate?.postCellDidPressSendButton(self)
    }
    
    @objc func didPressBookmarkButton() {
        if isBookmarked {
            delegate?.postCellDidPressNotBookmarkButton(self)
        } else {
            delegate?.postCellDidPressBookmarkButton(self)
        }
    }
}

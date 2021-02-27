//
//  CommentCell.swift
//  Instagram
//
//  Created by Admin on 26.02.2021.
//

import UIKit

final class CommentCell: UICollectionViewCell {
    // MARK: Properties
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    private var profileImageDataTask: URLSessionDataTask?
    
    // MARK: Constants
    
    private enum Metrics {
        static let contentViewVerticalSpace: CGFloat = 8
        static let contentViewHorizontalSpace: CGFloat = 16
        
        static let profileImageViewTrailingSpace: CGFloat = 12
        static let profileImageViewSize: CGFloat = 40
        static let profileImageViewBorderWidth: CGFloat = 1
        
        static let timestampLabelTopSpace: CGFloat = 4
        static let timestampLabelBottomSpace: CGFloat = 22
    }
    
    private enum Colors {
        static let profileImageViewBorder = UIColor.systemGray5
        static let timestampLabelText = UIColor.systemGray
    }
    
    // MARK: Subviews
    
    private let profileImageView = UIImageView()
    private let captionLabel = UILabel()
    private let timestampLabel = UILabel()
    
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

extension CommentCell {
    func configure(with userComment: UserComment) {
        if let profileImageURL = userComment.user.profileImageURL {
            profileImageDataTask = profileImageView.download(urlString: profileImageURL)
        }
        
        captionLabel.attributedText = makeAttributedCaption(
            userComment.comment.caption,
            withUsername: userComment.user.username)
        
        if let timeAgo = Date(timeIntervalSince1970: userComment.comment.timestamp).timeAgo() {
            timestampLabel.text = timeAgo + " ago"
        }
    }
}

// MARK: - Private Methods

private extension CommentCell {
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

private extension CommentCell {
    func setupAppearance() {
        setupProfileImageViewAppearance()
        setupCaptionLabelAppearance()
        setupTimestampLabelAppearance()
    }
    
    func setupProfileImageViewAppearance() {
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.masksToBounds = true
        profileImageView.layer.cornerRadius = Metrics.profileImageViewSize / 2
        profileImageView.layer.borderWidth = Metrics.profileImageViewBorderWidth
        profileImageView.layer.borderColor = Colors.profileImageViewBorder.cgColor
    }
    
    func setupCaptionLabelAppearance() {
        captionLabel.numberOfLines = 0
    }
    
    func setupTimestampLabelAppearance() {
        timestampLabel.textColor = Colors.timestampLabelText
        timestampLabel.font = .systemFont(ofSize: captionLabel.font.pointSize - 2)
    }
}

// MARK: - Layout

private extension CommentCell {
    func setupLayout() {
        setupSubviews()
        
        setupProfileImageViewLayout()
        setupCaptionLabelLayout()
        setupTimestampLabelLayout()
    }
    
    func setupSubviews() {
        contentView.addSubview(profileImageView)
        contentView.addSubview(captionLabel)
        contentView.addSubview(timestampLabel)
    }
    
    func setupProfileImageViewLayout() {
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: Metrics.contentViewVerticalSpace),
            profileImageView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: Metrics.contentViewHorizontalSpace),
            profileImageView.heightAnchor.constraint(equalToConstant: Metrics.profileImageViewSize),
            profileImageView.widthAnchor.constraint(equalToConstant: Metrics.profileImageViewSize),
        ])
    }
    
    func setupCaptionLabelLayout() {
        captionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            captionLabel.topAnchor.constraint(equalTo: profileImageView.topAnchor),
            captionLabel.leadingAnchor.constraint(
                equalTo: profileImageView.trailingAnchor,
                constant: Metrics.profileImageViewTrailingSpace),
            captionLabel.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -Metrics.contentViewHorizontalSpace),
        ])
    }
    
    func setupTimestampLabelLayout() {
        timestampLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let timestampLabelBottomConstraint = timestampLabel.bottomAnchor.constraint(
            equalTo: contentView.bottomAnchor,
            constant: -Metrics.contentViewVerticalSpace)

        timestampLabelBottomConstraint.priority = .defaultLow
        timestampLabelBottomConstraint.isActive = true
        
        NSLayoutConstraint.activate([
            timestampLabel.topAnchor.constraint(
                equalTo: captionLabel.bottomAnchor,
                constant: Metrics.timestampLabelTopSpace),
            timestampLabel.leadingAnchor.constraint(equalTo: captionLabel.leadingAnchor),
            timestampLabel.trailingAnchor.constraint(equalTo: captionLabel.trailingAnchor),
        ])
    }
}

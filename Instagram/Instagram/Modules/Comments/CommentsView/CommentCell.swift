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
    
    // MARK: Subviews
    
    private let profileImageView = UIImageView()
    private let captionLabel = UILabel()
    //private let timestampLabel = UILabel()
    
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
        
        captionLabel.text = userComment.comment.caption
    }
}

// MARK: - Appearance

private extension CommentCell {
    func setupAppearance() {
        setupProfileImageViewAppearance()
        setupCaptionLabelAppearance()
    }
    
    func setupProfileImageViewAppearance() {
        profileImageView.backgroundColor = .red
        profileImageView.layer.masksToBounds = true
        profileImageView.layer.cornerRadius = 40 / 2
    }
    
    func setupCaptionLabelAppearance() {
        captionLabel.backgroundColor = .yellow
        captionLabel.numberOfLines = 0
    }
}

// MARK: - Layout

private extension CommentCell {
    func setupLayout() {
        setupSubviews()
        
        setupProfileImageViewLayout()
        setupCaptionLabelLayout()
    }
    
    func setupSubviews() {
        contentView.addSubview(profileImageView)
        contentView.addSubview(captionLabel)
    }
    
    func setupProfileImageViewLayout() {
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let profileImageViewBottomConstraint = profileImageView.bottomAnchor.constraint(
            lessThanOrEqualTo: contentView.bottomAnchor,
            constant: -10)
        
        profileImageViewBottomConstraint.priority = .defaultLow
        profileImageViewBottomConstraint.isActive = true
        
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            profileImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            profileImageView.heightAnchor.constraint(equalToConstant: 40),
            profileImageView.widthAnchor.constraint(equalToConstant: 40),
        ])
    }
    
    func setupCaptionLabelLayout() {
        captionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            captionLabel.topAnchor.constraint(equalTo: profileImageView.topAnchor),
            captionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            captionLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 10),
            captionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
        ])
    }
}

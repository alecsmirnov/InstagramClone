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
    
    // MARK: Subviews
    
    private let imageView = UIImageView()
    
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
        
        // TODO: Get aspect ratio from image download completion
        // TODO: Hide cell until image is loaded
        
        configureImageViewHeight(aspectRatio: post.imageAspectRatio)
    }
}

// MARK: - Appearance

private extension PostCell {
    func setupAppearance() {
        setupImageViewAppearance()
    }
    
    func setupImageViewAppearance() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
    }
}

// MARK: - Layout

private extension PostCell {
    func setupLayout() {
        setupSubviews()
        
        setupImageViewLayout()
    }
    
    func setupSubviews() {
        contentView.addSubview(imageView)
    }
    
    func setupImageViewLayout() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.widthAnchor.constraint(equalToConstant: bounds.width),
        ])
        
        let imageViewBottomConstraint = imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        
        imageViewBottomConstraint.priority = .defaultLow
        imageViewBottomConstraint.isActive = true
    }
    
    func configureImageViewHeight(aspectRatio: CGFloat) {
        imageViewHeightConstraint?.isActive = false
        
        imageViewHeightConstraint = imageView.heightAnchor.constraint(
            equalTo: imageView.widthAnchor,
            multiplier: 1 / aspectRatio)
        
        imageViewHeightConstraint?.isActive = true
        
        contentView.layoutIfNeeded()
    }
}

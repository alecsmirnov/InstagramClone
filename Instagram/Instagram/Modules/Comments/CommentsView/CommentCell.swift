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
    
    // MARK: Subviews
    
    private let imageView = UIImageView()
    private let captionLabel = UILabel()
    //private let timestampLabel = UILabel()
    
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
    func configure(with text: String) {
        captionLabel.text = text
    }
}

// MARK: - Appearance

private extension CommentCell {
    func setupAppearance() {
        setupImageViewAppearance()
        setupCaptionLabelAppearance()
    }
    
    func setupImageViewAppearance() {
        imageView.backgroundColor = .red
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 40 / 2
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
        
        setupImageViewLayout()
        setupCaptionLabelLayout()
    }
    
    func setupSubviews() {
        contentView.addSubview(imageView)
        contentView.addSubview(captionLabel)
    }
    
    func setupImageViewLayout() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let imageViewBottomConstraint = imageView.bottomAnchor.constraint(
            lessThanOrEqualTo: contentView.bottomAnchor,
            constant: -10)
        
        imageViewBottomConstraint.priority = .defaultLow
        imageViewBottomConstraint.isActive = true
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            imageView.heightAnchor.constraint(equalToConstant: 40),
            imageView.widthAnchor.constraint(equalToConstant: 40),
        ])
    }
    
    func setupCaptionLabelLayout() {
        captionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            captionLabel.topAnchor.constraint(equalTo: imageView.topAnchor),
            captionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            captionLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 10),
            captionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
        ])
    }
}

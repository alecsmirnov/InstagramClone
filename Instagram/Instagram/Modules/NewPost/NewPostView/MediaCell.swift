//
//  MediaCell.swift
//  Instagram
//
//  Created by Admin on 29.01.2021.
//

import UIKit

final class MediaCell: UICollectionViewCell {
    // MARK: Properties
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    // MARK: Subviews
    
    private let imageView = UIImageView()
    
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

extension MediaCell {
    func configure(withMediaFile mediaFile: MediaFileType) {
        switch mediaFile {
        case .image(let image):
            imageView.image = image
        }
    }
    
    func selectCell() {
        imageView.alpha = 0.4
    }
    
    func deselectCell() {
        imageView.alpha = 1
    }
}

// MARK: - Appearance

private extension MediaCell {
    func setupAppearance() {
        setupImageViewAppearance()
    }
    
    func setupImageViewAppearance() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
    }
}

// MARK: - Layout

private extension MediaCell {
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
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
}

//
//  DownloadImageCell.swift
//  Instagram
//
//  Created by Admin on 05.02.2021.
//

import UIKit

final class DownloadImageCell: UICollectionViewCell {
    // MARK: Properties
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    private var imageDataTask: URLSessionDataTask?
    
    // MARK: Subviews
    
    private let imageView = UIImageView()
    
    // MARK: Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupAppearance()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageDataTask?.cancel()
        imageView.image = nil
    }
}

// MARK: - Public Methods

extension DownloadImageCell {
    func configure(with urlString: String) {
        imageDataTask = imageView.download(urlString: urlString)
    }
}

// MARK: - Appearance

private extension DownloadImageCell {
    func setupAppearance() {
        setupImageViewAppearance()
    }
    
    func setupImageViewAppearance() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
    }
}

// MARK: - Layout

private extension DownloadImageCell {
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

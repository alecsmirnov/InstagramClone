//
//  NewPostHeaderView.swift
//  Instagram
//
//  Created by Admin on 05.02.2021.
//

import UIKit

final class NewPostHeaderView: UICollectionReusableView {
    // MARK: Properties
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    // MARK: Subviews
    
    private let scrollView = UIScrollView()
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

extension NewPostHeaderView {
    func configure(with mediaFile: MediaFileType) {
        switch mediaFile {
        case .image(let image):
            setImage(image)
        }
    }
}

// MARK: - Private Methods

private extension NewPostHeaderView {
    func setImage(_ image: UIImage) {
        imageView.image = image
        
        setScrollViewContentScale(size: image.size)
        scrollViewToCenter()
    }
    
    func setScrollViewContentScale(size: CGSize) {
        let horizontalRatio = scrollView.bounds.width / size.width
        let verticalRatio = scrollView.bounds.height / size.height

        let aspectFillRatioScale = max(horizontalRatio, verticalRatio)

        scrollView.minimumZoomScale = aspectFillRatioScale
        scrollView.maximumZoomScale = scrollView.minimumZoomScale * 10

        scrollView.zoomScale = scrollView.minimumZoomScale
        
        layoutIfNeeded()
    }
    
    func scrollViewToCenter() {
        let xOffset = (scrollView.contentSize.width - scrollView.bounds.width) / 2
        let yOffset = (scrollView.contentSize.height - scrollView.bounds.height) / 2
        
        let centerPoint = CGPoint(x: xOffset, y: yOffset)
        
        scrollView.contentOffset = centerPoint
    }
}

// MARK: - Appearance

private extension NewPostHeaderView {
    func setupAppearance() {
        setupScrollViewAppearance()
    }
    
    func setupScrollViewAppearance() {
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.alwaysBounceVertical = true
        scrollView.alwaysBounceHorizontal = true
        scrollView.isMultipleTouchEnabled = false
        
        scrollView.delegate = self
    }
}

// MARK: - Layout

private extension NewPostHeaderView {
    func setupLayout() {
        setupSubviews()
        
        setupScrollViewLayout()
        setupImageViewLayout()
    }
    
    func setupSubviews() {
        addSubview(scrollView)
        
        scrollView.addSubview(imageView)
    }
    
    func setupScrollViewLayout() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
    func setupImageViewLayout() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
        ])
    }
}

// MARK: - UIScrollViewDelegate

extension NewPostHeaderView: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        scrollViewToCenter()
    }
}

//
//  ImageHeaderView.swift
//  Instagram
//
//  Created by Admin on 05.02.2021.
//

import UIKit

final class ImageHeaderView: UICollectionReusableView {
    // MARK: Properties
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    private var isSizeToFit = true
    
    // MARK: Subviews
    
    private let adjustButton = UIButton(type: .system)
    private let scrollView = UIScrollView()
    private let imageView = UIImageView()
    private let separatorView = UIView()
    
    // MARK: Constants
    
    private enum Metrics {
        static let adjustButtonSpace: CGFloat = 16
        static let adjustButtonSize: CGFloat = 32
    }
    
    private enum Images {
        static let adjust = UIImage(named: "adjust_fill")
    }
    
    private enum Constants {
        static let adjustButtonAlpha: CGFloat = 0.7
        
        static let scrollViewMaxZoomScale: CGFloat = 10
    }
    
    // MARK: Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupAppearance()
        setupLayout()
        setupButtonActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public Methods

extension ImageHeaderView {
    func configure(with image: UIImage) {
        imageView.image = image
        
        setScrollViewContentScale(size: image.size)
        scrollViewContentToCenter()
    }
    
    func getCroppedImage() -> UIImage? {
        guard
            let image = imageView.image,
            let imageViewRect = imageView.realImageRect()
        else {
            return nil
        }
        
        let cropFrame = scrollView.bounds
        
        let cropRect = CGRect(
            x: cropFrame.origin.x - imageViewRect.origin.x,
            y: cropFrame.origin.y - imageViewRect.origin.y,
            width: cropFrame.width,
            height: cropFrame.height)
        
        let croppedImage = image.crop(
            toRect: cropRect,
            viewWidth: imageView.frame.width,
            viewHeight: imageView.frame.height)
        
        return croppedImage
    }
}

// MARK: - Private Methods

private extension ImageHeaderView {
    func setScrollViewContentScale(size: CGSize) {
        let horizontalRatio = scrollView.bounds.width / size.width
        let verticalRatio = scrollView.bounds.height / size.height
        let aspectRatioScale = isSizeToFit ? min(horizontalRatio, verticalRatio) : max(horizontalRatio, verticalRatio)

        scrollView.minimumZoomScale = aspectRatioScale
        scrollView.maximumZoomScale = scrollView.minimumZoomScale * Constants.scrollViewMaxZoomScale
        scrollView.zoomScale = scrollView.minimumZoomScale
        
        scrollView.layoutIfNeeded()
    }
    
    func scrollViewContentToCenter() {
        if isSizeToFit {
            scrollViewZoomToCenter()
        } else {
            scrollViewToCenter()
        }
    }
    
    func scrollViewZoomToCenter() {
        guard let imageSize = imageView.image?.size else { return }

        if imageSize.width < imageSize.height {
            if scrollView.contentSize.width < scrollView.bounds.width {
                scrollViewToCenterX()
            }
        } else {
            if scrollView.contentSize.height < scrollView.bounds.height {
                scrollViewToCenterY()
            }
        }
    }
    
    func scrollViewToCenter() {
        scrollViewToCenterX()
        scrollViewToCenterY()
    }
    
    func scrollViewToCenterX() {
        let xOffset = (scrollView.contentSize.width - scrollView.bounds.width) / 2
        
        scrollView.contentOffset.x = xOffset
    }
    
    func scrollViewToCenterY() {
        let yOffset = (scrollView.contentSize.height - scrollView.bounds.height) / 2
        
        scrollView.contentOffset.y = yOffset
    }
}

// MARK: - Appearance

private extension ImageHeaderView {
    func setupAppearance() {
        setupAdjustButtonAppearance()
        setupScrollViewAppearance()
    }
    
    func setupAdjustButtonAppearance() {
        adjustButton.setImage(Images.adjust?.withRenderingMode(.alwaysOriginal), for: .normal)
        adjustButton.alpha = Constants.adjustButtonAlpha
        adjustButton.contentVerticalAlignment = .fill
        adjustButton.contentHorizontalAlignment = .fill
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

private extension ImageHeaderView {
    func setupLayout() {
        setupSubviews()
        
        setupAdjustButtonLayout()
        setupScrollViewLayout()
        setupImageViewLayout()
    }
    
    func setupSubviews() {
        addSubview(scrollView)
        addSubview(adjustButton)
        
        scrollView.addSubview(imageView)
    }
    
    func setupAdjustButtonLayout() {
        adjustButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            adjustButton.bottomAnchor.constraint(
                equalTo: safeAreaLayoutGuide.bottomAnchor,
                constant: -Metrics.adjustButtonSpace),
            adjustButton.leadingAnchor.constraint(
                equalTo: safeAreaLayoutGuide.leadingAnchor,
                constant: Metrics.adjustButtonSpace),
            adjustButton.heightAnchor.constraint(equalToConstant: Metrics.adjustButtonSize),
            adjustButton.widthAnchor.constraint(equalToConstant: Metrics.adjustButtonSize),
        ])
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

// MARK: - Button Actions

private extension ImageHeaderView {
    func setupButtonActions() {
        adjustButton.addTarget(self, action: #selector(didTapAdjustButton), for: .touchUpInside)
    }
    
    @objc func didTapAdjustButton() {
        guard let imageSize = imageView.image?.size else { return }
        
        isSizeToFit.toggle()
        
        setScrollViewContentScale(size: imageSize)
        scrollViewContentToCenter()
    }
}

// MARK: - UIScrollViewDelegate

extension ImageHeaderView: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        scrollViewZoomToCenter()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollViewZoomToCenter()
    }
}

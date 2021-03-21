//
//  NoImagesHeaderView.swift
//  Instagram
//
//  Created by Admin on 14.03.2021.
//

import UIKit

final class NoImagesHeaderView: UICollectionReusableView {
    // MARK: Properties
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    // MARK: Subviews
    
    private let label = UILabel()
    
    // MARK: Constants
    
    private enum Metrics {
        static let labelVerticalSpace: CGFloat = 22
        static let labelHorizontalSpace: CGFloat = 16
    }
    
    private enum Colors {
        static let text = UIColor.systemGray2
    }
    
    // MARK: Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupAppearance()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Appearance

private extension NoImagesHeaderView {
    func setupAppearance() {
        label.text = "No images on the device!"
        label.textAlignment = .center
        label.textColor = Colors.text
    }
}

// MARK: - Layout

private extension NoImagesHeaderView {
    func setupLayout() {
        addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: Metrics.labelVerticalSpace),
            label.leadingAnchor.constraint(
                equalTo: safeAreaLayoutGuide.leadingAnchor,
                constant: Metrics.labelHorizontalSpace),
            label.trailingAnchor.constraint(
                equalTo: safeAreaLayoutGuide.trailingAnchor,
                constant: -Metrics.labelHorizontalSpace),
        ])
    }
}

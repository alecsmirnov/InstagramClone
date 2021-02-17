//
//  SearchCell.swift
//  Instagram
//
//  Created by Admin on 17.02.2021.
//

import UIKit

final class SearchCell: UICollectionViewCell {
    // MARK: Properties
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    // MARK: Constants
    
    private enum Metrics {
        static let labelVerticalSpace: CGFloat = 30
        static let labelHorizontalSpace: CGFloat = 16
    }
    
    // MARK: Subviews
    
    private let label = UILabel()
    
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

extension SearchCell {
    func showSearchMessage() {
        label.text = "Search..."
    }
    
    func showNoResultMessage() {
        label.text = "No search result"
    }
}

// MARK: - Appearance

private extension SearchCell {
    func setupAppearance() {
        setupLabelAppearance()
    }

    func setupLabelAppearance() {
        label.textAlignment = .center
    }
}

// MARK: - Layout

private extension SearchCell {
    func setupLayout() {
        setupSubviews()
        
        setupLabelLayout()
    }
    
    func setupSubviews() {
        contentView.addSubview(label)
    }
    
    func setupLabelLayout() {
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let labelBottomConstraint = label.bottomAnchor.constraint(
            equalTo: contentView.bottomAnchor,
            constant: -Metrics.labelVerticalSpace)
        
        labelBottomConstraint.priority = .defaultLow
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Metrics.labelVerticalSpace),
            labelBottomConstraint,
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Metrics.labelHorizontalSpace),
            label.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -Metrics.labelHorizontalSpace),
        ])
    }
}

//
//  PlaceholderTextView.swift
//  Instagram
//
//  Created by Admin on 02.02.2021.
//

import UIKit

final class PlaceholderTextView: UITextView {
    // MARK: Properties
    
    var placeholderText: String? {
        get { placeholderLabel.text }
        set { placeholderLabel.text = newValue }
    }
    
    override var font: UIFont? {
        didSet {
            placeholderLabel.font = font
        }
    }
    
    // MARK: Constants
    
    private enum Metrics {
        static let verticalSpace: CGFloat = 8
        static let horizontalSpace: CGFloat = 4
        
        static let fontSize: CGFloat = 14
    }
    
    private enum Colors {
        static let placeholderLabelText = UIColor.lightGray
    }
    
    private enum Constants {
        static let placeholderLabelAnimationDuration = 0.1
    }
    
    // MARK: Subviews
    
    private let placeholderLabel = UILabel()
    
    // MARK: Initialization
    
    init() {
        super.init(frame: .zero, textContainer: nil)
        
        setupAppearance()
        setupLayout()
        setupObservers()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        removeObservers()
    }
}

// MARK: - Public Methods

extension PlaceholderTextView {
    func showPlaceholder() {
        placeholderLabel.isHidden = false
    }
    
    func hidePlaceholder() {
        placeholderLabel.isHidden = true
    }
}

// MARK: - Appearance

private extension PlaceholderTextView {
    func setupAppearance() {
        setupTextViewAppearance()
        setupPlaceholderLabelAppearance()
    }
    
    func setupTextViewAppearance() {
        font = .systemFont(ofSize: Metrics.fontSize)
    }
    
    func setupPlaceholderLabelAppearance() {
        placeholderLabel.font = .systemFont(ofSize: Metrics.fontSize)
        placeholderLabel.textColor = Colors.placeholderLabelText
    }
}

// MARK: - Layout

private extension PlaceholderTextView {
    func setupLayout() {
        setupSubviews()
        
        setupPlaceholderLabelLayout()
    }
    
    func setupSubviews() {
        addSubview(placeholderLabel)
    }
    
    func setupPlaceholderLabelLayout() {
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            placeholderLabel.topAnchor.constraint(
                equalTo: safeAreaLayoutGuide.topAnchor,
                constant: Metrics.verticalSpace),
            placeholderLabel.bottomAnchor.constraint(
                lessThanOrEqualTo: safeAreaLayoutGuide.bottomAnchor,
                constant: -Metrics.verticalSpace),
            placeholderLabel.leadingAnchor.constraint(
                equalTo: safeAreaLayoutGuide.leadingAnchor,
                constant: Metrics.horizontalSpace),
            placeholderLabel.trailingAnchor.constraint(
                equalTo: safeAreaLayoutGuide.trailingAnchor,
                constant: -Metrics.horizontalSpace),
        ])
    }
}

// MARK: - Observers

private extension PlaceholderTextView {
    func setupObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(textDidChange),
            name: UITextView.textDidChangeNotification,
            object: nil)
    }
    
    func removeObservers() {
        NotificationCenter.default.removeObserver(self, name: UITextView.textDidChangeNotification, object: nil)
    }
    
    @objc func textDidChange(notification: NSNotification) {
        guard self == notification.object as? UITextView else { return }
        
        UIView.animate(withDuration: Constants.placeholderLabelAnimationDuration) { [self] in
            placeholderLabel.alpha = text.isEmpty ? 1 : 0
        }
    }
}

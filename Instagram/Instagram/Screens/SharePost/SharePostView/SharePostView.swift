//
//  SharePostView.swift
//  Instagram
//
//  Created by Admin on 01.02.2021.
//

import UIKit

protocol SharePostViewProtocol: UIView {
    var image: UIImage? { get set }
    var caption: String? { get }
}

final class SharePostView: UIView {
    // MARK: Properties
    
    private var contentViewBottomConstraint: NSLayoutConstraint?
    private var captionTextViewFixedBottomConstraint: NSLayoutConstraint?
    private var captionTextViewScrollableBottomConstraint: NSLayoutConstraint?
    
    private lazy var keyboardAppearanceListener = KeyboardAppearanceListener(delegate: self)
    
    // MARK: Constants
    
    private enum Metrics {
        static let contentViewVerticalSpace: CGFloat = 16
        static let contentViewHorizontalSpace: CGFloat = 16
        
        static let imageViewTrailingSpace: CGFloat = 8
        static let imageViewSize: CGFloat = 80
        static let imageViewBorderWidth: CGFloat = 1
        
        static let separatorViewWidth: CGFloat = 1
        
        static let captionTextViewFontSize: CGFloat = 16
    }
    
    private enum Colors {
        static let imageViewBorder = AppConstants.Colors.profileImageBorder
        static let separatorViewBackground = AppConstants.Colors.separatorViewBackground
    }
    
    private enum Constants {
        static let layoutUpdateAnimationDuration: TimeInterval = 0.2
    }
    
    // MARK: Subviews
    
    private let contentView = UIView()
    private let imageView = UIImageView()
    private let captionTextView = PlaceholderTextView()
    private let separatorView = UIView()
    
    // MARK: Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupAppearance()
        setupLayout()
        keyboardAppearanceListener.setupKeyboardObservers()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Interface

extension SharePostView: SharePostViewProtocol {
    var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue
        }
    }
    
    var caption: String? {
        return captionTextView.text
    }
}

// MARK: - Appearance

private extension SharePostView {
    func setupAppearance() {
        backgroundColor = .systemBackground
        
        setupImageViewAppearance()
        setupCaptionTextViewAppearance()
        setupSeparatorViewAppearance()
    }
    
    func setupImageViewAppearance() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.borderColor = Colors.imageViewBorder.cgColor
        imageView.layer.borderWidth = Metrics.imageViewBorderWidth
    }
    
    func setupCaptionTextViewAppearance() {
        captionTextView.placeholderText = "Write a caption..."
        captionTextView.font = .systemFont(ofSize: Metrics.captionTextViewFontSize)
        
        captionTextView.delegate = self
    }
    
    func setupSeparatorViewAppearance() {
        separatorView.backgroundColor = Colors.separatorViewBackground
    }
}

// MARK: - Layout

private extension SharePostView {
    func setupLayout() {
        setupSubviews()
        
        setupContentViewLayout()
        setupImageViewLayout()
        setupCaptionTextViewLayout()
        setupSeparatorViewLayout()
    }
    
    func setupSubviews() {
        addSubview(contentView)
        
        contentView.addSubview(imageView)
        contentView.addSubview(captionTextView)
        contentView.addSubview(separatorView)
    }
    
    func setupContentViewLayout() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(
                equalTo: safeAreaLayoutGuide.topAnchor,
                constant: Metrics.contentViewVerticalSpace),
            contentView.leadingAnchor.constraint(
                equalTo: safeAreaLayoutGuide.leadingAnchor,
                constant: Metrics.contentViewHorizontalSpace),
            contentView.trailingAnchor.constraint(
                equalTo: safeAreaLayoutGuide.trailingAnchor,
                constant: -Metrics.contentViewHorizontalSpace),
        ])
        
        contentViewBottomConstraint = contentView.bottomAnchor.constraint(
            equalTo: safeAreaLayoutGuide.bottomAnchor,
            constant: -Metrics.contentViewVerticalSpace)
        contentViewBottomConstraint?.isActive = true
    }
    
    func setupImageViewLayout() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(
                equalTo: captionTextView.leadingAnchor,
                constant: -Metrics.imageViewTrailingSpace),
            imageView.centerYAnchor.constraint(equalTo: captionTextView.centerYAnchor),
            imageView.heightAnchor.constraint(equalToConstant: Metrics.imageViewSize),
            imageView.widthAnchor.constraint(equalToConstant: Metrics.imageViewSize),
        ])
    }
    
    func setupCaptionTextViewLayout() {
        captionTextView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            captionTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            captionTextView.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
        ])
        
        let captionTextViewTopConstraint = captionTextView.topAnchor.constraint(equalTo: contentView.topAnchor)
        
        captionTextViewTopConstraint.priority = .defaultLow
        captionTextViewTopConstraint.isActive = true
        
        captionTextViewFixedBottomConstraint = captionTextView.bottomAnchor.constraint(
            lessThanOrEqualTo: contentView.bottomAnchor)
        
        captionTextViewScrollableBottomConstraint = captionTextView.bottomAnchor.constraint(
            equalTo: contentView.bottomAnchor)
        
        applyCaptionTextViewFixedLayout()
    }
    
    func updateCaptionTextViewLayout() {
        UIView.animate(withDuration: Constants.layoutUpdateAnimationDuration) {
            self.layoutIfNeeded()
        }
        
        if contentView.frame.height <= captionTextView.contentSize.height {
            applyCaptionTextViewScrollableLayout()
        } else {
            applyCaptionTextViewFixedLayout()
        }
    }
    
    func applyCaptionTextViewFixedLayout() {
        captionTextViewScrollableBottomConstraint?.isActive = false
        captionTextViewFixedBottomConstraint?.isActive = true
        
        captionTextView.isScrollEnabled = false
        captionTextView.invalidateIntrinsicContentSize()
    }
    
    func applyCaptionTextViewScrollableLayout() {
        captionTextViewFixedBottomConstraint?.isActive = false
        captionTextViewScrollableBottomConstraint?.isActive = true
        
        captionTextView.isScrollEnabled = true
        captionTextView.invalidateIntrinsicContentSize()
    }
    
    func setupSeparatorViewLayout() {
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            separatorView.topAnchor.constraint(
                greaterThanOrEqualTo: imageView.bottomAnchor,
                constant: Metrics.contentViewVerticalSpace),
            separatorView.topAnchor.constraint(
                greaterThanOrEqualTo: captionTextView.bottomAnchor,
                constant: Metrics.contentViewVerticalSpace),
            separatorView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: Metrics.separatorViewWidth),
        ])
    }
}

// MARK: - UITextViewDelegate

extension SharePostView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        updateCaptionTextViewLayout()
    }
}

// MARK: - KeyboardAppearanceListenerDelegate

extension SharePostView: KeyboardAppearanceListenerDelegate {
    func keyboardAppearanceListener(
        _ listener: KeyboardAppearanceListener,
        keyboardWillShowWith notification: Notification
    ) {
        guard
            let userInfo = notification.userInfo,
            let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        else {
            return
        }
        
        updateContentViewLayout(bottomConstant: -keyboardSize.cgRectValue.height)
    }
    
    func keyboardAppearanceListener(
        _ listener: KeyboardAppearanceListener,
        keyboardWillHideWith notification: Notification
    ) {
        guard
            let userInfo = notification.userInfo,
            let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        else {
            return
        }
        
        updateContentViewLayout(bottomConstant: keyboardSize.cgRectValue.height)
    }
    
    private func updateContentViewLayout(bottomConstant: CGFloat) {
        contentViewBottomConstraint?.constant += bottomConstant
        
        updateCaptionTextViewLayout()
    }
}

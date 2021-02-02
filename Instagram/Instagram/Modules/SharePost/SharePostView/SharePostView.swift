//
//  SharePostView.swift
//  Instagram
//
//  Created by Admin on 01.02.2021.
//

import UIKit

final class SharePostView: UIView {
    // MARK: Properties
    
    private var contentViewBottomConstraint: NSLayoutConstraint?
    private var captionTextViewFixedBottomConstraint: NSLayoutConstraint?
    private var captionTextViewScrollableBottomConstraint: NSLayoutConstraint?
    
    private var keyboardAppearanceListener: KeyboardAppearanceListener?
    
    // MARK: Subviews
    
    private let contentView = UIView()
    private let imageView = UIImageView()
    private let captionTextView = PlaceholderTextView()
    private let separatorView = UIView()
    
    // MARK: Initialization
    
    init() {
        super.init(frame: .zero)
        
        setupAppearance()
        setupLayout()
        setupKeyboardHandlers()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public Methods

extension SharePostView {
    func setMediaFile(_ mediaFile: MediaFileType) {
        switch mediaFile {
        case .image(let image):
            imageView.image = image
        }
    }
}

// MARK: - Private Methods

private extension SharePostView {
    private func setupKeyboardHandlers() {
        keyboardAppearanceListener = KeyboardAppearanceListener(delegate: self)
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
        imageView.layer.borderColor = SharePostConstants.Colors.imageViewBorder.cgColor
        imageView.layer.borderWidth = SharePostConstants.Metrics.imageViewBorderWidth
    }
    
    func setupCaptionTextViewAppearance() {
        captionTextView.placeholderText = SharePostConstants.Constants.captionTextViewPlaceholder
        captionTextView.delegate = self
    }
    
    func setupSeparatorViewAppearance() {
        separatorView.backgroundColor = SharePostConstants.Colors.separatorViewBackground
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
                constant: SharePostConstants.Metrics.contentViewVerticalSpace),
            contentView.leadingAnchor.constraint(
                equalTo: safeAreaLayoutGuide.leadingAnchor,
                constant: SharePostConstants.Metrics.contentViewHorizontalSpace),
            contentView.trailingAnchor.constraint(
                equalTo: safeAreaLayoutGuide.trailingAnchor,
                constant: -SharePostConstants.Metrics.contentViewHorizontalSpace),
        ])
        
        contentViewBottomConstraint = contentView.bottomAnchor.constraint(
            equalTo: safeAreaLayoutGuide.bottomAnchor,
            constant: -SharePostConstants.Metrics.contentViewVerticalSpace)
        
        contentViewBottomConstraint?.isActive = true
    }
    
    func setupImageViewLayout() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(
                equalTo: captionTextView.leadingAnchor,
                constant: -SharePostConstants.Metrics.imageViewTrailingSpace),
            imageView.centerYAnchor.constraint(equalTo: captionTextView.centerYAnchor),
            imageView.heightAnchor.constraint(equalToConstant: SharePostConstants.Metrics.imageViewSize),
            imageView.widthAnchor.constraint(equalToConstant: SharePostConstants.Metrics.imageViewSize),
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
        if contentView.frame.height <= captionTextView.contentSize.height {
            applyCaptionTextViewScrollableLayout()
        } else {
            applyCaptionTextViewFixedLayout()
        }
        
        UIView.animate(withDuration: SharePostConstants.Constants.layoutUpdateAnimationDuration) {
            self.layoutIfNeeded()
        }
    }
    
    func applyCaptionTextViewFixedLayout() {
        captionTextView.isScrollEnabled = false
        
        captionTextViewScrollableBottomConstraint?.isActive = false
        captionTextViewFixedBottomConstraint?.isActive = true
        
        captionTextView.invalidateIntrinsicContentSize()
    }
    
    func applyCaptionTextViewScrollableLayout() {
        captionTextView.isScrollEnabled = true
        
        captionTextViewFixedBottomConstraint?.isActive = false
        captionTextViewScrollableBottomConstraint?.isActive = true
        
        captionTextView.invalidateIntrinsicContentSize()
    }
    
    func setupSeparatorViewLayout() {
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            separatorView.topAnchor.constraint(
                greaterThanOrEqualTo: imageView.bottomAnchor,
                constant: SharePostConstants.Metrics.contentViewVerticalSpace),
            separatorView.topAnchor.constraint(
                greaterThanOrEqualTo: captionTextView.bottomAnchor,
                constant: SharePostConstants.Metrics.contentViewVerticalSpace),
            separatorView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: SharePostConstants.Metrics.separatorViewWidth),
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
        keyboardWillShowWith notification: NSNotification
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
        keyboardWillHideWith notification: NSNotification
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
        contentView.layoutIfNeeded()
        
        updateCaptionTextViewLayout()
    }
}

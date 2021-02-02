//
//  UploadPostView.swift
//  Instagram
//
//  Created by Admin on 01.02.2021.
//

import UIKit

final class UploadPostView: UIView {
    // MARK: Properties
    
    private var contentViewBottomConstraint: NSLayoutConstraint?
    private var descriptionTextViewFixedBottomConstraint: NSLayoutConstraint?
    private var descriptionTextViewScrollableBottomConstraint: NSLayoutConstraint?
    
    private var keyboardAppearanceListener: KeyboardAppearanceListener?
    
    // MARK: Subviews
    
    private let contentView = UIView()
    private let imageView = UIImageView()
    private let descriptionTextView = PlaceholderTextView()
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

extension UploadPostView {
    func setMediaFile(_ mediaFile: MediaFileType) {
        switch mediaFile {
        case .image(let image):
            imageView.image = image
        }
    }
}

// MARK: - Private Methods

private extension UploadPostView {
    private func setupKeyboardHandlers() {
        keyboardAppearanceListener = KeyboardAppearanceListener(delegate: self)
    }
}

// MARK: - Appearance

private extension UploadPostView {
    func setupAppearance() {
        backgroundColor = .systemBackground
        
        setupImageViewAppearance()
        setupDescriptionTextViewAppearance()
        setupSeparatorViewAppearance()
    }
    
    func setupImageViewAppearance() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UploadPostConstants.Colors.imageViewBorder.cgColor
        imageView.layer.borderWidth = UploadPostConstants.Metrics.imageViewBorderWidth
    }
    
    func setupDescriptionTextViewAppearance() {
        descriptionTextView.placeholderText = UploadPostConstants.Constants.descriptionTextViewPlaceholder
        descriptionTextView.delegate = self
    }
    
    func setupSeparatorViewAppearance() {
        separatorView.backgroundColor = UploadPostConstants.Colors.separatorViewBackground
    }
}

// MARK: - Layout

private extension UploadPostView {
    func setupLayout() {
        setupSubviews()
        
        setupContentViewLayout()
        setupImageViewLayout()
        setupDescriptionTextViewLayout()
        setupSeparatorViewLayout()
    }
    
    func setupSubviews() {
        addSubview(contentView)
        
        contentView.addSubview(imageView)
        contentView.addSubview(descriptionTextView)
        contentView.addSubview(separatorView)
    }
    
    func setupContentViewLayout() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(
                equalTo: safeAreaLayoutGuide.topAnchor,
                constant: UploadPostConstants.Metrics.contentViewVerticalSpace),
            contentView.leadingAnchor.constraint(
                equalTo: safeAreaLayoutGuide.leadingAnchor,
                constant: UploadPostConstants.Metrics.contentViewHorizontalSpace),
            contentView.trailingAnchor.constraint(
                equalTo: safeAreaLayoutGuide.trailingAnchor,
                constant: -UploadPostConstants.Metrics.contentViewHorizontalSpace),
        ])
        
        contentViewBottomConstraint = contentView.bottomAnchor.constraint(
            equalTo: safeAreaLayoutGuide.bottomAnchor,
            constant: -UploadPostConstants.Metrics.contentViewVerticalSpace)
        
        contentViewBottomConstraint?.isActive = true
    }
    
    func setupImageViewLayout() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(
                equalTo: descriptionTextView.leadingAnchor,
                constant: -UploadPostConstants.Metrics.imageViewTrailingSpace),
            imageView.centerYAnchor.constraint(equalTo: descriptionTextView.centerYAnchor),
            imageView.heightAnchor.constraint(equalToConstant: UploadPostConstants.Metrics.imageViewSize),
            imageView.widthAnchor.constraint(equalToConstant: UploadPostConstants.Metrics.imageViewSize),
        ])
    }
    
    func setupDescriptionTextViewLayout() {
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            descriptionTextView.topAnchor.constraint(equalTo: contentView.topAnchor),
            descriptionTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
        
        descriptionTextViewFixedBottomConstraint = descriptionTextView.bottomAnchor.constraint(
            lessThanOrEqualTo: contentView.bottomAnchor)
        
        descriptionTextViewScrollableBottomConstraint = descriptionTextView.bottomAnchor.constraint(
            equalTo: contentView.bottomAnchor)
        
        applyDescriptionTextViewFixedLayout()
    }
    
    func updateDescriptionTextViewLayout() {
        if contentView.frame.height <= descriptionTextView.contentSize.height {
            applyDescriptionTextViewScrollableLayout()
        } else {
            applyDescriptionTextViewFixedLayout()
        }
        
        UIView.animate(withDuration: UploadPostConstants.Constants.layoutUpdateAnimationDuration) {
            self.layoutIfNeeded()
        }
    }
    
    func applyDescriptionTextViewFixedLayout() {
        descriptionTextView.isScrollEnabled = false
        
        descriptionTextViewScrollableBottomConstraint?.isActive = false
        descriptionTextViewFixedBottomConstraint?.isActive = true
        
        descriptionTextView.invalidateIntrinsicContentSize()
    }
    
    func applyDescriptionTextViewScrollableLayout() {
        descriptionTextView.isScrollEnabled = true
        
        descriptionTextViewFixedBottomConstraint?.isActive = false
        descriptionTextViewScrollableBottomConstraint?.isActive = true
        
        descriptionTextView.invalidateIntrinsicContentSize()
    }
    
    func setupSeparatorViewLayout() {
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            separatorView.topAnchor.constraint(
                equalTo: descriptionTextView.bottomAnchor,
                constant: UploadPostConstants.Metrics.contentViewVerticalSpace),
            separatorView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: UploadPostConstants.Metrics.separatorViewWidth),
        ])
    }
}

// MARK: - UITextViewDelegate

extension UploadPostView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        updateDescriptionTextViewLayout()
    }
}

// MARK: - KeyboardAppearanceListenerDelegate

extension UploadPostView: KeyboardAppearanceListenerDelegate {
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
        
        updateDescriptionTextViewLayout()
    }
}

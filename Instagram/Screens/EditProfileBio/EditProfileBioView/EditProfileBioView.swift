//
//  EditProfileBioView.swift
//  Instagram
//
//  Created by Admin on 07.03.2021.
//

import UIKit

protocol EditProfileBioViewProtocol: UIView {
    var bio: String? { get set }
    var characterLimit: Int { get set }
}

protocol EditProfileBioViewOutputProtocol: AnyObject {
    func characterLimitReached()
    func characterLimitResets()
}

final class EditProfileBioView: UIView, EditProfileBioViewProtocol {
    // MARK: Properties
    
    weak var output: EditProfileBioViewOutputProtocol?
    
    var bio: String? {
        get {
            return bioTextView.text
        }
        set {
            bioTextView.text = newValue
            characterCounterLabel.text = String(newValue?.count ?? 0)
        }
    }
    
    var characterLimit: Int = .max
    
    // Fix view layout glitch when calling layoutIfNeeded() when calling becomeFirstResponder()
    private var isBecomeFirstResponder = false
    
    private var characterCounterLabelFixedTopConstraint: NSLayoutConstraint?
    private var characterCounterLabelScrollableTopConstraint: NSLayoutConstraint?
    private var contentViewBottomConstraint: NSLayoutConstraint?
    
    private lazy var keyboardAppearanceListener = KeyboardAppearanceListener(delegate: self)
    
    // MARK: Constants
    
    private enum Metrics {
        static let bioTextViewHorizontalSpace: CGFloat = 2
        static let bioTextViewFontSize: CGFloat = 16
        
        static let characterCounterLabelVerticalSpace: CGFloat = 4
        static let characterCounterLabelTrailingSpace: CGFloat = 8
        
        static let separatorViewHeight: CGFloat = 0.5
    }
    
    private enum Constants {
        static let bioTextViewAnimationDuration: TimeInterval = 0.1
        static let contentViewAnimationDuration: TimeInterval = 0.2
    }
    
    // MARK: Subviews
    
    private let contentView = UIView()
    private let bioTextView = UITextView()
    private let separatorView = UIView()
    private let characterCounterLabel = UILabel()
    
    // MARK: Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupAppearance()
        setupLayout()
        setupEndEditingGesture()
        keyboardAppearanceListener.setupKeyboardObservers()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Appearance

private extension EditProfileBioView {
    func setupAppearance() {
        backgroundColor = .systemBackground
        
        setupBioTextViewAppearance()
        setupSeparatorViewAppearance()
    }
    
    func setupBioTextViewAppearance() {
        bioTextView.font = .systemFont(ofSize: Metrics.bioTextViewFontSize)
        bioTextView.becomeFirstResponder()
        
        bioTextView.delegate = self
    }
    
    func setupSeparatorViewAppearance() {
        separatorView.backgroundColor = .systemBlue
    }
    
    func updateCharacterCounterLabelAppearance(count: Int) {
        characterCounterLabel.text = (count == 0) ? nil : String(count)
        characterCounterLabel.textColor = (count < characterLimit) ? .black : .red
    }
}

// MARK: - Layout

private extension EditProfileBioView {
    func setupLayout() {
        setupSubviews()
        
        setupContentViewLayout()
        setupBioTextViewLayout()
        setupSeparatorViewLayout()
        setupCharacterCounterLabelLayout()
    }
    
    func setupSubviews() {
        addSubview(contentView)
        
        contentView.addSubview(bioTextView)
        contentView.addSubview(separatorView)
        contentView.addSubview(characterCounterLabel)
    }
    
    func setupContentViewLayout() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
        ])
        
        contentViewBottomConstraint = contentView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        contentViewBottomConstraint?.isActive = true
    }
    
    func setupBioTextViewLayout() {
        bioTextView.translatesAutoresizingMaskIntoConstraints = false
        bioTextView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        
        NSLayoutConstraint.activate([
            bioTextView.topAnchor.constraint(equalTo: contentView.topAnchor),
            bioTextView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: Metrics.bioTextViewHorizontalSpace),
            bioTextView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -Metrics.bioTextViewHorizontalSpace),
        ])
    }
    
    func setupSeparatorViewLayout() {
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            separatorView.topAnchor.constraint(equalTo: bioTextView.bottomAnchor),
            separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: Metrics.separatorViewHeight),
        ])
    }
    
    func setupCharacterCounterLabelLayout() {
        characterCounterLabel.translatesAutoresizingMaskIntoConstraints = false
        characterCounterLabel.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        
        NSLayoutConstraint.activate([
            characterCounterLabel.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -Metrics.characterCounterLabelVerticalSpace),
            characterCounterLabel.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -Metrics.characterCounterLabelTrailingSpace),
        ])
        
        characterCounterLabelFixedTopConstraint = characterCounterLabel.topAnchor.constraint(
            greaterThanOrEqualTo: separatorView.bottomAnchor,
            constant: Metrics.characterCounterLabelVerticalSpace)
        
        characterCounterLabelScrollableTopConstraint = characterCounterLabel.topAnchor.constraint(
            equalTo: separatorView.bottomAnchor,
            constant: Metrics.characterCounterLabelVerticalSpace)
        
        applyBioTextViewFixedLayout()
    }
    
    func updateBioTextViewLayout() {
        layoutIfNeeded()
        
        let counterHeight = characterCounterLabel.frame.height + 2 * Metrics.characterCounterLabelVerticalSpace
        let contentViewHeight = contentView.frame.height - separatorView.frame.height - counterHeight
        
        if contentViewHeight <= bioTextView.contentSize.height {
            applyBioTextViewScrollableLayout()
        } else {
            applyBioTextViewFixedLayout()
        }
        
        UIView.animate(withDuration: Constants.bioTextViewAnimationDuration) {
            self.layoutIfNeeded()
        }
    }
    
    func applyBioTextViewFixedLayout() {
        bioTextView.isScrollEnabled = false
        
        characterCounterLabelScrollableTopConstraint?.isActive = false
        characterCounterLabelFixedTopConstraint?.isActive = true
        
        bioTextView.invalidateIntrinsicContentSize()
    }
    
    func applyBioTextViewScrollableLayout() {
        bioTextView.isScrollEnabled = true
        
        characterCounterLabelFixedTopConstraint?.isActive = false
        characterCounterLabelScrollableTopConstraint?.isActive = true
        
        bioTextView.invalidateIntrinsicContentSize()
    }
}

// MARK: - UITextViewDelegate

extension EditProfileBioView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        updateBioTextViewLayout()
        updateCharacterCounterLabelAppearance(count: textView.text.count)
        
        if textView.text.count < characterLimit {
            output?.characterLimitResets()
        } else {
            output?.characterLimitReached()
        }
    }
}

// MARK: - KeyboardAppearanceListenerDelegate

extension EditProfileBioView: KeyboardAppearanceListenerDelegate {
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
        updateContentViewLayout(bottomConstant: 0)
    }
    
    private func updateContentViewLayout(bottomConstant: CGFloat) {
        // Fix view layout glitch when calling layoutIfNeeded() when calling becomeFirstResponder()
        if !isBecomeFirstResponder {
            isBecomeFirstResponder = true
            
            contentViewBottomConstraint?.constant = bottomConstant
        } else {
            layoutIfNeeded()
            
            contentViewBottomConstraint?.constant = bottomConstant
            
            UIView.animate(withDuration: Constants.contentViewAnimationDuration) {
                self.layoutIfNeeded()
            }
        }
    }
}

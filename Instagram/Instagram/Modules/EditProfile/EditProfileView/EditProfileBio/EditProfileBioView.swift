//
//  EditProfileBioView.swift
//  Instagram
//
//  Created by Admin on 07.03.2021.
//

import UIKit

final class EditProfileBioView: UIView {
    // MARK: Properties
    
    private var keyboardAppearanceListener: KeyboardAppearanceListener?
    
    // MARK: Subviews
    
    private let bioTextView = PlaceholderTextView()
    private let separatorView = UIView()
    private let characterCounterLabel = UILabel()
    
    // MARK: Initialization
    
    init() {
        super.init(frame: .zero)
        
        setupAppearance()
        setupLayout()
        setupGestures()
        
        keyboardAppearanceListener = KeyboardAppearanceListener(delegate: self)
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
        bioTextView.placeholderText = "Enter bio..."
        bioTextView.font = .systemFont(ofSize: 16)
        bioTextView.isScrollEnabled = false
        
        bioTextView.delegate = self
    }
    
    func setupSeparatorViewAppearance() {
        separatorView.backgroundColor = .systemGray4
    }
}

// MARK: - Layout

private extension EditProfileBioView {
    func setupLayout() {
        setupSubviews()
        
        setupBioTextViewLayout()
        setupSeparatorViewLayout()
        setupCharacterCounterLabelLayout()
    }
    
    func setupSubviews() {
        addSubview(bioTextView)
        addSubview(separatorView)
        addSubview(characterCounterLabel)
    }
    
    func setupBioTextViewLayout() {
        bioTextView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            bioTextView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            bioTextView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 2),
            bioTextView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -2),
        ])
    }
    
    func setupSeparatorViewLayout() {
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            separatorView.topAnchor.constraint(equalTo: bioTextView.bottomAnchor),
            separatorView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1),
        ])
    }
    
    func setupCharacterCounterLabelLayout() {
        characterCounterLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            characterCounterLabel.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 4),
            characterCounterLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -8),
        ])
    }
}

// MARK: - Gestures

private extension EditProfileBioView {
    func setupGestures() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func dismissKeyboard() {
        endEditing(true)
    }
}

// MARK: - UITextViewDelegate

extension EditProfileBioView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        characterCounterLabel.text = textView.text.isEmpty ? nil : textView.text.count.description
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
        
        
    }
    
    func keyboardAppearanceListener(
        _ listener: KeyboardAppearanceListener,
        keyboardWillHideWith notification: Notification
    ) {
        
    }
}

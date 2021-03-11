//
//  SecureTextField.swift
//  Instagram
//
//  Created by Admin on 26.01.2021.
//

import UIKit

final class SecureTextField: UITextField {
    // MARK: Properties

    override var isSecureTextEntry: Bool {
        didSet {
            if isFirstResponder {
                becomeFirstResponder()
            }
            
            eyeButton.setImage(isSecureTextEntry ? Images.eyeClose : Images.eyeOpen, for: .normal)
            eyeButton.tintColor = isSecureTextEntry ? Colors.eyeCloseButtonTint : Colors.eyeOpenButtonTint
        }
    }
    
    // MARK: Constants
    
    private enum Metrics {
        static let eyeButtonRightInset: CGFloat = 4
        static let eyeButtonImageInsets: CGFloat = 2
    }
    
    private enum Images {
        static let eyeOpen = UIImage(systemName: "eye.fill")
        static let eyeClose = UIImage(systemName: "eye.slash.fill")
    }
    
    private enum Colors {
        static let eyeOpenButtonTint = UIColor.darkGray
        static let eyeCloseButtonTint = UIColor.systemGray3
    }

    // MARK: Subviews
    
    private let containerButton = UIButton()
    private let eyeButton = UIButton(type: .system)
    
    // MARK: Lifecycle
    
    init(isSecureTextEntry: Bool = true) {
        super.init(frame: .zero)
        
        self.isSecureTextEntry = isSecureTextEntry
        
        setupRightViewLayout()
        setupEyeButtonAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @discardableResult override func becomeFirstResponder() -> Bool {
        let success = super.becomeFirstResponder()
        
        if isSecureTextEntry, let enteredText = text {
            text?.removeAll()
            insertText(enteredText)
        }
        
        return success
    }
}

// MARK: - Layout

private extension SecureTextField {
    func setupRightViewLayout() {
        eyeButton.translatesAutoresizingMaskIntoConstraints = false
        eyeButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: Metrics.eyeButtonRightInset)
        eyeButton.imageEdgeInsets = UIEdgeInsets(
            top: Metrics.eyeButtonImageInsets,
            left: Metrics.eyeButtonImageInsets,
            bottom: Metrics.eyeButtonImageInsets,
            right: Metrics.eyeButtonImageInsets + 1)
        
        rightView = eyeButton
        rightViewMode = .always
    }
}

// MARK: - Button Actions

private extension SecureTextField {
    func setupEyeButtonAction() {
        eyeButton.addAction(UIAction { [weak self] _ in
            self?.isSecureTextEntry.toggle()
        }, for: .touchUpInside)
    }
}

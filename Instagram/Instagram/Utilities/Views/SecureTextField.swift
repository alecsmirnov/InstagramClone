//
//  SecureTextField.swift
//  Instagram
//
//  Created by Admin on 26.01.2021.
//

import UIKit

final class SecureTextField: UITextField {
    // MARK: Properties
    
    var isSecurityControlHidden: Bool {
        get {
            return eyeButton.isHidden
        }
        set {
            eyeButton.isHidden = newValue
        }
    }

    override var isSecureTextEntry: Bool {
        didSet {
            if isFirstResponder {
                becomeFirstResponder()
            }
            
            if !isSecurityControlHidden {
                setupEyeButtonAppearance()
            }
        }
    }
    
    // MARK: Constants
    
    private enum Metrics {
        static let stackViewSpace: CGFloat = 5
        static let stackViewFillingViewWidth: CGFloat = 2
    }
    
    private enum Images {
        static let eyeOpen = UIImage(systemName: "eye.fill")
        static let eyeClose = UIImage(systemName: "eye.slash.fill")
        
        static let clear = UIImage(systemName: "xmark.circle")
    }
    
    private enum Colors {
        static let eyeOpenButtonTint = UIColor.darkGray
        static let eyeCloseButtonTint = UIColor.systemGray3
        
        static let clearButtonTint = UIColor(red: 0.99, green: 0.11, blue: 0.11, alpha: 1)
    }
    
    private enum Constants {
        static let clearButtonAnimationDuration = 0.2
    }

    // MARK: Subviews
    
    let stackView = UIStackView()
    
    private let eyeButton = UIButton(type: .system)
    private let clearButton = UIButton(type: .system)
    
    // MARK: Initialization
    
    init(isSecurityControlHidden: Bool = true, isSecureTextEntry: Bool = false) {
        super.init(frame: .zero)
        
        self.isSecurityControlHidden = isSecurityControlHidden
        self.isSecureTextEntry = isSecureTextEntry
        
        setupAppearance()
        setupLayout()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public Methods

extension SecureTextField {
    @discardableResult override func becomeFirstResponder() -> Bool {
        let success = super.becomeFirstResponder()
        
        if isSecureTextEntry, let enteredText = text {
            text?.removeAll()
            insertText(enteredText)
        }
        
        return success
    }
}

// MARK: - Appearance

private extension SecureTextField {
    func setupAppearance() {
        setupEyeButtonAppearance()
        setupCloseButtonAppearance()
    }
    
    func setupEyeButtonAppearance() {
        eyeButton.setImage(isSecureTextEntry ? Images.eyeClose : Images.eyeOpen, for: .normal)
        eyeButton.tintColor = isSecureTextEntry ? Colors.eyeCloseButtonTint : Colors.eyeOpenButtonTint
    }
    
    func setupCloseButtonAppearance() {
        clearButton.setImage(Images.clear, for: .normal)
        clearButton.tintColor = Colors.clearButtonTint
        clearButton.isHidden = true
    }
}

// MARK: - Layout

private extension SecureTextField {
    func setupLayout() {
        rightView = createRightView()
        rightViewMode = .always
    }
    
    func createRightView() -> UIView {
        let stackViewFillingView = SecureTextField.createStackViewFillingView()
        let stackView = UIStackView(arrangedSubviews: [eyeButton, clearButton, stackViewFillingView])
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = Metrics.stackViewSpace
        
        return stackView
    }
    
    static func createStackViewFillingView() -> UIView {
        let fillingView = UIView()
        
        fillingView.translatesAutoresizingMaskIntoConstraints = false
        fillingView.widthAnchor.constraint(equalToConstant: Metrics.stackViewFillingViewWidth).isActive = true
        
        return fillingView
    }
}

// MARK: - Actions

private extension SecureTextField {
    func setupActions() {
        addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        eyeButton.addTarget(self, action: #selector(didPressSendButton), for: .touchUpInside)
        clearButton.addTarget(self, action: #selector(didPressClearButton), for: .touchUpInside)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        clearButton.isHidden = text?.isEmpty ?? true
        
        UIView.animate(withDuration: Constants.clearButtonAnimationDuration) { [self] in
            clearButton.alpha = clearButton.isHidden ? 0 : 1
        }
    }
    
    @objc func didPressSendButton() {
        isSecureTextEntry.toggle()
    }
    
    @objc func didPressClearButton() {
        text?.removeAll()
        
        sendActions(for: .editingChanged)
    }
}

//
//  LoginRegistrationBaseView.swift
//  Instagram
//
//  Created by Admin on 24.01.2021.
//

import UIKit

class LoginRegistrationBaseView: UIView {
    // MARK: Initialization
    
    init() {
        super.init(frame: .zero)
        
        setupGestures()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Gestures

private extension LoginRegistrationBaseView {
    func setupGestures() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGestureRecognizer.cancelsTouchesInView = false
        
        addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func dismissKeyboard() {
        endEditing(true)
    }
}

// MARK: - Appearance Helpers

internal extension LoginRegistrationBaseView {
    static func setupStackViewTextFieldAppearance(_ textField: UITextField, placeholder: String) {
        textField.placeholder = placeholder
        textField.borderStyle = .roundedRect
        textField.backgroundColor = LoginRegistrationConstants.Colors.textFieldBackground
        textField.font = .systemFont(ofSize: LoginRegistrationConstants.Metrics.fontSize)
        textField.clearButtonMode = .whileEditing
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
    }
}

// MARK: - Layout Helpers

internal extension LoginRegistrationBaseView {
    static func setupStackViewSubviewLayout(_ subview: UIView, height: CGFloat) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        
        subview.heightAnchor.constraint(equalToConstant: height).isActive = true
    }
}

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
    
    static func insertSubviewToStackView(_ subview: UIView, stackView: UIStackView, below view: UIView) {
        if let index = stackView.arrangedSubviews.firstIndex(of: view) {
            stackView.insertArrangedSubview(subview, at: index + 1)
        }
    }
    
    static func removeSubviewFromStackView(_ subview: UIView, stackView: UIStackView) {
        stackView.removeArrangedSubview(subview)
        subview.removeFromSuperview()
    }
}

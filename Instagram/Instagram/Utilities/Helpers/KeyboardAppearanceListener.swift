//
//  KeyboardAppearanceListener.swift
//  Instagram
//
//  Created by Admin on 24.01.2021.
//

import UIKit

protocol KeyboardAppearanceListenerDelegate: AnyObject {
    func keyboardAppearanceListener(
        _ listener: KeyboardAppearanceListener,
        keyboardWillShowWith notification: NSNotification)
    func keyboardAppearanceListener(
        _ listener: KeyboardAppearanceListener,
        keyboardWillHideWith notification: NSNotification)
}

final class KeyboardAppearanceListener {
    // MARK: Properties
    
    private weak var delegate: KeyboardAppearanceListenerDelegate?
    
    // MARK: Initialization
    
    init(delegate: KeyboardAppearanceListenerDelegate) {
        self.delegate = delegate
        
        setupKeyboardObservers()
    }
    
    deinit {
        removeKeyboardObservers()
    }
}

// MARK: - Private Methods

private extension KeyboardAppearanceListener {
    func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func removeKeyboardObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        delegate?.keyboardAppearanceListener(self, keyboardWillShowWith: notification)
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        delegate?.keyboardAppearanceListener(self, keyboardWillHideWith: notification)
    }
}

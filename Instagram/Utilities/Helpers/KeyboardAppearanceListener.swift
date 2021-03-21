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
        keyboardWillShowWith notification: Notification)
    func keyboardAppearanceListener(
        _ listener: KeyboardAppearanceListener,
        keyboardWillHideWith notification: Notification)
}

final class KeyboardAppearanceListener {
    // MARK: Properties
    
    private weak var delegate: KeyboardAppearanceListenerDelegate?
    
    // MARK: Initialization
    
    init(delegate: KeyboardAppearanceListenerDelegate) {
        self.delegate = delegate
    }
    
    deinit {
        removeKeyboardObservers()
    }
}

// MARK: - Public Methods

extension KeyboardAppearanceListener {
    func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillShowNotification,
            object: nil,
            queue: nil) { [weak self] notification in
            guard let self = self else { return }
            
            self.delegate?.keyboardAppearanceListener(self, keyboardWillShowWith: notification)
        }
        
        NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillHideNotification,
            object: nil,
            queue: nil) { [weak self] notification in
            guard let self = self else { return }
            
            self.delegate?.keyboardAppearanceListener(self, keyboardWillHideWith: notification)
        }
    }
    
    func removeKeyboardObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

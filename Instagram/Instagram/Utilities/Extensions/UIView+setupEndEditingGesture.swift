//
//  UIView+setupEndEditingGesture.swift
//  Instagram
//
//  Created by Admin on 11.03.2021.
//

import UIKit

extension UIView {
    func setupEndEditingGesture(cancelsTouchesInView: Bool = true) {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        tapGestureRecognizer.cancelsTouchesInView = false
        
        addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func dismissKeyboard() {
        endEditing(true)
    }
}

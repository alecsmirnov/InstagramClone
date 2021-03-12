//
//  UITextField+.swift
//  Instagram
//
//  Created by Admin on 11.03.2021.
//

import UIKit

extension UITextField {
    func inputStyle(placeholder: String?, returnKeyType: UIReturnKeyType = .default) {
        self.placeholder = placeholder
        self.returnKeyType = returnKeyType
        borderStyle = .roundedRect
        backgroundColor = LoginRegistrationConstants.Colors.textFieldBackground
        font = .systemFont(ofSize: LoginRegistrationConstants.Metrics.textFieldFontSize)
        autocorrectionType = .no
        autocapitalizationType = .none
    }
}

//
//  UILabel+.swift
//  Instagram
//
//  Created by Admin on 11.03.2021.
//

import UIKit

extension UILabel {
    func warningStyle() {
        font = .systemFont(ofSize: LoginRegistrationConstants.Metrics.warningLabelFontSize)
        textColor = LoginRegistrationConstants.Colors.warningTextColor
    }
}

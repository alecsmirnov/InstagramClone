//
//  UIButton+mainStyle.swift
//  Instagram
//
//  Created by Admin on 11.03.2021.
//

import UIKit

extension UIButton {
    func mainStyle(title: String) {
        setTitle(title, for: .normal)
        setTitleColor(LoginRegistrationConstants.Colors.mainButtonTitle, for: .normal)
        titleLabel?.font = .boldSystemFont(ofSize: LoginRegistrationConstants.Metrics.fontSize)
        backgroundColor = LoginRegistrationConstants.Colors.mainButtonBackground
        layer.cornerRadius = LoginRegistrationConstants.Metrics.mainButtonCornerRadius
    }
    
    func extraStyle(firstTitle: String, secondTitle: String) {
        twoPartTitle(
            firstPartText: firstTitle,
            firstPartFont: .systemFont(ofSize: LoginRegistrationConstants.Metrics.fontSize),
            firstPartColor: LoginRegistrationConstants.Colors.extendButtonFirstPart,
            secondPartText: secondTitle,
            secondPartFont: .boldSystemFont(ofSize: LoginRegistrationConstants.Metrics.fontSize),
            secondPartColor: LoginRegistrationConstants.Colors.extendButtonSecondPart,
            partDivider: " ")
    }
    
    func enable() {
        isEnabled = true
        alpha = LoginRegistrationConstants.Constants.mainButtonEnableAlpha
    }
    
    func disable() {
        isEnabled = false
        alpha = LoginRegistrationConstants.Constants.mainButtonDisableAlpha
    }
}

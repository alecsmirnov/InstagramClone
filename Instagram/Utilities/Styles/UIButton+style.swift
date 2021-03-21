//
//  UIButton+mainStyle.swift
//  Instagram
//
//  Created by Admin on 11.03.2021.
//

import UIKit

extension UIButton {
    func mainStyle(title: String, fontSize: CGFloat = UIFont.buttonFontSize) {
        setTitle(title, for: .normal)
        setTitleColor(AppConstants.Colors.roundedButtonMainTitle, for: .normal)
        titleLabel?.font = .boldSystemFont(ofSize: fontSize)
        backgroundColor = AppConstants.Colors.roundedButtonMainBackground
        layer.cornerRadius = AppConstants.Metrics.roundedButtonCornerRadius
        layer.borderColor = AppConstants.Colors.roundedButtonMainBorder.cgColor
        layer.borderWidth = 0
    }
    
    func additionalStyle(title: String, fontSize: CGFloat = UIFont.buttonFontSize) {
        setTitle(title, for: .normal)
        setTitleColor(AppConstants.Colors.roundedButtonExtraTitle, for: .normal)
        titleLabel?.font = .boldSystemFont(ofSize: fontSize)
        backgroundColor = AppConstants.Colors.roundedButtonAdditionalBackground
        layer.cornerRadius = AppConstants.Metrics.roundedButtonCornerRadius
        layer.borderColor = AppConstants.Colors.roundedButtonAdditionalBorder.cgColor
        layer.borderWidth = AppConstants.Metrics.roundedButtonBorderWidth
    }
    
    func extraStyle(firstTitle: String, secondTitle: String) {
        twoPartTitle(
            firstPartText: firstTitle,
            firstPartFont: .systemFont(ofSize: LoginRegistrationConstants.Metrics.extraButtonFontSize),
            firstPartColor: LoginRegistrationConstants.Colors.extraButtonFirstTitle,
            secondPartText: secondTitle,
            secondPartFont: .boldSystemFont(ofSize: LoginRegistrationConstants.Metrics.extraButtonFontSize),
            secondPartColor: LoginRegistrationConstants.Colors.extraButtonSecondTitle,
            partDivider: " ")
    }
    
    func enable() {
        isEnabled = true
        alpha = AppConstants.Constants.roundedButtonEnableAlpha
    }
    
    func disable() {
        isEnabled = false
        alpha = AppConstants.Constants.roundedButtonDisableAlpha
    }
    
    func largeProfileImageStyle() {
        setImage(AppConstants.Images.profileDefault, for: .normal)
        tintColor = AppConstants.Colors.profileImageButtonTint
        contentMode = .scaleAspectFill
        layer.cornerRadius = AppConstants.Metrics.profileImageLargeSize / 2
        layer.masksToBounds = true
        layer.borderColor = AppConstants.Colors.profileImageBorder.cgColor
        layer.borderWidth = AppConstants.Metrics.profileImageBorderWidth
    }
}

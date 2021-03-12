//
//  LoginRegistrationConstants.swift
//  Instagram
//
//  Created by Admin on 24.01.2021.
//

import UIKit

enum LoginRegistrationConstants {
    enum Metrics {
        static let profileImageButtonSize: CGFloat = AppConstants.Metrics.profileImageLargeSize
        
        static let containerViewNegativeTopSpace: CGFloat = 100
        static let containerViewHorizontalSpace: CGFloat = 20
        
        static let logoImageViewBottomSpace: CGFloat = 20
        
        static let inputItemTopSpace: CGFloat = 6
        static let inputItemHeight: CGFloat = 40
        
        static let mainButtonTopSpace: CGFloat = 16
        static let extraButtonVerticalSpace: CGFloat = 10
        
        static let separatorViewWidth: CGFloat = 1
        
        static let textFieldFontSize: CGFloat = 14
        static let mainButtonFontSize: CGFloat = 14
        static let extraButtonFontSize: CGFloat = 14
        static let warningLabelFontSize: CGFloat = 12
    }
    
    enum Images {
        static let logo = AppConstants.Images.logo
        static let profileDefault = AppConstants.Images.profileDefault
    }
    
    enum Colors {
        static let separatorViewBackground = AppConstants.Colors.separatorViewBackground
        
        static let textFieldBackground = UIColor(white: 0, alpha: 0.02)
        
        static let extraButtonFirstTitle = UIColor.systemGray
        static let extraButtonSecondTitle = UIColor.black
        
        static let warningTextColor = UIColor(red: 0.99, green: 0.11, blue: 0.11, alpha: 1)
    }
    
    enum Constants {
        static let textFieldInputDelay: TimeInterval = 0.6
        
        static let scrollViewAnimationDuration: TimeInterval = 0.25
        
        static let loginKeyboardInsetSqueezeCoefficient: CGFloat = 1.5
        static let registrationKeyboardInsetSqueezeCoefficient: CGFloat = 2
    }
}

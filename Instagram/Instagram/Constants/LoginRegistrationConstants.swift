//
//  LoginRegistrationConstants.swift
//  Instagram
//
//  Created by Admin on 24.01.2021.
//

import UIKit

enum LoginRegistrationConstants {
    enum Metrics {
        static let containerViewNegativeTopSpace: CGFloat = 100
        static let containerViewHorizontalSpace: CGFloat = 20
        
        static let logoImageViewBottomSpace: CGFloat = 20
        
        static let profileImageButtonSize: CGFloat = 110
        static let profileImageButtonBorderWidth: CGFloat = 1
        
        static let inputItemTopSpace: CGFloat = 6
        static let inputItemHeight: CGFloat = 40
        
        static let mainButtonTopSpace: CGFloat = 16
        static let mainButtonCornerRadius: CGFloat = 4
        static let extraButtonVerticalSpace: CGFloat = 10
        
        static let separatorViewWidth: CGFloat = 1.4
        
        static let fontSize: CGFloat = 14
        static let alertFontSize: CGFloat = 12
    }
    
    enum Colors {
        static let profileImageButtonTint = UIColor(white: 0, alpha: 0.9)
        static let profileImageButtonBorder = UIColor.systemGray5
        
        static let textFieldBackground = UIColor(white: 0, alpha: 0.02)
        
        static let mainButtonTitle = UIColor.white
        static let mainButtonBackground = UIColor(red: 0.25, green: 0.36, blue: 0.9, alpha: 1)
        
        static let separatorViewBackground = UIColor.systemGray5
        
        static let extendButtonFirstPart = UIColor.systemGray
        static let extendButtonSecondPart = UIColor.black
        
        static let alert = UIColor(red: 0.99, green: 0.11, blue: 0.11, alpha: 1)
    }
    
    enum Images {
        static let profile = UIImage(named: "profile_default")
    }
    
    enum Constants {
        static let mainButtonEnableAlpha: CGFloat = 1
        static let mainButtonDisableAlpha: CGFloat = 0.4
        
        static let textFieldInputDelay: TimeInterval = 0.6
        
        static let scrollViewAnimationDuration: TimeInterval = 0.25
    }
}

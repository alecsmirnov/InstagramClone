//
//  LoginRegistrationConstants.swift
//  Instagram
//
//  Created by Admin on 24.01.2021.
//

import UIKit

enum LoginRegistrationConstants {
    enum Metrics {
        static let profileImageButtonSize: CGFloat = 110
        static let profileImageButtonBorderWidth: CGFloat = 1
        
        static let stackViewTopSpace: CGFloat = 20
        static let stackViewHorizontalSpace: CGFloat = 20
        static let stackViewSpace: CGFloat = 6
        static let stackViewPasswordTextFieldSpace: CGFloat = 16
        static let stackViewSubviewHeight: CGFloat = 40
        
        static let mainButtonCornerRadius: CGFloat = 4
        static let extraButtonVerticalSpace: CGFloat = 10
        
        static let separatorViewWidth: CGFloat = 1.5
        
        static let fontSize: CGFloat = 14
        static let alertFontSize: CGFloat = 12
    }
    
    enum Colors {
        static let profileImageButtonTint = UIColor(white: 0, alpha: 0.9)
        static let profileImageButtonBorder = UIColor.systemGray5
        
        static let textFieldBackground = UIColor(white: 0, alpha: 0.02)
        
        static let mainButtonTitle = UIColor.white
        static let mainButtonBackground = UIColor(red: 0.25, green: 0.36, blue: 0.9, alpha: 1)
        
        static let separatorView = UIColor.systemGray5
        
        static let alert = UIColor(red: 0.99, green: 0.11, blue: 0.11, alpha: 1)
    }
    
    enum TextFieldPlaceholders {
        static let email = "Email"
        static let fullName = "Full Name"
        static let username = "Username"
        static let password = "Password"
    }
    
    enum ButtonTitles {
        static let signUpMain = "Sign Up"
        static let signInMain = "Sign In"
        
        static let signUpExtra = "Don't have an account? Sign Up"
        static let signInExtra = "Already have an account? Sign In"
    }
    
    enum Images {
        static let logoBlack = UIImage(named: "instagram_logo_black")
        static let profile = UIImage(named: "profile_default")
    }
    
    enum Constants {
        static let mainButtonEnableAlpha: CGFloat = 1
        static let mainButtonDisableAlpha: CGFloat = 0.4
        
        static let textFieldInputDelay = 0.6
    }
}

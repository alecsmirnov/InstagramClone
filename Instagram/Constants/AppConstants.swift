//
//  AppConstants.swift
//  Instagram
//
//  Created by Admin on 11.03.2021.
//

import UIKit

enum AppConstants {
    enum Metrics {
        static let profileImageLargeSize: CGFloat = 110
        static let profileImageMediumSize: CGFloat = 80
        static let profileImageBorderWidth: CGFloat = 1
        
        static let roundedButtonCornerRadius: CGFloat = 4
        static let roundedButtonBorderWidth: CGFloat = 0.5
    }
    
    enum Images {
        static let logo = UIImage(named: "instagram_logo_black")
        static let logoMini = UIImage(named: "instagram_logo_black_mini")
        static let profileDefault = UIImage(named: "profile_default")
        static let close = UIImage(systemName: "xmark")
        static let comment = UIImage(named: "comment")
        static let menu = UIImage(named: "gear")
    }
    
    enum Colors {
        static let roundedButtonMainTitle = UIColor.white
        static let roundedButtonMainBackground = UIColor(red: 0.25, green: 0.36, blue: 0.9, alpha: 1)
        static let roundedButtonMainBorder = UIColor.clear
        
        static let roundedButtonAdditionalTitle = UIColor.black
        static let roundedButtonAdditionalBackground = UIColor.clear
        static let roundedButtonAdditionalBorder = UIColor.lightGray
        
        static let roundedButtonExtraTitle = UIColor.black
        
        static let profileImageBorder = UIColor.systemGray5
        static let profileImageButtonTint = UIColor(white: 0, alpha: 0.9)
        
        static let separatorViewBackground = UIColor.systemGray5
    }
    
    enum Constants {
        static let roundedButtonEnableAlpha: CGFloat = 1
        static let roundedButtonDisableAlpha: CGFloat = 0.4
    }
}

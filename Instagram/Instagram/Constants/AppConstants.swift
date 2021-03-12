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
        static let profileImageBorderWidth: CGFloat = 1
        
        static let roundedButtonCornerRadius: CGFloat = 4
    }
    
    enum Images {
        static let logo = UIImage(named: "instagram_logo_black")
        static let profileDefault = UIImage(named: "profile_default")
    }
    
    enum Colors {
        static let roundedButtonMainTitle = UIColor.white
        static let roundedButtonMainBackground = UIColor(red: 0.25, green: 0.36, blue: 0.9, alpha: 1)
        static let roundedButtonMainBorder = UIColor.clear
        
        static let roundedButtonExtraTitle = UIColor.black
        static let roundedButtonExtraBackground = UIColor.clear
        static let roundedButtonExtraBorder = UIColor.lightGray
        
        static let profileImageBorder = UIColor.systemGray5
        static let profileImageButtonTint = UIColor(white: 0, alpha: 0.9)
        
        static let separatorViewBackground = UIColor.systemGray5
    }
    
    enum Constants {
        static let roundedButtonEnableAlpha: CGFloat = 1
        static let roundedButtonDisableAlpha: CGFloat = 0.4
    }
}

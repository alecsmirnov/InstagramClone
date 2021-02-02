//
//  SharePostConstants.swift
//  Instagram
//
//  Created by Admin on 02.02.2021.
//

import UIKit

enum SharePostConstants {
    enum Metrics {
        static let contentViewVerticalSpace: CGFloat = 16
        static let contentViewHorizontalSpace: CGFloat = 16
        
        static let imageViewTrailingSpace: CGFloat = 8
        static let imageViewSize: CGFloat = 80
        static let imageViewBorderWidth: CGFloat = 1
        
        static let separatorViewWidth: CGFloat = 1
    }
    
    enum Colors {
        static let imageViewBorder = UIColor.systemGray5
        static let separatorViewBackground = UIColor.systemGray5
    }
    
    enum Constants {
        static let title = "New post"
        
        static let shareButtonTitle = "Share"
        
        static let captionTextViewPlaceholder = "Write a caption..."
        
        static let layoutUpdateAnimationDuration = 0.2
    }
}

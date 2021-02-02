//
//  UploadPostConstants.swift
//  Instagram
//
//  Created by Admin on 02.02.2021.
//

import UIKit

enum UploadPostConstants {
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
        static let separatorView = UIColor.systemGray5
    }
    
    enum Images {
        static let uploadButton = UIImage(systemName: "checkmark")
    }
    
    enum Constants {
        static let descriptionTextViewPlaceholder = "Enter description..."
        
        static let layoutUpdateAnimationDuration = 0.1
    }
}

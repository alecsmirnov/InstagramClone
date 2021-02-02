//
//  NewPostConstants.swift
//  Instagram
//
//  Created by Admin on 31.01.2021.
//

import UIKit

enum NewPostConstants {
    enum Metrics {
        static let gridCellSpace: CGFloat = 1.2
        
        static let gridCellSize = CGSize(
            width: UIScreen.main.bounds.width / CGFloat(Constants.columnsCount),
            height: UIScreen.main.bounds.width / CGFloat(Constants.columnsCount))
        
        static let nextButtonFontSize: CGFloat = 17.5
    }
    
    enum Images {
        static let closeButton = UIImage(systemName: "xmark")
    }
    
    enum Constants {
        static let title = "New post"
        
        static let columnsCount = 4
        
        static let nextButtonTitle = "Next"
        static let nextButtonAnimationDuration = 0.4
        static let nextButtonEnableAlpha: CGFloat = 1
        static let nextButtonDisableAlpha: CGFloat = 0.8
        
        static let selectedCellAlpha: CGFloat = 0.4
        static let unselectedCellAlpha: CGFloat = 1
    }
}

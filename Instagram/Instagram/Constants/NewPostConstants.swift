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
    }
    
    enum Images {
        static let closeButton = UIImage(systemName: "xmark")
        static let continueButton = UIImage(systemName: "arrow.right")
    }
    
    enum Constants {
        static let title = "New post"
        
        static let columnsCount = 4
        
        static let continueButtonEnableAlpha: CGFloat = 1
        static let continueButtonDisableAlpha: CGFloat = 0.6
        
        static let selectedCellAlpha: CGFloat = 0.4
        static let unselectedCellAlpha: CGFloat = 1
    }
}

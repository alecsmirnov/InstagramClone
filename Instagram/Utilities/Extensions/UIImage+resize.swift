//
//  UIImage+resize.swift
//  Instagram
//
//  Created by Admin on 20.01.2021.
//

import UIKit

extension UIImage {
    enum ResizeContentMode {
        case aspectFill
        case aspectFit
    }
    
    func resize(withWidth width: CGFloat, height: CGFloat, contentMode: ResizeContentMode) -> UIImage {
        let horizontalRatio = width / size.width
        let verticalRatio = height / size.height
        
        let ratio: CGFloat
        
        switch contentMode {
        case .aspectFill: ratio = max(horizontalRatio, verticalRatio)
        case .aspectFit: ratio = min(horizontalRatio, verticalRatio)
        }
        
        let newSize = CGSize(width: size.width * ratio, height: size.height * ratio)
        
        UIGraphicsBeginImageContextWithOptions(newSize, true, 0)
        
        draw(in: CGRect(origin: CGPoint.zero, size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}

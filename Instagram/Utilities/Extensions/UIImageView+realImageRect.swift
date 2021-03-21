//
//  UIImageView+realImageRect.swift
//  Instagram
//
//  Created by Admin on 08.02.2021.
//

import UIKit

extension UIImageView {
    func realImageRect() -> CGRect? {
        guard let imageSize = image?.size else { return nil }
        
        let horizontalRatio = frame.width / imageSize.width
        let verticalRatio = frame.height / imageSize.height
        
        let aspectRatio = min(horizontalRatio, verticalRatio)
        
        let imageRectSize = CGSize(width: imageSize.width * aspectRatio, height: imageSize.height * aspectRatio)
        let imageRectCenter = CGPoint(
            x: (frame.width - imageRectSize.width) / 2,
            y: (frame.height - imageRectSize.height) / 2)
        let imageRectOffset = CGPoint(x: frame.origin.x, y: frame.origin.y)
        
        let imageRect = CGRect(
            x: imageRectCenter.x + imageRectOffset.x,
            y: imageRectCenter.y + imageRectOffset.y,
            width: imageRectSize.width,
            height: imageRectSize.height)
        
        return imageRect
    }
}

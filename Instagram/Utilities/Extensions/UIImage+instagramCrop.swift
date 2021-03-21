//
//  UIImage+instagramCrop.swift
//  Instagram
//
//  Created by Admin on 10.02.2021.
//

import UIKit

extension UIImage {
    func instagramCrop() -> UIImage? {
        guard let optimalSize = findOptimalSize() else { return nil }
        
        let xOffset = (size.width - optimalSize.width) / 2
        let yOffset = (size.height - optimalSize.height) / 2
        let cropRect = CGRect(x: xOffset, y: yOffset, width: optimalSize.width, height: optimalSize.height)
        
        guard let cgImage = cgImage?.cropping(to: cropRect) else { return nil }
        
        let croppedImage = UIImage(cgImage: cgImage)
        
        return croppedImage
    }
}

// MARK: - Private Constants

private extension UIImage {
    private enum AspectRatios {
        static let portrait: CGFloat = 0.8
        static let landscape: CGFloat = 1.91
    }
}

// MARK: - Private Methods

private extension UIImage {
    func findOptimalSize() -> CGSize? {
        var optimalSize: CGSize?
        
        let aspectRation = size.width / size.height
        
        if aspectRation < AspectRatios.portrait {
            let optimalHeight = UIImage.findOptimalInstagramHeight(height: size.height, width: size.width)
            
            optimalSize = CGSize(width: size.width, height: optimalHeight)
        } else if AspectRatios.landscape < aspectRation {
            let optimalWidth = UIImage.findOptimalInstagramWidth(height: size.height, width: size.width)
            
            optimalSize = CGSize(width: optimalWidth, height: size.height)
        }
        
        return optimalSize
    }
    
    static func findOptimalInstagramHeight(height: CGFloat, width: CGFloat) -> CGFloat {
        var minimumSize = 0
        var maximumSize = Int(height)
        var middleSize = maximumSize

        while minimumSize < maximumSize {
            middleSize = minimumSize + (maximumSize - minimumSize) / 2
            
            let currentAspectRatio = width / CGFloat(middleSize)

            if currentAspectRatio == AspectRatios.portrait {
                return CGFloat(middleSize)
            } else if AspectRatios.portrait < currentAspectRatio {
                minimumSize = middleSize + 1
            } else {
                maximumSize = middleSize
            }
        }

        return CGFloat(middleSize)
    }
    
    static func findOptimalInstagramWidth(height: CGFloat, width: CGFloat) -> CGFloat {
        var minimumSize = 0
        var maximumSize = Int(width)
        var middleSize = maximumSize

        while minimumSize < maximumSize {
            middleSize = minimumSize + (maximumSize - minimumSize) / 2
            
            let currentAspectRatio = CGFloat(middleSize) / height

            if currentAspectRatio == AspectRatios.landscape {
                return CGFloat(middleSize)
            } else if currentAspectRatio < AspectRatios.landscape {
                minimumSize = middleSize + 1
            } else {
                maximumSize = middleSize
            }
        }

        return CGFloat(middleSize)
    }
}
